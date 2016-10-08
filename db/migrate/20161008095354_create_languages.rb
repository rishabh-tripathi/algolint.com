class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :name
      t.string :description
      t.string :how_to
      t.timestamps
    end
  end
end
