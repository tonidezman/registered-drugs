require_relative '../test_helper'

class DrugTest < TestCase
  def test_update
    drug = drugs(:a)
    drug.registered_name = 'Drug B'
    assert drug.save
  end

  def test_column_exists_with_valid_columns
    valid_columns = {
      atc: 'RT',
      registered_name: 'some name'
    }
    assert Drug.columns_exist?(valid_columns)
  end

  def test_column_exists_with_invalid_columns
    valid_columns = {
      atc: 'RT',
      xregistered_name: 'some name'
    }
    assert !Drug.columns_exist?(valid_columns)
  end
end
