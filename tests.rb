require_relative 'curl_requests.rb'
require "minitest/autorun"

class Curl_requests_test < Minitest::Test
	curl_requests = Curlrequests.new

def test_for_status_code
	saying = {"text":"Joe"}

assert_equal(200,curl_requests.post_request(saying))
end


end
