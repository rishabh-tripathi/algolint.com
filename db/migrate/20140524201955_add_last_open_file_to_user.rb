class AddLastOpenFileToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_open_file, :integer
  end
end
