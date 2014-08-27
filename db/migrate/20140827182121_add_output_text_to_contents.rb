class AddOutputTextToContents < ActiveRecord::Migration
  def change
    add_column :contents, :output_text, :text
  end
end
