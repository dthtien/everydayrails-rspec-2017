class AddHiddenToContacts < ActiveRecord::Migration[5.2]
  def change
    add_column :contacts, :hidden, :bool, default: false
  end
end
