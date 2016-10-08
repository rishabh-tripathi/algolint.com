class CreateContainerStacks < ActiveRecord::Migration
  def change
    create_table :container_stacks do |t|
      t.string :name
      t.integer :image_type
      t.integer :language_id
      t.integer :compiler_id
      t.string :image_id
      t.integer :count
      t.string :dependency
      t.integer :status
      t.integer :created_by

      t.timestamps
    end
  end
end
