class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.integer :user_id
      t.string :name
      t.string :desc
      t.text :content
      t.integer :type
      t.integer :compile
      t.integer :status
      t.integer :sharability

      t.timestamps
    end
  end
end
