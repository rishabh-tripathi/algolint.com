class CreateContainers < ActiveRecord::Migration
  def change
    create_table :containers do |t|
      t.integer :type
      t.integer :stack_id
      t.string :host
      t.integer :port
      t.string :image_id
      t.integer :status
      t.integer :assigned_to

      t.timestamps
    end
  end
end
