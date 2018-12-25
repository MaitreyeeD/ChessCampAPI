module Contexts
  module FamilyContexts
    def create_families
      @family1 = FactoryBot.create(:family, user: @user1)
    end

    def delete_families
      @family1.delete
    end

    def create_studenttest_families
    	@stfamily1 = FactoryBot.create(:family, family_name: "Student Test Family 1", user: @user1)
    end

    def delete_studenttest_families
    	@stfamily1.delete
    end

    def create_familytest_families
      @deshpandes = FactoryBot.create(:family, family_name: "Deshpande", parent_first_name: "Harsh", user: @deshpandeuser)
      @alavalas = FactoryBot.create(:family, family_name: "Alavala", parent_first_name: "Krishna", user: @alavalauser)
    end

    def delete_familytest_families
      @deshpandes.delete
      @alavalas.delete
    end

    def create_regtest_families
      @badkas = FactoryBot.create(:family, family_name: "Badkas", parent_first_name: "Meenal", user: @badkasuser)
    end

    def delete_regtest_families
      @badkas.delete
    end

    


end
end