class RemovePositionFromCategoriesCorrect < ActiveRecord::Migration[8.0]
  def change
    remove_column :categories, :position, :integer
  end
end
