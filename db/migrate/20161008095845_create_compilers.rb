class CreateCompilers < ActiveRecord::Migration
  def change
    create_table :compilers do |t|
      t.string :name
      t.string :description
      t.integer :language_id
      t.string :image_id
      t.string :run_config
      t.timestamps
    end
  end
end
