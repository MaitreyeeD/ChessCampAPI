class Family < ApplicationRecord

	attr_accessor :username, :email, :password, :password_confirmation

	belongs_to :user
	has_many :students
	has_many :registrations, through: :students

	validates_presence_of :family_name, :parent_first_name
	validates :user_id, presence: true, numericality: { greater_than: 0, only_integer: true }

	scope :alphabetical, -> { order('family_name, parent_first_name') }
	scope :active, -> { where(active: true) }
  	scope :inactive, -> { where(active: false) }

  	before_destroy do 
	    cannot_destroy_object
	end

	before_update :deactivate_family_user_students_and_destroy_registrations
	
	attr_accessor :destroyable
	private
		
		def cannot_destroy_object
	      self.destroyable = false
	      msg = "This #{self.class.to_s.downcase} cannot be deleted at this time. If this is a mistake, please alert the administrator."
	      errors.add(:base, msg)
	      throw(:abort) if errors.present?
	      
	    end

	    def destroy_upcoming_registrations
	    	uc = Camp.upcoming.map{|c| c.id}
	    	self.registrations.each do |r|
	    		if uc.include?(r.camp_id)
	    			r.destroy
	    		end
	    	end

	    end

	    def deactivate_user
	    	self.user.update_attribute(:active, false)
	    end

	    def deactivate_students
	    	self.students.each{ |s| s.update_attribute(:active, false)}
	    end


		def deactivate_family_user_students_and_destroy_registrations
			return true unless self.destroyable == false
			destroy_upcoming_registrations
			deactivate_user
			deactivate_students
			#self.update_attribute(:active, false)
		end


end
