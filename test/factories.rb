FactoryBot.define do
  factory :registration do
    association :camp
    association :student
    payment "MyText"
  end
  factory :user do
    username "MyString"
    password_digest "MyString"
    role "parent"
    email "MyString@string.com"
    phone "408-307-0736"
    active true
  end
  factory :family do
    association :user
    family_name "MyString"
    parent_first_name "MyString"
    #user_id 1
    active true
  end
  factory :student do
    association :family
    first_name "Maitreyee"
    last_name "Deshpande"
    #family_id 1
    date_of_birth "1998-08-31"
    rating 400
    active true
  end
  
  factory :curriculum do
    name "Mastering Chess Tactics"
    description "This camp is designed for any student who has mastered basic mating patterns and understands opening principles and is looking to improve his/her ability use chess tactics in game situations."
    min_rating 400
    max_rating 850
    active true
  end
  
  factory :instructor do
    association :user
    first_name "Mark"
    last_name "Heimann"
    bio "Mark is currently among the top 150 players in the United States and has won 4 national scholastic chess championships."
    active true
  end
  
  factory :camp do 
    cost 150
    start_date Date.new(2018,7,16)
    end_date Date.new(2018,7,20)
    time_slot "am"
    max_students 8
    active true
    association :curriculum
    association :location
  end
  
  factory :camp_instructor do 
    association :camp
    association :instructor
  end
  

  factory :location do
    name "Carnegie Mellon"
    street_1 "5000 Forbes Avenue"
    street_2 "Porter Hall 222"
    city "Pittsburgh"
    state "PA"
    zip "15213"
    max_capacity 16
    active true
  end



end