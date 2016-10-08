class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :name
      t.string :description
      t.integer :type
      t.string :image_id
      t.string :version
      t.string :access
      t.string :how_to

      t.timestamps
    end
  end
end
