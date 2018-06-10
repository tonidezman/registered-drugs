require_relative '../test_helper'

class DrugTest < TestCase
  def test_update
    drug = drugs(:a)
    drug.registered_name = 'Drug B'
    assert drug.save
  end
end
