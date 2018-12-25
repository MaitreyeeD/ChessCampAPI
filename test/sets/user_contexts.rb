module Contexts
  module UserContexts
    def create_users
      @user1 = FactoryBot.create(:user, username: "user1", password: "secret", password_confirmation: "secret", email: "user1@user.com")
      @jordan = FactoryBot.create(:user, username: "jordan", role: "admin", password: "secret", password_confirmation: "secret", email: "jordan@j.com", phone: "(408) 517-1470")
      @becca  = FactoryBot.create(:user, username: "becca", role: "admin", password: "secret", password_confirmation: "secret", email: "becca@b.com", phone: "123-123-1233")
      @connor = FactoryBot.create(:user, username: "connor", role: "admin", password: "secret", password_confirmation: "secret", email: "connor@c.com")
  
      
    end

    def delete_users
      @user1.delete
      @jordan.delete
      @becca.delete
      @connor.delete
    end

    def create_familytest_users
      @deshpandeuser = FactoryBot.create(:user, username: "deshpande", password: "feb61996", password_confirmation: "feb61996", email:"harshdeshpande@yahoo.com")
      @alavalauser = FactoryBot.create(:user, username: "alavala", password: "sahifirstborn", password_confirmation: "sahifirstborn", email: "krishnaalavala@gmail.com")

    end

    def delete_familytest_users
      @deshpandeuser.delete
      @alavalauser.delete
    end

    def create_regtest_users
      @badkasuser = FactoryBot.create(:user, username: "badkas", password: "viv123", password_confirmation: "viv123", email: "meenalbadkas@gmail.com")
    end

    def delete_regtest_users
      @badkasuser.delete
    end

    def create_instructortest_users
      @usermark    = FactoryBot.create(:user, username: "mark", password: "mark123", password_confirmation: "mark123", email: "mark@gmail.com")
      @useralex    = FactoryBot.create(:user, username: "alex", password: "alex123", password_confirmation: "alex123", email: "alex@gmail.com")
      @userrachel  = FactoryBot.create(:user, username: "rachel", password: "rachel123", password_confirmation: "rachel123", email: "rachel@gmail.com")
      @usermike    = FactoryBot.create(:user, username: "mike", password: "mike123", password_confirmation: "mike123", email: "mike@gmail.com")
      @userpatrick = FactoryBot.create(:user, username: "patrick", password: "patrick123", password_confirmation: "patrick123", email: "patrick@gmail.com")
      @useraustin  = FactoryBot.create(:user, username: "austin", password: "austin123", password_confirmation: "austin123", email: "austin@gmail.com")
      @usernathan  = FactoryBot.create(:user, username: "nathan", password: "nathan123", password_confirmation: "nathan123", email: "nathan@gmail.com")
      @userari     = FactoryBot.create(:user, username: "ari", password: "ari123", password_confirmation: "ari123", email: "ari@gmail.com")
      @userseth    = FactoryBot.create(:user, username: "seth", password: "seth123", password_confirmation: "seth123", email: "seth@gmail.com")
      @userstafford= FactoryBot.create(:user, username: "stafford", password: "stafford123", password_confirmation: "stafford123", email: "stafford@gmail.com")
      @userbrad    = FactoryBot.create(:user, username: "brad", password: "brad123", password_confirmation: "brad123", email: "brad@gmail.com")
      @userripta   = FactoryBot.create(:user, username: "ripta", password: "ripta123", password_confirmation: "ripta123", email: "ripta@gmail.com")
      @userjon     = FactoryBot.create(:user, username: "jon", password: "jon123", password_confirmation: "jon123", email: "jon@gmail.com")
      @userashton  = FactoryBot.create(:user, username: "ashton", password: "ashton123", password_confirmation: "ashton123", email: "ashton@gmail.com")
      @usernoah    = FactoryBot.create(:user, username: "noah", password: "noah123", password_confirmation: "noah123", email: "noah@gmail.com")

    end

    def delete_instructortest_users
      @usermark.delete
      @useralex.delete
      @userrachel.delete
      @usermike.delete
      @userpatrick.delete
      @useraustin.delete
      @usernathan.delete
      @userari.delete
      @userseth.delete
      @userstafford.delete
      @userbrad.delete
      @userripta.delete
      @userjon.delete
      @userashton.delete
      @usernoah.delete

    end

    



end
end