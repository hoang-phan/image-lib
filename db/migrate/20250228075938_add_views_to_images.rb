class AddViewsToImages < ActiveRecord::Migration[8.0]
  def change
    add_column :images, :views, :integer, default: 0
  end
end
