class AddTemplateCatFieldToContents < ActiveRecord::Migration
  def change
    add_column :contents, :template_cat, :integer
  end
end
