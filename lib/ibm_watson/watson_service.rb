# frozen_string_literal: true

require("http")
require("rbconfig")
require("stringio")
require("json")
require_relative("./detailed_response.rb")
require_relative("./watson_api_exception.rb")
require_relative("./iam_token_manager.rb")
require_relative("./version.rb")
# require("httplog")
# HttpLog.configure do |config|
#   config.log_connect   = true
#   config.log_request   = true
#   config.log_headers   = true
#   config.log_data      = true
#   config.log_status    = true
#   config.log_response  = true
# end

# Class for interacting with the Watson API
class WatsonService
  attr_accessor :password, :url, :username
  attr_reader :conn, :token_manager
  def initialize(vars)
    defaults = {
      vcap_services_name: nil,
      username: nil,
      password: nil,
      use_vcap_services: true,
      api_key: nil,
      iam_apikey: nil,
      iam_access_token: nil,
      iam_url: nil
    }
    vars = defaults.merge(vars)
    @url = vars[:url]
    @username = nil
    @password = nil
    @token_manager = nil
    @temp_headers = nil
    @icp_prefix = vars[:password]&.start_with?("icp-") ? true : false

    user_agent_string = "watson-apis-ruby-sdk-" + IBMWatson::VERSION
    user_agent_string += " #{RbConfig::CONFIG["host"]}"
    user_agent_string += " #{RbConfig::CONFIG["RUBY_BASE_NAME"]}-#{RbConfig::CONFIG["RUBY_PROGRAM_VERSION"]}"

    headers = {
      "User-Agent" => user_agent_string
    }
    if vars[:use_vcap_services]
      @vcap_service_credentials = load_from_vcap_services(service_name: vars[:vcap_services_name])
      if !@vcap_service_credentials.nil? && @vcap_service_credentials.instance_of?(Hash)
        @url = @vcap_service_credentials["url"]
        @username = @vcap_service_credentials["username"] if @vcap_service_credentials.key?("username")
        @password = @vcap_service_credentials["password"] if @vcap_service_credentials.key?("password")
        @iam_apikey = @vcap_service_credentials["iam_apikey"] if @vcap_service_credentials.key?("iam_apikey")
        @iam_access_token = @vcap_service_credentials["iam_access_token"] if @vcap_service_credentials.key?("iam_access_token")
        @iam_url = @vcap_service_credentials["iam_url"] if @vcap_service_credentials.key?("iam_url")
      end
    end

    if !vars[:iam_access_token].nil? || !vars[:iam_apikey].nil?
      set_token_manager(iam_apikey: vars[:iam_apikey], iam_access_token: vars[:iam_access_token], iam_url: vars[:iam_url])
    elsif !vars[:username].nil? && !vars[:password].nil?
      if vars[:username] == "apikey" && !@icp_prefix
        iam_apikey(iam_apikey: vars[:password])
      else
        @username = vars[:username]
        @password = vars[:password]
      end
    end

    @conn = HTTP::Client.new(
      headers: headers
    )
  end

  def load_from_vcap_services(service_name:)
    vcap_services = ENV["VCAP_SERVICES"]
    unless vcap_services.nil?
      services = JSON.parse(vcap_services)
      return services[service_name][0]["credentials"] if services.key?(service_name)
    end
    nil
  end

  def add_default_headers(headers: {})
    raise TypeError unless headers.instance_of?(Hash)

    headers.each_pair { |k, v| @conn.default_options.headers.add(k, v) }
  end

  def iam_access_token(iam_access_token:)
    @token_manager = IAMTokenManager.new(iam_access_token: iam_access_token) if @token_manager.nil?
    @iam_access_token = iam_access_token
  end

  def iam_apikey(iam_apikey:)
    @token_manager = IAMTokenManager.new(iam_apikey: iam_apikey) if @token_manager.nil?
    @iam_apikey = iam_apikey
  end

  # @return [DetailedResponse]
  def request(args)
    defaults = { method: nil, url: nil, accept_json: false, headers: nil, params: nil, json: {}, data: nil }
    args = defaults.merge(args)
    args[:data].delete_if { |_k, v| v.nil? } if args[:data].instance_of?(Hash)
    args[:json] = args[:data].merge(args[:json]) if args[:data].respond_to?(:merge)
    args[:json] = args[:data] if args[:json].empty? || (args[:data].instance_of?(String) && !args[:data].empty?)
    args[:json].delete_if { |_k, v| v.nil? } if args[:json].instance_of?(Hash)
    args[:headers]["Accept"] = "application/json" if args[:accept_json] && args[:headers]["Accept"].nil?
    args[:headers]["Content-Type"] = "application/json" unless args[:headers].key?("Content-Type")
    args[:json] = args[:json].to_json if args[:json].instance_of?(Hash)
    args[:headers].delete_if { |_k, v| v.nil? } if args[:headers].instance_of?(Hash)
    args[:params].delete_if { |_k, v| v.nil? } if args[:params].instance_of?(Hash)
    args[:form].delete_if { |_k, v| v.nil? } if args.key?(:form)
    args.delete_if { |_, v| v.nil? }
    args[:headers].delete("Content-Type") if args.key?(:form) || args[:json].nil?

    if @username == "apikey" && !@icp_prefix
      iam_apikey(iam_apikey: @password)
      @username = nil
    end

    conn = @conn
    if !@token_manager.nil?
      access_token = @token_manager.token
      args[:headers]["Authorization"] = "Bearer #{access_token}"
    elsif !@username.nil? && !@password.nil?
      conn = @conn.basic_auth(user: @username, pass: @password)
    end

    args[:headers] = args[:headers].merge(@temp_headers) unless @temp_headers.nil?
    @temp_headers = nil unless @temp_headers.nil?

    if args.key?(:form)
      response = conn.follow.request(
        args[:method],
        HTTP::URI.parse(@url + args[:url]),
        headers: conn.default_options.headers.merge(HTTP::Headers.coerce(args[:headers])),
        params: args[:params],
        form: args[:form]
      )
    else
      response = conn.follow.request(
        args[:method],
        HTTP::URI.parse(@url + args[:url]),
        headers: conn.default_options.headers.merge(HTTP::Headers.coerce(args[:headers])),
        body: args[:json],
        params: args[:params]
      )
    end
    return DetailedResponse.new(response: response) if (200..299).cover?(response.code)

    raise WatsonApiException.new(response: response)
  end

  # @note Chainable
  # @param headers [Hash] Custom headers to be sent with the request
  # @return [self]
  def headers(headers)
    raise TypeError("Expected Hash type, received #{headers.class}") unless headers.instance_of?(Hash)

    @temp_headers = headers
    self
  end

  # @!method configure_http_client(proxy: {}, timeout: {}, disable_ssl: false)
  # Sets the http client config, currently works with timeout and proxies
  # @param proxy [Hash] The hash of proxy configurations
  # @option proxy address [String] The address of the proxy
  # @option proxy port [Integer] The port of the proxy
  # @option proxy username [String] The username of the proxy, if authentication is needed
  # @option proxy password [String] The password of the proxy, if authentication is needed
  # @option proxy headers [Hash] The headers to be used with the proxy
  # @param timeout [Hash] The hash for configuring timeouts. `per_operation` has priority over `global`
  # @option timeout per_operation [Hash] Timeouts per operation. Requires `read`, `write`, `connect`
  # @option timeout global [Integer] Upper bound on total request time
  # @param disable_ssl [Boolean] Disable the SSL verification (Note that this has serious security implications - only do this if you really mean to!)
  def configure_http_client(proxy: {}, timeout: {}, disable_ssl: false)
    raise TypeError("proxy parameter must be a Hash") unless proxy.empty? || proxy.instance_of?(Hash)

    raise TypeError("timeout parameter must be a Hash") unless timeout.empty? || timeout.instance_of?(Hash)

    if disable_ssl
      ssl_context = OpenSSL::SSL::SSLContext.new
      ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE
      @conn.default_options = { ssl_context: ssl_context }
    end
    add_proxy(proxy) unless proxy.empty? || !proxy.dig(:address).is_a?(String) || !proxy.dig(:port).is_a?(Integer)
    add_timeout(timeout) unless timeout.empty? || (!timeout.key?(:per_operation) && !timeout.key?(:global))
  end

  private

  def set_token_manager(iam_apikey: nil, iam_access_token: nil, iam_url: nil)
    @iam_apikey = iam_apikey
    @iam_access_token = iam_access_token
    @iam_url = iam_url
    @token_manager = IAMTokenManager.new(iam_apikey: iam_apikey, iam_access_token: iam_access_token, iam_url: iam_url)
  end

  def add_timeout(timeout)
    if timeout.key?(:per_operation)
      raise TypeError("per_operation in timeout must be a Hash") unless timeout[:per_operation].instance_of?(Hash)

      defaults = {
        write: 0,
        connect: 0,
        read: 0
      }
      time = defaults.merge(timeout[:per_operation])
      @conn = @conn.timeout(:per_operation, write: time[:write], connect: time[:connect], read: time[:read])
    else
      raise TypeError("global in timeout must be an Integer") unless timeout[:global].is_a?(Integer)

      @conn = @conn.timeout(:global, write: timeout[:global], connect: 0, read: 0)
    end
  end

  def add_proxy(proxy)
    if (proxy[:username].nil? || proxy[:password].nil?) && proxy[:headers].nil?
      @conn = @conn.via(proxy[:address], proxy[:port])
    elsif !proxy[:username].nil? && !proxy[:password].nil? && proxy[:headers].nil?
      @conn = @conn.via(proxy[:address], proxy[:port], proxy[:username], proxy[:password])
    elsif !proxy[:headers].nil? && (proxy[:username].nil? || proxy[:password].nil?)
      @conn = @conn.via(proxy[:address], proxy[:port], proxy[:headers])
    else
      @conn = @conn.via(proxy[:address], proxy[:port], proxy[:username], proxy[:password], proxy[:headers])
    end
  end
end
