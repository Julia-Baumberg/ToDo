# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.create!(
  name: 'Admin',
  email: 'admin@fake.com',
  password: 'password123',
  username: 'admin',
  admin: true
  )

User.create!(
  name: 'John',
  email: 'john.doe@fake.com',
  password: 'password123',
  username: 'johnd',
  admin: false
)

User.create!(
  name: 'Jane',
  email: 'jane.doe@fake.com',
  password: 'password123',
  username: 'janed',
  admin: false
)

User.all.each do |user|
  5.times do
    Task.create!(
      title: Faker::Games::DnD.title_name,
      description: Faker::Food.description,
      priority: rand(1..5),
      due_date: 2.days.from_now,
      user:
    )
  end
end
