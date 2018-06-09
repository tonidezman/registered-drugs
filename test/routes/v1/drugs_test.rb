require_relative '../../test_helper'

class ApiV1DrugstTest < ApiV1TestCase
  def test_get_drugs
    get '/v1/drugs'
    assert_equal 1, json_response.size
  end
end
