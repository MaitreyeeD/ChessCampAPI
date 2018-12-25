require 'test_helper'

class FamilyTest < ActiveSupport::TestCase
  should belong_to(:user)
  should have_many(:students)

  should validate_presence_of(:family_name)
  should validate_presence_of(:parent_first_name)
  should validate_presence_of(:user_id)

  should allow_value(4).for(:user_id)
  should_not allow_value(-4).for(:user_id)
  should_not allow_value("bad").for(:user_id)

  context "Within context" do
    setup do 
      create_familytest_users
      create_familytest_families
      create_familytest_students
    end
    
    teardown do
      delete_familytest_students
      delete_familytest_families
      delete_familytest_users
    end

    should "show that families are in alphabetical order" do
       assert_equal ["Alavala", "Deshpande"], Family.alphabetical.all.map(&:family_name)
    end

    should "show that there are 2 active families" do 
      assert_equal 2, Family.active.size
    end

    should "show that there are 0 inactive families" do 
      assert_equal 0, Family.inactive.size
    end

    should "show that a family can't be destroyed and upcoming registrations are deleted and user and students are made inactive" do 

      create_more_curriculums
      create_curriculums
      #create_familytest_users
      create_active_locations
      create_custom_camps
      create_past_camps
      create_upcoming_camps
      create_familytest_families
      create_familytest_students
      create_familytest_registrations

      assert_equal true, @deshpandes.active
      assert_equal 2, @camp21.registrations.size
      assert_equal 2, @gargi.registrations.size

      deny @deshpandes.destroy
      @deshpandes.reload
      @camp21.reload
      @gargi.reload

      assert_equal 2, @gargi.registrations.size
      assert_equal 2, @camp21.registrations.size

      @deshpandes.update_attribute(:active, false)
      @deshpandes.reload
      @camp21.reload
      @gargi.reload
      assert_equal 1, @gargi.registrations.size
      assert_equal 1, @camp21.registrations.size
      assert_equal false, @gargi.active

      @deshpandeuser.reload
      assert_equal false, @deshpandeuser.active

      assert_equal false, @deshpandes.active




      assert_equal true, @alavalas.active
      assert_equal 1, @camp21.registrations.size
      assert_equal 1, @sriram.registrations.size

      deny @alavalas.destroy
      @alavalas.reload
      @camp21.reload
      @sriram.reload

      assert_equal 1, @sriram.registrations.size
      assert_equal 1, @camp21.registrations.size

      @alavalas.update_attribute(:active, false)
      @alavalas.reload
      @camp21.reload
      @sriram.reload
      assert_equal 0, @sriram.registrations.size
      assert_equal 0, @camp21.registrations.size
      assert_equal false, @sriram.active

      @alavalauser.reload
      assert_equal false, @alavalauser.active

      assert_equal false, @alavalas.active


      delete_more_curriculums
      delete_curriculums
      delete_familytest_users
      delete_active_locations
      delete_past_camps
      delete_custom_camps
      delete_upcoming_camps
      delete_familytest_families
      delete_familytest_students
      delete_familytest_registrations


    end
  end


  
end
