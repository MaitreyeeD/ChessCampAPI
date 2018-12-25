class Registration < ApplicationRecord
	belongs_to :camp
	belongs_to :student
	has_one :family, through: :student

	validates_presence_of :camp_id, :student_id
	validate :student_is_active
	validate :camp_is_active
	validate :student_has_appropriate_rating
	validate :student_is_not_registered_for_another_camp_at_same_time, on: :create
	validates :camp_id, presence: true, numericality: { greater_than: 0, only_integer: true }
	validates :student_id, presence: true, numericality: { greater_than: 0, only_integer: true }

	scope :alphabetical, -> { joins(:student).order('last_name, first_name') }
	scope :for_camp, ->(camp_id) { where("camp_id = ?", camp_id) }



	private
		def student_is_active
			is_active_in_system(:student)
		end

		def camp_is_active
			is_active_in_system(:camp)
		end

		def student_has_appropriate_rating
			return true if self.student.nil? || self.camp.nil?
			minrating = self.camp.curriculum.min_rating
			maxrating = self.camp.curriculum.max_rating
			errors.add(:registration, "doesn't have appropriate rating") unless self.student.rating > minrating && self.student.rating < maxrating
		end

		def student_is_not_registered_for_another_camp_at_same_time
			return true if self.camp.nil? || self.student.nil?
		    other_students_registered_at_that_time = Camp.where(start_date: self.camp.start_date, time_slot: self.camp.time_slot).map{|c| c.students }.flatten
		    if other_students_registered_at_that_time.include?(self.student)
		      errors.add(:base, "Student is already registered for another camp at this time")
		    end
		end

	

		def is_active_in_system(attribute)
	      # This method tests to see if the value set for the attribute is
	      # (a) in the system at all, and (b) is active, if the active flag
	      # is applicable.  If that is not the case, it will add an error 
	      # to stop validation process.
	      
	      # determine the class and id we need to work with
	      klass = Object.const_get(attribute.to_s.capitalize)
	      attr_id = "#{attribute.to_s}_id"
	      
	      # assuming the presence of the id is checked earlier, so return true 
	      # if shoulda matchers are being used that might bypass that check
	      return true if attr_id.nil?

	      # determine the set of ids that might be valid
	     
	        # if there is an active scope, take advantage of it
	      all_active = klass.active.to_a.map{|k| k.id}
	      
	      # test to see if the id in question is in the set of valid ids 
	      unless all_active.include?(self.send(attr_id))
	        self.errors.add(attr_id.to_sym, "is not active in the system")
	      end
	    end

	
end
