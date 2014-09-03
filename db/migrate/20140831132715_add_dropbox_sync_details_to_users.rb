class AddDropboxSyncDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :dropbox_sync_status, :integer
    add_column :users, :dropbox_last_sync_at, :datetime
  end
end
