require 'test_helper'

class RegistrationTest < ActiveSupport::TestCase
  should belong_to(:camp)
  should belong_to(:student)

  should validate_presence_of(:camp_id)
  should validate_presence_of(:student_id)

  should validate_presence_of(:camp_id)
  should validate_presence_of(:student_id)
  should validate_numericality_of(:camp_id).only_integer.is_greater_than(0)
  should validate_numericality_of(:student_id).only_integer.is_greater_than(0)

   context "Within context" do
    setup do
    	create_more_curriculums
    	create_curriculums
    	create_locations
    	create_camps
    	create_custom_camps
    	create_upcoming_camps
    	create_past_camps
    	create_regtest_users
    	create_regtest_families
    	create_regtest_students
    	create_regtest_registrations

    end

    teardown do
    	delete_regtest_registrations
    	delete_regtest_students
    	delete_regtest_families
    	delete_regtest_users
    	delete_past_camps
    	delete_upcoming_camps
    	delete_custom_camps
    	delete_camps
    	delete_locations
    	delete_curriculums
    	delete_more_curriculums
    end

    should "show scope alphabetical works" do
    	assert_equal ["Eshaan", "Vivaan"], Registration.alphabetical.all.map{|r| r.student.first_name }
    end

    should "show scope for_camp works" do
    	assert_equal [@eshaanreg], Registration.for_camp(@camp1).to_a
    end

    should "show that registration can't have an inactive or nonexistent camp" do
    	badcampreg = FactoryBot.build(:registration, student: @eshaan, camp: @camp3)
    	deny badcampreg.valid?
    	ghostcampreg = FactoryBot.build(:registration, student: @eshaan, camp: @camp100)
    end

    should "show that registration can't have an inactive or nonexistent student" do
    	inactivestudent = FactoryBot.build(:student, active: false, family: @badkas) 
    	badstudentreg = FactoryBot.build(:registration, student: inactivestudent, camp: @camp1)
    	deny badstudentreg.valid?
    	ghoststudentreg = FactoryBot.build(:registration, student: @imaghost, camp: @camp1)
    end

    should "show that student has an appopriate rating for a camp" do 
    	 mismatchratingreg = FactoryBot.build(:registration, student: @lowratingstudent, camp: @camp1)
    	 deny mismatchratingreg.valid?
    	 assert @eshaanreg.valid?
    end

    should "show that students can't be registered for two camps at the same time" do 
    	eshaancopy = FactoryBot.build(:registration, student: @eshaan, camp: @camp5)
    	deny eshaancopy.valid?
    	eshaangoodcopy = FactoryBot.build(:registration, student: @eshaan, camp: @camp2)
    	assert eshaangoodcopy.valid?
    end


end



end
