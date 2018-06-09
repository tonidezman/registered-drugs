class Drug < ActiveRecord::Base
  validates :registered_name, presence: true

end
