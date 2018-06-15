# frozen_string_literal: true

require("json")
require("erb")
require("rubygems")
require("http")
require("stringio")
require_relative("detailed_response")
require_relative("watson_api_exception.rb")
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
  include ERB::Util
  attr_accessor :url, :username, :password
  attr_reader :conn
  def initialize(vars)
    @url = vars[:url] unless vars[:url].nil?
    @username = vars[:username] unless vars[:username].nil?
    @password = vars[:password] unless vars[:password].nil?
    @conn = HTTP::Client.new(
      headers: {
        "User-Agent" => "IBM-Ruby-SDK-Service"
      }
    ).basic_auth(
      user: @username,
      pass: @password
    ).timeout(
      :per_operation,
      read: 60,
      write: 60,
      connect: 60
    )
  end

  def add_default_headers(headers: {})
    raise TypeError unless headers.instance_of?(Hash)
    headers.each_pair { |k, v| @conn.default_options.headers.add(k, v) }
  end

  def request(args)
    defaults = { method: nil, url: nil, accept_json: false, headers: nil, params: nil, json: {}, data: nil }
    args = defaults.merge(args)
    args[:data].delete_if { |_k, v| v.nil? } if args[:data].instance_of?(Hash)
    if args[:data].respond_to?(:merge)
      args[:json] = args[:data].merge(args[:json]) unless args[:data].instance_of?(String)
    end
    args[:json] = args[:data] if args[:json].empty? || (args[:data].instance_of?(String) && !args[:data].empty?)
    args[:json].delete_if { |_k, v| v.nil? } if args[:json].instance_of?(Hash)
    args[:headers]["Accept"] = "application/json" if args[:accept_json]
    args[:headers]["Content-Type"] = "application/json" unless args[:headers].key?("Content-Type")
    args[:json] = args[:json].to_json if args[:json].instance_of?(Hash)
    args[:headers].delete_if { |_k, v| v.nil? } if args[:headers].instance_of?(Hash)
    args[:params].delete_if { |_k, v| v.nil? } if args[:params].instance_of?(Hash)
    # args[:files].delete_if { |_, v| v.nil? } if args.key?(:files)
    args.delete_if { |_, v| v.nil? }
    # args.delete_if { |_, v| v.respond_to?("empty") && v.empty? }
    # args.delete(:files) if args.key?(:files) && args[:files].empty?
    args[:headers].delete("Content-Type") if args.key?(:form) || args[:json].nil?
    if args.key?(:form)
      response = @conn.persistent(@url, timeout: 10).follow.request(
        args[:method],
        HTTP::URI.parse(@url + args[:url]),
        headers: @conn.default_options.headers.merge(HTTP::Headers.coerce(args[:headers])),
        params: args[:params],
        form: args[:form]
        # form: {
        #   filename: args[:files]["file"][0],
        #   file: args[:files]["file"][1].instance_of?(StringIO) ? args[:files]["file"][1] : HTTP::FormData::File.new(args[:files]["file"][1].path)
        # }
      )
    end
    unless args.key?(:form)
      response = @conn.persistent(@url, timeout: 10).follow.request(
        args[:method],
        HTTP::URI.parse(@url + args[:url]),
        headers: @conn.default_options.headers.merge(HTTP::Headers.coerce(args[:headers])),
        body: args[:json],
        params: args[:params]
      )
    end
    response[:http_version] = 1.1
    return DetailedResponse.new(response: response) if (200..299).cover?(response.code)
    raise WatsonApiException.new(response: response)
    # DetailedResponse.new(response: response)
  end
end
