class Instructor < ApplicationRecord
  # relationships
  attr_accessor :username, :email, :password, :password_confirmation

  belongs_to :user
  has_many :camp_instructors
  has_many :camps, through: :camp_instructors

  # validations
  validates_presence_of :first_name, :last_name
  # validates :email, presence: true, uniqueness: { case_sensitive: false}, format: { with: /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))\z/i, message: "is not a valid format" }
  # validates :phone, format: { with: /\A\(?\d{3}\)?[-. ]?\d{3}[-.]?\d{4}\z/, message: "should be 10 digits (area code needed) and delimited with dashes only", allow_blank: true }
 
  before_update do 
    if self.active == false
      remove_from_associated_upcoming_camps
      self.user.update_attribute(:active, false)
    end
  end


  before_destroy do 
      check_if_taught_past_camp
      if errors.present?
        @destroyable = false
        throw(:abort)
      else
        remove_from_associated_upcoming_camps
        self.user.destroy
      end
  end

  after_rollback :convert_to_inactive

  # scopes
  scope :alphabetical, -> { order('last_name, first_name') }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :needs_bio, -> { where('bio IS NULL') }
 

  # class methods
  def self.for_camp(camp)
    # the 'instructive way'... (which I told you if you asked me for help)
    CampInstructor.where(camp_id: camp.id).map{ |ci| ci.instructor }
    # the easy way... 
    # camp.instructors
  end

 

  # instance methods
  def name
    last_name + ", " + first_name
  end
  
  def proper_name
    first_name + " " + last_name
  end

  private

    def no_past_camps?
        self.camps.past.empty?
    end

    def check_if_taught_past_camp
      unless no_past_camps?
          errors.add(:base, "Instructor cannot be destroyed because he taught a past camp.")
      end
    end
    

    def remove_from_associated_upcoming_camps
      uc = self.camps.upcoming.map{|c| c.id}
      self.camp_instructors.each do |ci|
        if uc.include?(ci.camp_id)
          ci.destroy
        end
      end
    end

   

    def convert_to_inactive
      if !@destroyable.nil? && @destroyable == false
        remove_from_associated_upcoming_camps
        self.user.update_attribute(:active, false)
        self.update_attribute(:active, false)
      end
      @destroyable = nil
    end
    



end
