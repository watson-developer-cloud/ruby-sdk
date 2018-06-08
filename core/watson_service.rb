# frozen_string_literal: true

require("faraday")
require("json")
require("cgi")
require("rubygems")
require("excon")
require_relative("detailed_response")
require_relative("watson_api_exception.rb")

# Class for interacting with the Watson API
class WatsonService
  attr_accessor :url, :username, :password
  attr_reader :conn
  def initialize(vars)
    @url = vars[:url] unless vars[:url].nil?
    @username = vars[:username] unless vars[:username].nil?
    @password = vars[:password] unless vars[:password].nil?
    @conn = Faraday.new(url: @url) do |connection|
      connection.basic_auth(@username, @password)
      connection.headers["Content-Type"] = "application/json"
      connection.headers["User-Agent"] = "IBM-Ruby-SDK-Service"
      # connection.response :logger
      connection.request :multipart
      connection.request(:url_encoded)
      connection.adapter(:excon)
    end
  end

  def request(args)
    defaults = { method: nil, url: nil, accept_json: false, headers: nil, params: nil, json: {}, data: {} }
    args = defaults.merge(args)
    args[:data].delete_if { |_k, v| v.nil? } if args[:data].instance_of?(Hash)
    args[:json] = args[:data].merge(args[:json]) unless args[:data].nil? || args[:data].instance_of?(String)
    args[:json] = args[:data] if args[:json].empty?
    args[:json].delete_if { |_k, v| v.nil? } if args[:json].instance_of?(Hash)
    args[:headers]["Accept"] = "application/json" if args[:accept_json]
    args.reject { |_, value| value.nil? }
    args[:json] = args[:json].to_json if args[:json].instance_of?(Hash)
    args.delete_if { |_k, v| v.nil? }
    args[:headers].delete_if { |_k, v| v.nil? } if args[:headers].instance_of?(Hash)
    args[:params].delete_if { |_k, v| v.nil? } if args[:params].instance_of?(Hash)
    request_obj = conn.build_request(args[:method]) do |req|
      req.url(args[:url])
      req.headers.merge!(args[:headers])
      req.body = args[:json] unless args[:json].empty?
      req.params = args[:params] unless args[:params].nil?
    end
    response = conn.app.call(request_obj.to_env(conn))
    return DetailedResponse.new(response: response) if (response.status >= 200) && (response.status <= 299)
    raise WatsonApiException.new(response: response)
    # DetailedResponse.new(response: response)
  end
end
