require("json")

class DetailedResponse
  attr_reader :status, :headers, :body
  def initialize(status: nil, headers: nil, body: nil, response: {})
    if status.nil? || headers.nil? || body.nil?
      @status = response.status
      @headers = response.headers
      @headers = response.headers.to_hash if response.headers.respond_to?("to_hash")
      @body = response.body
      @body = JSON.parse(response.body) if @headers.key?("Content-Type") && @headers["Content-Type"] == "application/json"
    else
      @status = status
      @headers = headers
      @body = body
    end
  end
end
