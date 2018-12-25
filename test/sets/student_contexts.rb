module Contexts
  module StudentContexts
    
    def create_studenttest_students
      @maitreyee   = FactoryBot.create(:student, family: @stfamily1)
      @sahi   = FactoryBot.create(:student, first_name: "Sahi", last_name: "Alavala", family: @stfamily1, rating: 200, date_of_birth: Date.new(1998, 9, 24))
      @cam = FactoryBot.create(:student, first_name: "Cam", last_name: "Drayton", family: @stfamily1, rating: 900, date_of_birth: Date.new(1997, 12, 10), active: false)
      @emptyrating = FactoryBot.create(:student, rating: nil, first_name: "Empty", last_name: "Rating", active: false, family: @stfamily1)
    

    end

    def delete_studenttest_students
      @emptyrating.delete
      @maitreyee.delete
      @sahi.delete
      @cam.delete
    end

    def create_familytest_students
      @gargi = FactoryBot.create(:student, first_name: "Gargi", last_name: "Deshpande", family: @deshpandes, rating: 1200)
      @sriram = FactoryBot.create(:student, first_name: "Sriram", last_name: "Alavala", family: @alavalas, rating: 1300)
    end

    def delete_familytest_students
      @gargi.delete
      @sriram.delete
    end

    def create_regtest_students
      @vivaan = FactoryBot.create(:student, first_name: "Vivaan", last_name:"Badkas", family: @badkas, rating: 200)
      @eshaan = FactoryBot.create(:student, first_name: "Eshaan", last_name:"Badkas", family: @badkas, rating: 500)
      @lowratingstudent = FactoryBot.create(:student, first_name: "Bad", last_name:"Rating", family: @badkas, rating: 100)
    end

    def delete_regtest_students
      @vivaan.delete
      @eshaan.delete
      @lowratingstudent.delete
    end

    def create_students
      create_studenttest_students
      create_familytest_students
      create_regtest_students
    end

    def delete_students
      delete_studenttest_students
      delete_familytest_students
      delete_regtest_students
    end

  end
end
