require 'test_helper'

class CampTest < ActiveSupport::TestCase
  # test relationships
  should belong_to(:curriculum)
  should have_many(:camp_instructors)
  should have_many(:instructors).through(:camp_instructors)
  should belong_to(:location)

  # test validations
  should validate_presence_of(:curriculum_id)
  should validate_presence_of(:location_id)
  should validate_presence_of(:start_date)
  should validate_presence_of(:time_slot)

  should allow_value(Date.today).for(:start_date)
  should allow_value(1.day.from_now.to_date).for(:start_date)
  should_not allow_value(1.day.ago.to_date).for(:start_date)
  should_not allow_value("bad").for(:start_date)
  should_not allow_value(2).for(:start_date)
  should_not allow_value(3.14159).for(:start_date)
  
  should_not allow_value("bad").for(:end_date)
  should_not allow_value(2).for(:end_date)
  should_not allow_value(3.14159).for(:end_date) 

  should validate_numericality_of(:cost)
  should allow_value(0).for(:cost)
  should allow_value(120).for(:cost)
  should allow_value(120.00).for(:cost)
  should_not allow_value("bad").for(:cost)
  should_not allow_value(-20).for(:cost)

  should allow_value("am").for(:time_slot)
  should allow_value("pm").for(:time_slot)
  should_not allow_value("bad").for(:time_slot)
  should_not allow_value("1:00").for(:time_slot)  
  should_not allow_value(900).for(:time_slot)

  
  should validate_numericality_of(:max_students)
  should allow_value(nil).for(:max_students)
  should allow_value(1).for(:max_students)
  should allow_value(12).for(:max_students)
  should_not allow_value("bad").for(:max_students)
  should_not allow_value(0).for(:max_students)
  should_not allow_value(-1).for(:max_students)
  should_not allow_value(3.14159).for(:max_students)

  # set up context
  context "Within context" do
    setup do 
      create_curriculums
      create_active_locations
      create_camps
    end
    
    teardown do
      delete_curriculums
      delete_active_locations
      delete_camps
    end

    should "verify there is a camp name method" do
      assert_equal "Endgame Principles", @camp4.name
      assert_equal "Mastering Chess Tactics", @camp1.name
    end

    should "verify that the camp's curriculum is active in the system" do
      # test the inactive curriculum
      bad_camp = FactoryBot.build(:camp, curriculum: @smithmorra, location: @cmu, start_date: Date.new(2014,8,1), end_date: Date.new(2014,8,5))
      deny bad_camp.valid?
      # test the nonexistent curriculum
      gambit = FactoryBot.build(:curriculum, name: "King's Gambit")
      gambit_camp = FactoryBot.build(:camp, curriculum: gambit, location: @cmu, start_date: Date.new(2014,8,1), end_date: Date.new(2014,8,5))
      deny gambit_camp.valid?
    end 

    should "verify that the camp's location is active in the system" do
      # test the inactive location first
      create_inactive_locations
      bad_camp = FactoryBot.build(:camp, curriculum: @tactics, location: @sqhill, start_date: Date.new(2014,8,1), end_date: Date.new(2014,8,5))
      deny bad_camp.valid?
      delete_inactive_locations
      # test the nonexistent location
      bhill = FactoryBot.build(:location, name: "Blueberry Hill")
      bhill_camp = FactoryBot.build(:camp, curriculum: @tactics, location: bhill, start_date: Date.new(2014,8,1), end_date: Date.new(2014,8,5))
      deny bhill_camp.valid?
    end 

    should "shows that there are four camps in in alphabetical order" do
      assert_equal ["Endgame Principles", "Mastering Chess Tactics", "Mastering Chess Tactics","Mastering Chess Tactics"], Camp.alphabetical.all.map{|c| c.curriculum.name}
    end

    should "shows that there are three active camps" do
      assert_equal 3, Camp.active.size
      assert_equal ["Endgame Principles", "Mastering Chess Tactics", "Mastering Chess Tactics"], Camp.active.all.map{|c| c.curriculum.name}.sort
    end
    
    should "shows that there is one inactive camp" do
      assert_equal 1, Camp.inactive.size
      assert_equal ["Mastering Chess Tactics"], Camp.inactive.all.map{|c| c.curriculum.name}.sort
    end

    should "shows that there are four camps in in chronological order" do
      assert_equal ["Mastering Chess Tactics - Jul 16", "Mastering Chess Tactics - Jul 16", "Mastering Chess Tactics - Jul 23", "Endgame Principles - Jul 23"], Camp.chronological.all.map{|c| "#{c.name} - #{c.start_date.strftime("%b %d")}"}
    end

    should "shows that there are two morning camps" do
      assert_equal 2, Camp.morning.size
      assert_equal ["Mastering Chess Tactics", "Mastering Chess Tactics"], Camp.morning.all.map{|c| c.name}.sort
    end

    should "shows that there are two afternoon camps" do
      assert_equal 2, Camp.afternoon.size
      assert_equal ["Endgame Principles", "Mastering Chess Tactics"], Camp.afternoon.all.map{|c| c.name}.sort
    end

    should "have a for_curriculum scope" do
      assert_equal ["Endgame Principles"], Camp.for_curriculum(@endgames.id).all.map(&:name).sort
    end

    should "shows that there are 3 upcoming camps and 1 past camp" do
      @camp1.update_attribute(:start_date, 7.days.ago.to_date) # update_attribute will bypass validation
      @camp1.update_attribute(:end_date, 2.days.ago.to_date)
      assert_equal 3, Camp.upcoming.size
      assert_equal 1, Camp.past.size
    end

    should "shows that a camp with same date and time slot but different location can be created" do
      @ok_camp = FactoryBot.build(:camp, curriculum: @tactics, location: @north, start_date: Date.new(2018,7,23), end_date: Date.new(2018,7,27), time_slot: 'am')
      assert @ok_camp.valid?
    end

    should "shows that a duplicate camp (same date, time and location) cannot be created" do
      @bad_camp = FactoryBot.build(:camp, curriculum: @tactics, location: @cmu, start_date: Date.new(2018,7,23), end_date: Date.new(2018,7,27), time_slot: 'am')
      deny @bad_camp.valid?
    end

    should "shows test extra methods and scopes " do 
      create_more_curriculums
      create_custom_camps
      create_past_camps
      create_upcoming_camps
      create_familytest_users
      create_regtest_users
      create_users
      create_instructortest_users
      create_more_instructors
      create_instructors
      create_camp_instructors
      create_more_camp_instructors
      create_studenttest_families
      create_familytest_families
      create_regtest_families
      create_families
      create_students
      create_studenttest_registrations
      create_familytest_registrations
      create_regtest_registrations
      
      # assert_equal [], Camp.empty.size
      # assert_equal [], Camp.full.size

      assert_equal false, @camp24.is_full?
      assert_equal 2, @camp21.enrollment

      delete_more_curriculums
      delete_custom_camps
      delete_past_camps
      delete_upcoming_camps
      delete_familytest_users
      delete_regtest_users
      delete_users
      delete_instructortest_users
      delete_more_instructors
      delete_instructors
      delete_camp_instructors
      delete_more_camp_instructors
      delete_studenttest_families
      delete_familytest_families
      delete_regtest_families
      delete_families
      delete_students
      delete_familytest_registrations
      delete_regtest_registrations


    end


    should "shows that a past camp can still be edited" do
      # move camp into the past with update_attribute (which skips validations)
      @camp1.update_attribute(:start_date, 7.days.ago.to_date)
      @camp1.update_attribute(:end_date, 2.days.ago.to_date)
      @camp1.reload  # to be safe, reload from database
      @camp1.max_students = 7
      @camp1.save!
      @camp1.reload # reload again from the database
      assert_equal 7, @camp1.max_students
    end

    should "check to make sure the end date is on or after the start date" do
      @bad_camp = FactoryBot.build(:camp, curriculum: @endgames, location: @cmu, start_date: 9.days.from_now.to_date, end_date: 5.days.from_now.to_date)
      deny @bad_camp.valid?
      @okay_camp = FactoryBot.build(:camp, curriculum: @endgames, location: @cmu, start_date: 9.days.from_now.to_date, end_date: 9.days.from_now.to_date)
      assert @okay_camp.valid?
    end

    should "not allow camp's max_students to exceed capacity" do
      # capacity of camp1 is 16 and current max_students is 8
      @camp1.max_students = 20
      deny @camp1.valid?
    end

    # should "remove instructors from inactive camps" do
    #   create_instructors
    #   create_camp_instructors
    #   # we've created no registrations, so all camps are capable of being made inactive
    #   deny @camp1.camp_instructors.to_a.empty?
    #   @camp1.active = false
    #   @camp1.save
    #   @camp1.reload
    #   assert @camp1.camp_instructors.to_a.empty?
    #   delete_camp_instructors
    #   delete_instructors
    # end

    should "only destroy camps if there are no registrations" do 
      create_more_curriculums
      create_custom_camps
      create_past_camps
      create_upcoming_camps


      create_familytest_users
      create_regtest_users
      create_users
      create_instructortest_users
      create_more_instructors
      create_instructors
      create_camp_instructors
      create_more_camp_instructors
      create_studenttest_families
      create_familytest_families
      create_regtest_families
      create_families
      create_students
      create_familytest_registrations
      create_regtest_registrations

      assert_equal 0, @camp24.registrations.size
      assert_equal 1, @camp24.camp_instructors.size
      @camp24.destroy
      assert @camp24.destroyed?
      assert_equal 0, @camp24.instructors.size
      @camp24.camp_instructors.reload
      assert_equal 0, @camp24.camp_instructors.size

      assert_equal 0, @camp11.registrations.size
      assert_equal 1, @camp11.camp_instructors.size
      @camp11.update_attribute(:active, false)
      deny @camp11.destroyed?
      @camp11.camp_instructors.reload
      assert_equal 1, @camp11.camp_instructors.size

      @camp12.destroy
      deny @camp12.destroyed?
      @camp12.update_attribute(:active, false)
      @camp12.reload
      assert_equal true, @camp12.active




      delete_familytest_users
      delete_regtest_users
      delete_users
      delete_instructortest_users
      delete_instructors
      delete_more_instructors
      delete_camp_instructors
      delete_more_camp_instructors
      delete_studenttest_families
      delete_familytest_families
      delete_regtest_families
      delete_families
      delete_students
      delete_familytest_registrations
      delete_regtest_registrations
      delete_more_curriculums
      delete_custom_camps
      delete_past_camps
      delete_upcoming_camps


    end

    should "not remove instructors from edited, active camps" do
      create_instructortest_users
      create_instructors
      create_camp_instructors
      deny @camp1.camp_instructors.to_a.empty?
      total_instructors = @camp1.camp_instructors.count
      @camp1.max_students -= 1
      @camp1.save
      @camp1.reload
      assert_equal(@camp1.camp_instructors.count, total_instructors)
      delete_camp_instructors
      delete_instructors
      delete_instructortest_users
    end

  end
end
