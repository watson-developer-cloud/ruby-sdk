# frozen_string_literal: true

require("json")
require("erb")
require("rubygems")
require("excon")
require_relative("detailed_response")
require_relative("watson_api_exception.rb")

# Class for interacting with the Watson API
class WatsonService
  include ERB::Util
  attr_accessor :url, :username, :password
  attr_reader :conn
  def initialize(vars)
    @url = vars[:url] unless vars[:url].nil?
    @username = vars[:username] unless vars[:username].nil?
    @password = vars[:password] unless vars[:password].nil?
    @conn = Excon.new(
      @url,
      headers: {
        "User-Agent" => "IBM-Ruby-SDK-Service",
        "Content-Type" => "application/json"
      },
      # debug_request: true,
      # debug_response: true,
      # instrumentor: Excon::StandardInstrumentor,
      user: @username,
      password: @password
    )
  end

  def add_default_headers(headers: {})
    raise TypeError unless headers.instance_of?(Hash)
    headers.each_pair { |k, v| @conn.headers[k] = v }
  end

  def request(args)
    defaults = { method: nil, url: nil, accept_json: false, headers: nil, params: nil, json: {}, data: nil }
    args = defaults.merge(args)
    args[:data].delete_if { |_k, v| v.nil? } if args[:data].instance_of?(Hash)
    args[:json] = args[:data].merge(args[:json]) unless args[:data].nil? || args[:data].instance_of?(String)
    args[:json] = args[:data] if args[:json].empty? || (args[:data].instance_of?(String) && !args[:data].empty?)
    args[:json].delete_if { |_k, v| v.nil? } if args[:json].instance_of?(Hash)
    args[:headers]["Accept"] = "application/json" if args[:accept_json]
    args.reject { |_, value| value.nil? }
    args[:json] = args[:json].to_json if args[:json].instance_of?(Hash)
    args.delete_if { |_k, v| v.nil? }
    args[:headers].delete_if { |_k, v| v.nil? } if args[:headers].instance_of?(Hash)
    args[:params].delete_if { |_k, v| v.nil? } if args[:params].instance_of?(Hash)
    response = @conn.request(
      method: args[:method],
      path: @conn.data[:path] + args[:url],
      headers: @conn.data[:headers].merge(args[:headers]),
      body: args[:json],
      query: args[:params]
    )
    return DetailedResponse.new(response: response) if (200..299).cover?(response.status)
    raise WatsonApiException.new(response: response)
    # DetailedResponse.new(response: response)
  end
end
