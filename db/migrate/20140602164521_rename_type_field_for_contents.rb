class RenameTypeFieldForContents < ActiveRecord::Migration
  def change
    rename_column :contents, :type, :file_type
  end
end
