class AddTemplateFieldToContents < ActiveRecord::Migration
  def change
    add_column :contents, :template, :integer
  end
end
