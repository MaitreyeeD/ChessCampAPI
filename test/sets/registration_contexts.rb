module Contexts
  module RegistrationContexts
    def create_studenttest_registrations
      #@reg1   = FactoryBot.create(:registration)
      @reg2   = FactoryBot.create(:registration, student: @sahi, camp: @camp10)
      @sahiupcoming = FactoryBot.create(:registration, student: @sahi, camp: @camp20, payment: "1800")
      @maitreyeeupcoming = FactoryBot.create(:registration, student: @maitreyee, camp: @camp20, payment: "1800")
    end

    def delete_studenttest_registrations
     # @reg1.delete
      @reg2.delete
      @sahiupcoming.delete
      @maitreyeeupcoming.delete
    end

    def create_familytest_registrations
      @gargipast = FactoryBot.create(:registration, student: @gargi, camp: @camp12)
      @gargiupcoming = FactoryBot.create(:registration, student: @gargi, camp: @camp21)
      @sriramupcoming = FactoryBot.create(:registration, student: @sriram, camp: @camp21)
    end

    def delete_familytest_registrations
      @gargipast.delete
      @gargiupcoming.delete
      @sriramupcoming.delete
    end

    def create_regtest_registrations
      @eshaanreg = FactoryBot.create(:registration, student: @eshaan, camp: @camp1)
      @vivaanreg = FactoryBot.create(:registration, student: @vivaan, camp: @camp2)
      #@eshaancopy = FactoryBot.create(:registration, student: @eshaan, camp: @camp5)
      #@lowratingreg = FactoryBot.create(:registration, student: @lowratingstudent, camp: @camp1)
    end

    def delete_regtest_registrations
      @eshaanreg.delete
      @vivaanreg.delete
      #@eshaancopy.delete
     # @lowratingreg.delete
    end

    def create_registrations
      create_studenttest_registrations
      create_familytest_registrations
      create_regtest_registrations
    end

    def delete_registrations
      delete_studenttest_registrations
      delete_familytest_registrations
      delete_regtest_registrations
    end
  end
end
