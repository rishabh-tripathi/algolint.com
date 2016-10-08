class CreateImageConfigs < ActiveRecord::Migration
  def change
    create_table :image_configs do |t|
      t.integer :image_type
      t.integer :image_id
      t.text :dockerfile
      t.text :startup_config
      t.string :access_config
      t.integer :default_port

      t.timestamps
    end
  end
end
