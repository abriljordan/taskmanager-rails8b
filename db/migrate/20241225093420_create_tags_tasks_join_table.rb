class CreateTagsTasksJoinTable < ActiveRecord::Migration[8.0]
  def change
    create_join_table :tags, :tasks do |t|
      t.index [ :tag_id, :task_id ], unique: true
      t.index [ :task_id, :tag_id ], unique: true
    end

    # Add foreign key constraints
    add_foreign_key :tags_tasks, :tags
    add_foreign_key :tags_tasks, :tasks
  end
end
