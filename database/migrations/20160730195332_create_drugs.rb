class CreateDrugs < ActiveRecord::Migration[5.0]
  def change
    create_table :drugs, id: :uuid do |t|
      t.string :registered_name, null: false
      t.string :active_ingredient
      t.string :pharmaceutical_form
      t.string :insurance_list
      t.string :issuing
      t.string :atc
      t.string :license_holder

      t.timestamps null: false
    end
    add_index :drugs, :registered_name
    add_index :drugs, :active_ingredient
    add_index :drugs, :issuing
  end
end
