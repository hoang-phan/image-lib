class AddExtensionToImages < ActiveRecord::Migration[8.0]
  def change
    add_column :images, :extension, :string
  end
end
