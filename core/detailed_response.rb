class DetailedResponse
  attr_reader :status, :headers, :body
  def initialize(response)
    @headers = response.headers.to_hash
    @body = response.body
    @body = JSON.parse(response.body) if @headers.key?("content-type") && @headers["content-type"] == "application/json"
  end
end