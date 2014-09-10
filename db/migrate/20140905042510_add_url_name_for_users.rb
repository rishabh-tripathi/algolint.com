class AddUrlNameForUsers < ActiveRecord::Migration
  def change
    add_column :users, :url_name, :string
  end
end
