require_relative '../test_helper'

class DrugsTest < TestCase
  def test_update
    drug = drugs(:a)
    drug.name = 'Drug B'
    assert widget.save
  end
end
