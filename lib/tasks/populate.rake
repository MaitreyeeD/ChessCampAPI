namespace :db do
  desc "Erase and fill database"
  # creating a rake task within db namespace called 'populate'
  # executing 'rake db:populate' will cause this script to run
  task :populate => :environment do
    # Drop the old db and recreate from scratch
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    # Invoke rake db:migrate
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:test:prepare'].invoke
    # Need gem to make this work when adding students later: faker
    # Docs at: http://faker.rubyforge.org/rdoc/
    require 'faker'
    require 'factory_bot_rails'

    # Step 1: Create some instructors
    mark = Instructor.new
    mark.first_name = "Mark"
    mark.last_name = "Heimann"
    mark.bio = "Mark is currently among the top 150 players in the United States (USCF rating: 2468) and has won 4 national scholastic chess championships.  Mark is currently working on his Ph.D. in computer science at the University of Michigan and plays for the school's chess team."
    mark.phone = "4122688211"
    mark.email = "mark@razingrooks.org"
    mark.active = true
    mark.save!
    
    alex = Instructor.new
    alex.first_name = "Alex"
    alex.last_name = "Heimann"
    alex.bio = "Alex has earned his Life Master title with a current USCF rating of 2375.  Alex has won 4 national scholastic chess championships as well as 2 national bughouse championships.  Alex graduated from Wheaton College in Illinios where he majored in business with a minor in anthropology and played ultimate frisbee."
    alex.phone = "4122688211"
    alex.email = "alex@razingrooks.org"
    alex.active = true
    alex.save!

    rachel = Instructor.new
    rachel.first_name = "Rachel"
    rachel.last_name = "Heimann"
    rachel.bio = "Rachel is an amazing chess player and regularly beats her brothers, Alex and Mark.  Unfortunately she is currently unable to teach for any of the chess camps at this time."
    rachel.phone = nil
    rachel.email = "rachel@example.com"
    rachel.active = false
    rachel.save!

    becca = Instructor.new
    becca.first_name = "Becca"
    becca.last_name = "Kern"
    becca.email = "becca@razingrooks.org"
    becca.phone = "412-268-3259"
    becca.bio = "Great TA for 67-272; hopefully can teach chess too."
    becca.active = true
    becca.save!
        
    jordan = Instructor.new
    jordan.first_name = "Jordan"
    jordan.last_name = "Stapinski"
    jordan.email = "jordan@razingrooks.org"
    jordan.phone = "412-268-3259"
    jordan.bio = "Great TA for 67-272; hopefully can teach chess too."
    jordan.active = true
    jordan.save!

    rick = Instructor.new
    rick.first_name = "Rick"
    rick.last_name = "Huang"
    rick.email = "rick@razingrooks.org"
    rick.phone = "412-268-3259"
    rick.bio = "Great TA for 67-272; hopefully can teach chess too."
    rick.active = true
    rick.save!

    connor = Instructor.new
    connor.first_name = "Connor"
    connor.last_name = "Hanley"
    connor.email = "connor@razingrooks.org"
    connor.phone = "412-268-3259"    
    connor.bio = "Great TA for 67-272; hopefully can teach chess too."
    connor.active = true
    connor.save!

    sarah = Instructor.new
    sarah.first_name = "Sarah"
    sarah.last_name = "Reyes-Franco"
    sarah.email = "sarah@razingrooks.org"
    sarah.phone = "412-268-3259"
    sarah.bio = "Great TA for 67-272; hopefully can teach chess too."
    sarah.active = true
    sarah.save!

    lead_instructors = [mark,alex,becca,sarah]
    assistants = [jordan,rick,connor]

    # Step 2: Create some curriculum
    beginners = Curriculum.new
    beginners.name = "Principles of Chess"
    beginners.min_rating = 0
    beginners.max_rating = 500
    beginners.description = "This camp is designed for beginning students who know need to learn opening principles, pattern recognition and basic tactics and mates.  Students will be given a set of mate-in-one flashcards and are expected to work on these at home during the week."
    beginners.active = true
    beginners.save!

    tactics = Curriculum.new
    tactics.name = "Mastering Chess Tactics"
    tactics.min_rating = 400
    tactics.max_rating = 850
    tactics.description = "This camp is designed for any student who has mastered basic mating patterns and understands opening principles and is looking to improve his/her ability use chess tactics in game situations. Students will be given a set of tactical flashcards and are expected to work on these at home during the week."
    tactics.active = true
    tactics.save!

    tal = Curriculum.new
    tal.name = "The Tactics of Mikhail Tal"
    tal.min_rating = 800
    tal.max_rating = 3000
    tal.description = "Tal is one of the most admired world champions and often called the Wizard from Riga for his almost magical play.  His chess genius was most clearly seen in his amazing sacrifices and dazzling tactics and in this camp we will dissect these thoroughly so students can learn from them."
    tal.active = false
    tal.save!

    nimzo = Curriculum.new
    nimzo.name = "Nimzo-Indian Defense"
    nimzo.min_rating = 1000
    nimzo.max_rating = 3000
    nimzo.description = "This camp is for intermediate and advanced players who are looking for a good defense to play against 1. d4.  Many world champions, including Mikhail Tal and Garry Kasparov, have played this defense with great success.  Students will have 4 to 6 games to review each day at home as homework."
    nimzo.active = true
    nimzo.save!

    endgames = Curriculum.new
    endgames.name = "Endgame Principles"
    endgames.min_rating = 750
    endgames.max_rating = 1500
    endgames.description = "In this camp we focus on mastering endgame principles and tactics.  We will focus primarily on King-pawn and King-rook endings, but other endings will be covered as well. Complete games will not be played during this camp, but students will compete through a series of endgame exercises for points and awards."
    endgames.active = true
    endgames.save!

    nonbeginner_curriculums = [tactics, nimzo, endgames]

    # Step 3: Create some locations
    north = FactoryBot.create(:location, name: "North Side", street_1: "801 Union Place", street_2: nil, city: "Pittsburgh", zip: "15212")
    cmu = FactoryBot.create(:location) 
    sqhill = FactoryBot.create(:location, name: "Squirrel Hill", street_1: "5738 Forbes Avenue", street_2: nil, city: "Pittsburgh", zip: "15217")
    acac = FactoryBot.create(:location, name: "ACAC", street_1: "250 East Ohio St", street_2: nil, city: "Pittsburgh", zip: "15212")
    all_locations = [cmu, north, sqhill, acac]

    # Step 4: Create some camps and assign to instructors
    dates = [[Date.new(2018,6,11),Date.new(2018,6,15)],
             [Date.new(2018,6,18),Date.new(2018,6,22)],
             [Date.new(2018,6,25),Date.new(2018,6,29)],
             [Date.new(2018,7,9),Date.new(2018,7,13)],
             [Date.new(2018,7,16),Date.new(2018,7,20)],
             [Date.new(2018,7,23),Date.new(2018,7,27)],
             [Date.new(2018,7,30),Date.new(2018,8,3)],
             [Date.new(2018,8,6),Date.new(2018,8,10)],
             [Date.new(2018,8,13),Date.new(2018,8,17)],
             [Date.new(2018,8,20),Date.new(2018,8,24)]]

    dates.each do |starting, ending|
      ["am","pm"].each do |slot|
        possible_locations = all_locations.clone
        possible_curriculums = nonbeginner_curriculums.clone
        first_location = possible_locations.sample
        # every session we teach a beginner's camp
        camp1 = FactoryBot.create(:camp, curriculum: beginners, start_date: starting, end_date: ending, location: first_location, time_slot: slot)
        # assign an instructor and possibly an assistant
        possible_leads = lead_instructors.clone
        lead_instructor = possible_leads.sample
        possible_assistants = assistants.clone
        assistant = possible_assistants.sample
        lead1 = FactoryBot.create(:camp_instructor, instructor: lead_instructor, camp: camp1)
        assistant = FactoryBot.create(:camp_instructor, instructor: assistant, camp: camp1)

        possible_locations.delete(first_location)
        possible_leads.delete(lead_instructor)
        next_lead = possible_leads.sample
        second_location = possible_locations.sample
        curric1 = possible_curriculums.sample
        # ... and one non-beginner's camp
        camp2 = FactoryBot.create(:camp, curriculum: curric1, start_date: starting, end_date: ending, location: second_location, time_slot: slot)
        lead2 = FactoryBot.create(:camp_instructor, instructor: next_lead, camp: camp2)

        # about 20 percent of the time add a third camp during this session
        if rand(5).zero? 
          possible_locations.delete(second_location)
          third_location = possible_locations.sample
          possible_curriculums.delete(curric1)
          curric2 = possible_curriculums.sample
          possible_leads.delete(next_lead)
          last_lead = possible_leads.sample
          camp3 = FactoryBot.create(:camp, curriculum: curric2, start_date: starting, end_date: ending, location: third_location, time_slot: slot)
          lead3 = FactoryBot.create(:camp_instructor, instructor: last_lead, camp: camp3)
        end
      end
    end

  end
end