require("faraday")
require("json")
require("cgi")
require("rubygems")
require("excon")
require_relative("detailed_response")

class WatsonService
  attr_accessor :url, :username, :password
  attr_reader :conn
  def initialize(vars)
    @url = vars[:url] unless vars[:url].nil?
    @username = vars[:username] unless vars[:username].nil?
    @password = vars[:password] unless vars[:password].nil?
    @conn = Faraday.new(url: @url) do |connection|
      connection.basic_auth(@username, @password)
      connection.headers["content-type"] = "application/json"
      # connection.response :logger
      connection.request :multipart
      connection.request(:url_encoded)
      connection.adapter(Faraday.default_adapter) #:net_http
    end
  end

  def request(args)
    defaults = { method: nil, url: nil, accept_json: false, headers: nil, params: nil, json: {}, data: {} }
    args = defaults.merge(args)
    args[:json] = args[:data].merge(args[:json]) unless args[:data].nil? || args[:data].instance_of?(String)
    args[:json] = args[:data] if args[:json].empty?
    args[:headers]["Accept"] = "application/json" if args[:accept_json]
    args.reject { |_, value| value.nil? }
    args[:json] = args[:json].to_json if args[:json].instance_of?(Hash)
    # args[:json].select {|_, value| !value.nil?}
    args.delete_if { |_k, v| v.nil? }
    args[:headers].delete_if { |_k, v| v.nil? } if args[:headers].instance_of?(Hash)
    args[:params].delete_if { |_k, v| v.nil? } if args[:params].instance_of?(Hash)
    request_obj = conn.build_request(args[:method]) do |req|
      req.url(args[:url])
      req.headers.merge!(args[:headers])
      req.body = args[:json] unless args[:json].empty?
      req.params = args[:params] unless args[:params].nil?
    end
    response = conn.builder.build_response(conn, request_obj)
    DetailedResponse.new(response)
  end
end
