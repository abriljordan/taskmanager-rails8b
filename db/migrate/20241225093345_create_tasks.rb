class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.integer :position
      t.boolean :completed
      t.references :category, null: false, foreign_key: true
      t.integer :priority
      t.datetime :due_date

      t.timestamps
    end
  end
end
