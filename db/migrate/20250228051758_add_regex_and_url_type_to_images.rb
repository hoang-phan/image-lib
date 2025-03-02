class AddRegexAndUrlTypeToImages < ActiveRecord::Migration[8.0]
  def change
    add_column :images, :regex, :string
  end
end
