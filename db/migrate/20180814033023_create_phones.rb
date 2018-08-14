class CreatePhones < ActiveRecord::Migration[5.2]
  def change
    create_table :phones do |t|
      t.references :contact, foreign_key: true
      t.string :phone
      t.string :phone_type

      t.timestamps
    end
  end
end
