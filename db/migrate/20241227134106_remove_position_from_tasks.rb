class RemovePositionFromTasks < ActiveRecord::Migration[8.0]
  def change
    remove_column :tasks, :position, :integer
  end
end
