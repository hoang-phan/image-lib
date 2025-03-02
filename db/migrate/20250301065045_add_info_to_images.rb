class AddInfoToImages < ActiveRecord::Migration[8.0]
  def change
    add_column :images, :width, :integer
    add_column :images, :height, :integer
    add_column :images, :size, :integer
    add_column :images, :avg_r, :integer
    add_column :images, :avg_g, :integer
    add_column :images, :avg_b, :integer
    add_column :images, :avg_a, :integer
    add_column :images, :k_val, :integer
    add_column :images, :similar_ids, :string
    add_index :images, :width
    add_index :images, :height
    add_index :images, :size
    add_index :images, :avg_r
    add_index :images, :avg_g
    add_index :images, :avg_b
    add_index :images, :avg_a
    add_index :images, :k_val
    add_index :images, :similar_ids
  end
end
