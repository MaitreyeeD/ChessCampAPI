require 'test_helper'

class InstructorTest < ActiveSupport::TestCase
  # test relationships
  should have_many(:camp_instructors)
  should have_many(:camps).through(:camp_instructors)

  # test validations
  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)
  

  # set up context
  context "Within context" do
    setup do 
      create_instructortest_users
      create_instructors
    end
    
    teardown do
      delete_instructortest_users
      delete_instructors
    end

    should "show that there are three instructors in alphabetical order" do
      assert_equal ["Alex", "Mark", "Rachel"], Instructor.alphabetical.all.map(&:first_name)
    end

    should "show that there are two active instructors" do
      assert_equal 2, Instructor.active.size
      assert_equal ["Alex", "Mark"], Instructor.active.all.map(&:first_name).sort
    end
    
    should "show that there is one inactive instructor" do
      assert_equal 1, Instructor.inactive.size
      assert_equal ["Rachel"], Instructor.inactive.all.map(&:first_name).sort
    end

    should "show that there are two instructors needing bios" do
      assert_equal 2, Instructor.needs_bio.size
      assert_equal ["Alex", "Rachel"], Instructor.needs_bio.all.map(&:first_name).sort
    end

    should "show that name method works" do
      assert_equal "Heimann, Mark", @mark.name
      assert_equal "Heimann, Alex", @alex.name
    end
    
    should "show that proper_name method works" do
      assert_equal "Mark Heimann", @mark.proper_name
      assert_equal "Alex Heimann", @alex.proper_name
    end

    

    should "have a class method to give array of instructors for a given camp" do
      # create additional contexts that are needed
      create_curriculums
      create_active_locations
      create_camps
      create_camp_instructors
      assert_equal ["Alex", "Mark"], Instructor.for_camp(@camp1).map(&:first_name).sort
      assert_equal ["Mark"], Instructor.for_camp(@camp4).map(&:first_name).sort
      # remove those additional contexts
      delete_camp_instructors
      delete_curriculums
      delete_active_locations
      delete_camps
    end

    should "allow instructor to be destroyed if they have not taught a past camp" do 
      
      create_curriculums
      create_more_curriculums
      create_locations
      create_camps
      create_past_camps
      create_upcoming_camps
      create_camp_instructors
      create_more_instructors
      create_more_camp_instructors


      #mike taught a lot of past camps
      #patrick only is teaching 1 upcoming camp
      assert_equal 0, @patrick.camps.past.size
      @patrick.destroy
      assert @patrick.destroyed?
      @camp20.reload
      assert_equal false, @camp20.camp_instructors.map{|ci| ci.instructor_id}.include?(@patrick.id)

      

      assert_equal 3, @mike.camps.past.size
      @mike.destroy
      deny @mike.destroyed?
      deny @usermike.destroyed?
      assert_equal false, @mike.active
      assert_equal false, @usermike.active
      assert_equal 0, @mike.camps.upcoming.size

      assert_equal 1, @ari.camps.past.size
      @ari.destroy
      deny @ari.destroyed?
      deny @userari.destroyed?
      assert_equal false, @ari.active
      assert_equal false, @userari.active
      assert_equal 0, @ari.camps.upcoming.size
      @camp23.reload
      assert_equal false, @camp23.camp_instructors.map{|ci| ci.instructor_id}.include?(@ari.id)


      assert_equal 1, @brad.camps.past.size
      @brad.update_attribute(:active, false)
      assert_equal false, @brad.active
      assert_equal false, @userbrad.active


      delete_curriculums
      delete_more_curriculums
      delete_locations
      delete_camps
      delete_past_camps
      delete_upcoming_camps
      delete_camp_instructors
      delete_more_instructors
      delete_more_camp_instructors

    end

  end
end
