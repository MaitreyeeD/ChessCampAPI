class Student < ApplicationRecord
	#relationships
	belongs_to :family
	has_many :registrations
	has_many :camps, through: :registrations

	#validations
	validates_presence_of :first_name, :last_name
	validate :family_is_active
	validates :family_id, presence: true, numericality: { greater_than: 0, only_integer: true }
	ratings_array = [0] + (100..3000).to_a
	validates :rating, numericality: { only_integer: true }, inclusion: { in: ratings_array }, allow_blank: true
	validates_date :date_of_birth, :before => lambda { Date.today }

	#scopes
	scope :alphabetical, -> { order('last_name, first_name') }
	scope :active, -> { where(active: true) }
	scope :inactive, -> { where(active: false) }
	scope :below_rating, ->(ceiling) { where("rating < ?", ceiling) }
	scope :at_or_above_rating, ->(floor) { where("rating >= ?", floor)}

  	#methods
  	def name
  		last_name + ", " + first_name
  	end

  	def proper_name
  		first_name + " " + last_name
  	end

  	def age
  		now = Time.now.utc.to_date
  		now.year - date_of_birth.year - ((now.month > date_of_birth.month || (now.month == date_of_birth.month && now.day >= date_of_birth.day)) ? 0 : 1)
  	end

  	#callbacks
  	before_save :rating_not_nil

  	before_destroy do 
  		check_if_ever_registered_for_past_camp
  		if errors.present?
  			@destroyable = false
  			throw(:abort)
  		else
  			remove_associated_registrations
  		end
  	end

  	after_rollback :convert_to_inactive

  	before_update do 
  		remove_associated_registrations
  	end


  	private
  		def family_is_active
  			activefams = Family.active.map{|f| f.id}
  			if activefams.include?(self.family_id)
  				return true
  			else
  				return false
  			end
  		end
  		
	  	def rating_not_nil
	  		if rating.nil? 
	  			self.update_attribute(:rating, 0) 
	  		end
	  	end

	  	def check_if_ever_registered_for_past_camp
	  		unless no_past_camps?
	  			errors.add(:base, "Student cannot be destroyed because she was registered for a past camp.")
	  		end
	  	end

	  	def no_past_camps?
	  		self.camps.past.empty?
	  	end

	  	def remove_associated_registrations
	  		uc = self.camps.upcoming.map{|c| c.id}
	  		self.registrations.each do |r|
	  			if uc.include?(r.camp_id)
	  				r.destroy
	  			end
	  		end
	  		
	  	end

		def convert_to_inactive
			if !@destroyable.nil? && @destroyable == false
				remove_associated_registrations
				self.update_attribute(:active, false)
			end
			@destroyable = nil
		end

		


end
