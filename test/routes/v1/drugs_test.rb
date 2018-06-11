require_relative '../../test_helper'

class ApiV1DrugstTest < ApiV1TestCase
  def test_drug_lists_all_drugs
    get '/v1/drugs'
    assert_equal 5, json_response.size
  end

  def test_help_route
    get '/v1/search/help'
    assert last_response.status == 200
    assert_equal 3, json_response.size
  end

  def test_when_there_is_no_user_type
    get '/v1/search'
    assert json_response.key?(:error)
  end

  def test_incorrect_user_type
    get '/v1/search?user_type=unknown'
    assert json_response.key?(:error)
  end

  def test_returns_prescription_drugs
    get '/v1/search?user_type=MD'
    assert_equal 3, json_response.size
  end

  def test_returns_filtered_drugs_for_students
    get '/v1/search?user_type=Student'
    assert_equal 2, json_response.size
  end

  def test_returns_filtered_drugs_for_others
    get '/v1/search?user_type=Other'
    assert_equal 2, json_response.size
  end

  def test_one_right_drug_argument
    get '/v1/search?user_type=MD&registered_name=a'
    assert_equal 1, json_response.size
    assert_equal "Drug A", json_response[0][:registered_name]
  end

  def test_one_right_drug_argument_for_other_user_type
    get '/v1/search?user_type=Other&registered_name=a'
    assert_equal 0, json_response.size
  end

  def test_one_wrong_drug_argument
    get '/v1/search?user_type=MD&unknown_attr=a'
    assert json_response.key?(:error)
  end

  def test_two_right_drug_arguments_for_prescription_drugs
    get '/v1/search?user_type=MD&registered_name=Drug&pharmaceutical_form=x'
    assert_equal 2, json_response.size
  end

  def test_two_right_drug_arguments_for_students
    get '/v1/search?user_type=Student&registered_name=Drug&pharmaceutical_form=x'
    assert_equal 1, json_response.size
  end

  def test_two_wrong_drug_arguments
    get '/v1/search?user_type=Student&registered_name=Drug&nonexisting=x'
    assert json_response.key?(:error)
  end

  def test_three_right_drug_arguments
    get '/v1/search?user_type=Student&registered_name=Drug&pharmaceutical_form=x&atc=something'
    assert json_response.key?(:error)
  end

  def test_three_wrong_drug_arguments
    get '/v1/search?user_type=Student&xregistered_name=Drug&xpharmaceutical_form=x&xatc=something'
    assert json_response.key?(:error)
  end

  def test_student_cannot_change_issuing
    get '/v1/search?user_type=Student&issuing=R'
    assert json_response.key?(:error)
  end

  def test_others_cannot_change_issuing
    get '/v1/search?user_type=Other&issuing=R'
    assert json_response.key?(:error)
  end

  def test_doctors_can_change_issuing
    get '/v1/search?user_type=MD&issuing=x'
    assert_equal 0, json_response.size
  end
  def test_md_adds_another_issuing
    get '/v1/search?user_type=MD&issuing=R'
    assert_equal 2, json_response.size
  end

end
