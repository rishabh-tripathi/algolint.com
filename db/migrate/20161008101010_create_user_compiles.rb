class CreateUserCompiles < ActiveRecord::Migration
  def change
    create_table :user_compiles do |t|
      t.integer :user_id
      t.integer :content_id
      t.integer :language_id
      t.integer :compiler_id
      t.integer :status
      t.string :dependency

      t.timestamps
    end
  end
end
