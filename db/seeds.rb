# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Category.destroy_all
Task.destroy_all

# Create categories
category1 = Category.create(name: 'Work')
category2 = Category.create(name: 'Personal')
category3 = Category.create(name: 'Urgent')

# Create tasks and associate them with categories
Task.create([
  { name: 'Finish project report', position: 1, completed: false, description: 'Complete the final report for the project.', category: category1 },
  { name: 'Buy groceries', position: 2, completed: false, description: 'Get milk, eggs, and bread.', category: category2 },
  { name: 'Prepare for meeting', position: 3, completed: false, description: 'Gather all necessary materials for the meeting.', category: category1 },
  { name: 'Walk the dog', position: 4, completed: false, description: 'Take the dog for a walk in the evening.', category: category2 },
  { name: 'Respond to emails', position: 5, completed: true, description: 'Reply to all pending emails.', category: category3 }
])
