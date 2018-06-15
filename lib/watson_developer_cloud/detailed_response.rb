# frozen_string_literal: true

require("json")

# Custom class for objects returned from API calls
class DetailedResponse
  attr_reader :status, :headers, :body
  def initialize(status: nil, headers: nil, body: nil, response: nil)
    if status.nil? || headers.nil? || body.nil?
      @status = response.code
      @headers = response.headers.to_h
      @headers = response.headers.to_hash if response.headers.respond_to?("to_hash")
      @body = response.body.to_s
      @body = JSON.parse(response.body.to_s) if !response.body.to_s.empty? && @headers.key?("Content-Type") && @headers["Content-Type"] == "application/json"
    else
      @status = status
      @headers = headers
      @body = body
    end
  end
end
