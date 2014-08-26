class AddDefaultKdybindToUsers < ActiveRecord::Migration
  def change
    add_column :users, :default_keybind, :integer
  end
end
