class DetailedResponse
  attr_reader :status, :headers, :body
  def initialize(response)
    unless response.instance_variable_defined?("@is_testing")
      temp_bool = false
    else
      temp_bool = response.instance_variable_get("@is_testing")
    end
    @status = response.status
    @headers = response.headers
    @headers = response.headers.to_hash if response.headers.respond_to?("to_hash")
    @body = response.body
    @body = JSON.parse(response.body) if (@headers.key?("content-type") || @headers.key?("Content-Type")) && (@headers["content-type"] == "application/json" || @headers["Content-Type"] == "application/json") && (temp_bool == false) 
  end
end
