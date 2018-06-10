class Drug < ActiveRecord::Base
  validates :registered_name, presence: true

  def self.columns_exist?(params)
    params.each do |key, _|
      next if key == "user_type"
      unless ActiveRecord::Base.connection.column_exists?(:drugs, key)
        return false
      end
    end
    true
  end
end
