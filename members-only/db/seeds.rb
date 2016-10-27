# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
def user(name, email, password)
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password
    )
end

def post(title, content, user)
  Post.create!(
    title: title,
    content: content,
    user_id: user
    ) 
end


user("Example User", "members@example.com", "members_only")
user("Fred Mertz", "fred@ilovelucy.com", "password")
user("Ethel Mertz", "ethel@ilovelucy.com", "password")

post("My first post", "This is the content of my first post", 1)
post("What I heard last night", "You'll never believe it, but last night when I was walking by Lucy's apartment door...
", 3)
post("I can't believe I have to...", "Fix their leaky faucet again. Grumble, grumble.", 2)