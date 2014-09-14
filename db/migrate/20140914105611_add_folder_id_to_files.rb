class AddFolderIdToFiles < ActiveRecord::Migration
  def change
    add_column :contents, :folder_id, :integer, :default => 0
  end
end
