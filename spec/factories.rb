FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :entry do
    title   "title loresum"
  	body    "loresum content loresum content loresum content loresum content
             loresum content loresum content loresum content loresum content
             loresum content loresum content loresum content loresum content"
  	user_id 1
  end

  # factory :UserMailer d
end