require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should have_secure_password

  # test validations
  should validate_presence_of(:username)
  #should validate_presence_of(:role)

  should validate_uniqueness_of(:username).case_insensitive
  should validate_uniqueness_of(:email).case_insensitive

  should allow_value("fred@fred.com").for(:email)
  should allow_value("fred@andrew.cmu.edu").for(:email)
  should allow_value("my_fred@fred.org").for(:email)
  should allow_value("fred123@fred.gov").for(:email)
  should allow_value("my.fred@fred.net").for(:email)
  
  should_not allow_value("fred").for(:email)
  should_not allow_value("fred@fred,com").for(:email)
  should_not allow_value("fred@fred.uk").for(:email)
  should_not allow_value("my fred@fred.com").for(:email)
  should_not allow_value("fred@fred.con").for(:email)
  
  # Validating phone...
  should allow_value("4122683259").for(:phone)
  should allow_value("412-268-3259").for(:phone)
  should allow_value("412.268.3259").for(:phone)
  should allow_value("(412) 268-3259").for(:phone)
  
  should_not allow_value("2683259").for(:phone)
  should_not allow_value("4122683259x224").for(:phone)
  should_not allow_value("800-EAT-FOOD").for(:phone)
  should_not allow_value("412/268/3259").for(:phone)
  should_not allow_value("412-2683-259").for(:phone)

  should allow_value("admin").for(:role)
  should allow_value("parent").for(:role)
  should allow_value("instructor").for(:role)
  should_not allow_value("bad").for(:role)
  should_not allow_value("hacker").for(:role)
  should_not allow_value(10).for(:role)
  should_not allow_value("leader").for(:role)
  should_not allow_value(nil).for(:role)



  context "Within context" do
    setup do
      create_users
      create_familytest_users
    end

    teardown do
      delete_users
      delete_familytest_users
    end


    should "require users to have unique, case-insensitive usernames" do
      assert_equal "jordan", @jordan.username
      @jordan.username = "BECCA"
      deny @jordan.valid?, "#{@jordan.username}"
      assert @deshpandeuser.valid?
      assert @alavalauser.valid?
    end

    should "require users to have unique, case-insensitive emails" do
      assert_equal "jordan@j.com", @jordan.email
      @jordan.email = "BECCA@B.COM"
      deny @jordan.valid?, "#{@jordan.username}"
      assert @deshpandeuser.valid?
      assert @alavalauser.valid?
    end

   
    should "shows that phone is stripped of non-digits" do
      assert_equal "4085171470", @jordan.phone
      assert_equal "1231231233", @becca.phone
    end


    should "require a password for new users" do
      bad_user = FactoryBot.build(:user, username: "tank", password: nil, email: "bad@bad.com")
      deny bad_user.valid?
    end

    should "require passwords to be confirmed and matching" do
      bad_user_1 = FactoryBot.build(:user, username: "tank", password: "secret", password_confirmation: nil, email: "bbbbb@b.com")
      deny bad_user_1.valid?
      bad_user_2 = FactoryBot.build(:user, username: "tank", password: "secret", password_confirmation: "sauce", email: "bbbbbb@b.com")
      deny bad_user_2.valid?
    end
    
    should "require passwords to be at least four characters" do
      bad_user = FactoryBot.build(:user, username: "tank", password: "no", email: "aaaa@a.com")
      deny bad_user.valid?
    end

  end
end
