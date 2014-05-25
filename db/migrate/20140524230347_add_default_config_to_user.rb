class AddDefaultConfigToUser < ActiveRecord::Migration
  def change
    add_column :users, :default_font_size, :integer
    add_column :users, :default_theme, :integer
  end
end
