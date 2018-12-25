require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  #test relationships 
  should have_many(:registrations)
  should have_many(:camps).through(:registrations)
  should belong_to(:family)


  #test validations
  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)

  should allow_value(1000).for(:rating)
  should allow_value(100).for(:rating)
  should allow_value(2872).for(:rating)
  should allow_value(0).for(:rating)

  should_not allow_value(3001).for(:rating)
  should_not allow_value(50).for(:rating)
  should_not allow_value(-1).for(:rating)
  should_not allow_value(500.50).for(:rating)
  should_not allow_value("bad").for(:rating)

  should allow_value(6.years.ago.to_date).for(:date_of_birth)
  should allow_value(1.day.ago.to_date).for(:date_of_birth)
  should_not allow_value(Date.today).for(:date_of_birth)
  should_not allow_value(1.day.from_now.to_date).for(:date_of_birth)
  should_not allow_value("bad").for(:date_of_birth)
  should_not allow_value(2).for(:date_of_birth)
  should_not allow_value(3.14159).for(:date_of_birth)


  context "Within context" do
    setup do 
      create_users
      create_studenttest_families
      create_studenttest_students
    end
    
    teardown do
      delete_studenttest_students
      delete_studenttest_families
      delete_users
    end

    should "show that there are three students in alphabetical order" do
      assert_equal ["Sahi", "Maitreyee", "Cam", "Empty"], Student.alphabetical.all.map(&:first_name)
    end

    should "show that there are two active students" do
      assert_equal 2, Student.active.size
      assert_equal ["Maitreyee", "Sahi"], Student.active.all.map(&:first_name).sort
    end

    should "show that there is one inactive student" do
      assert_equal 2, Student.inactive.size
      assert_equal ["Cam", "Empty"], Student.inactive.all.map(&:first_name).sort
    end

    should "show that below rating works" do
      assert_equal 2, Student.below_rating(300).size
      assert_equal ["Empty", "Sahi"], Student.below_rating(300).all.map(&:first_name).sort
    end

    should "show that above rating works" do
      assert_equal 2, Student.at_or_above_rating(300).size
      assert_equal ["Cam", "Maitreyee"], Student.at_or_above_rating(300).all.map(&:first_name).sort
    end

    should "show that name method works" do
      assert_equal "Deshpande, Maitreyee", @maitreyee.name
      assert_equal "Drayton, Cam", @cam.name
    end

    should "show that proper_name method works" do
      assert_equal "Maitreyee Deshpande", @maitreyee.proper_name
      assert_equal "Cam Drayton", @cam.proper_name
    end

    should "show that the age method works" do
      assert_equal 19, @maitreyee.age
      assert_equal 20, @cam.age
      assert_equal 19, @sahi.age
    end

    should "show that rating is not nil method works" do
      assert_equal 0, @emptyrating.rating
    end

    should "show that family is active" do
      inactuser = FactoryBot.build(:user, username: "inact", password: "inact123", password_confirmation: "inact123", email: "inact@gmail.com")
      inactfam = FactoryBot.build(:family, family_name: "Inactive", parent_first_name: "Inac", user: @inactuser)
      stud = FactoryBot.build(:student, first_name:"in", last_name: "act", family: @inactfam)
      deny stud.valid?
    end

    should "show that a student that has been in a past camp cannot be destroyed but made inactive" do
      create_curriculums
      create_more_curriculums
      #create_users
      create_active_locations
      create_past_camps
      create_upcoming_camps
      create_custom_camps
      create_studenttest_families
      create_studenttest_students
      create_studenttest_registrations

      assert_equal 2, @camp20.registrations.size
      
      assert @sahi.active
      assert_equal 2, @sahi.registrations.size
      deny @sahi.registrations.empty?
      deny @sahi.destroy
      @sahi.reload

      assert_equal 1, @sahi.registrations.size
      deny @sahi.active


      assert_equal 1, @maitreyee.registrations.size
      assert_equal 1, @camp20.registrations.size
      @maitreyee.destroy
      assert_equal 0, @camp20.registrations.size



      
      delete_studenttest_registrations
      delete_studenttest_students
      delete_studenttest_families
      delete_custom_camps
      delete_past_camps
      delete_upcoming_camps
      delete_active_locations
      delete_users
      delete_more_curriculums
      delete_curriculums
    end

   

    should "show that a student that has never registered for a past camp can be destroyed" do
      newstudent = FactoryBot.create(:student, first_name: "New", last_name: "Student", family: @stfamily1)
      newstudent.destroy
      assert newstudent.destroyed?
    end


  end





end
