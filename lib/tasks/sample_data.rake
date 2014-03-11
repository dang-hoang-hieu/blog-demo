namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_entries
    make_relationships
  end
end

def make_users
  admin = User.create!(name:     "Example User",
                       email:    "example@railstutorial.org",
                       password: "foobar",
                       password_confirmation: "foobar",
                       admin: true)
  40.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_entries
  users = User.all(limit: 10)
  10.times do
    body = Faker::Lorem.sentence(10)
    title = Faker::Lorem.sentence(1)
    users.each { |user| 
      entry = user.entries.create!(title: title, body: body) 
      5.times do
        content = Faker::Lorem.sentence(2)
        user.comments.create!(content: content, entry: entry)
      end
    }
  end
end

def make_relationships
  users = User.all
  user  = users.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end