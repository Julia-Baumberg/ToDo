# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.create(email: 'admin@fake.com',
  first_name: 'Admin',
  last_name: 'AlsoAdmin',
  name: 'Admin AlsoAdmin',
  password: 'password123',
  username: 'admin',
  admin: true)

User.create(email: 'john.doe@fake.com',
  first_name: 'John',
  last_name: 'Doe',
  name: 'John Doe',
  password: 'password123',
  username: 'johnd',
  admin: false)

User.create(email: 'jane.doe@fake.com',
  first_name: 'Jane',
  last_name: 'Doe',
  name: 'Jane Doe',
  password: 'password123',
  username: 'janed',
  admin: false)

User.create(email: 'swablu.email@fake.com',
  first_name: 'Swablu',
  last_name: 'Baumby',
  name: 'Swablu Baumby',
  password: 'password123',
  username: 'swablu',
  admin: false)

User.create(email: 'mattthematt@fake.com',
  first_name: 'Matt',
  last_name: 'theMatt',
  name: 'Matt theMatt',
  password: 'password123',
  username: 'Matt',
  admin: true)

User.all.each do |user|
  next if user.tasks.exists?

  5.times do
    value = [true, false].sample
    Task.create!(
      title: Faker::Games::DnD.title_name,
      description: Faker::Food.description,
      priority: rand(1..5),
      due_date: 2.days.from_now,
      user: user,
      is_completed: value,
    )
  end
end


admins = User.where(admin: true).to_a

Task.find_each do |task|
  next if task.comments.exists?

  allowed_commenters = admins + [task.user]

  rand(1..3).times do
    commenter = allowed_commenters.sample
    task.comments.create!(
      user: commenter,
      content: Faker::Lorem.paragraph_by_chars(number: 140)
    )
  end
end
