class Camp < ApplicationRecord
  # relationships
  belongs_to :curriculum
  belongs_to :location
  has_many :camp_instructors
  has_many :instructors, through: :camp_instructors
  has_many :registrations
  has_many :students, through: :registrations

  # validations
  validates_presence_of :location_id, :curriculum_id, :time_slot, :start_date
  validates_numericality_of :cost, greater_than_or_equal_to: 0
  validates_date :start_date, :on_or_after => lambda { Date.today }, :on_or_after_message => "cannot be in the past", on:  :create
  validates_date :end_date, :on_or_after => :start_date
  validates_inclusion_of :time_slot, in: %w[am pm], message: "is not an accepted time slot"
  validates_numericality_of :max_students, only_integer: true, greater_than: 0, allow_blank: true
  validate :curriculum_is_active_in_the_system
  validate :location_is_active_in_the_system
  validate :camp_is_not_a_duplicate, on: :create
  validate :max_students_not_greater_than_capacity
  
  # scopes
  scope :alphabetical, -> { joins(:curriculum).order('name') }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :chronological, -> { order('start_date','end_date') }
  scope :morning, -> { where('time_slot = ?','am') }
  scope :afternoon, -> { where('time_slot = ?','pm') }
  scope :upcoming, -> { where('start_date >= ?', Date.today) }
  scope :past, -> { where('end_date < ?', Date.today) }
  scope :for_curriculum, ->(curriculum_id) { where("curriculum_id = ?", curriculum_id) }
  scope :full, -> {Camp.select('count(*) as ct').joins(:registrations).group(:camp_id).having("ct == max_students")}
  scope :empty, -> {Camp.select('count(*) as c').joins(:registrations).group(:camp_id).having("c == 0")}


    # instance methods
  def name
    self.curriculum.name
  end

  def already_exists?
    Camp.where(time_slot: self.time_slot, start_date: self.start_date, location_id: self.location_id).size == 1
  end

  def is_full?
    self.registrations.size >= self.max_students
  end

  def enrollment
    self.registrations.size
  end


  # callbacks
  

  before_destroy do 
    camp_does_not_have_registrations
    if errors.present?
        @destroyable = false
        throw(:abort)
    else
      remove_instructors_from_inactive_camp
      self.destroy
    end
  end

  before_update do 
    if !self.active
      camp_does_not_have_registrations
      if errors.present?
          throw(:abort)
      end
    end
  end

  private
  def curriculum_is_active_in_the_system
    return if self.curriculum.nil?
    errors.add(:curriculum, "is not currently active") unless self.curriculum.active
  end

  def location_is_active_in_the_system
    return if self.location.nil?
    errors.add(:location, "is not currently active") unless self.location.active
  end

  def camp_is_not_a_duplicate
    return true if self.time_slot.nil? || self.start_date.nil? || self.location_id.nil?
    if self.already_exists?
      errors.add(:time_slot, "already exists for start date, time slot and location")
    end
  end

  def max_students_not_greater_than_capacity
    return true if self.max_students.nil? || self.location_id.nil?
    if self.max_students > self.location.max_capacity
      errors.add(:max_students, "is greater than the location capacity")
    end
  end

  def camp_does_not_have_registrations
    errors.add(:base, "Camp has registrations and cannot be destroyed") unless self.registrations.size == 0
  end

  def remove_instructors_from_inactive_camp
    # confirm that camp is marked as inactive
    #if !self.active
      self.camp_instructors.each{|ci| ci.destroy}
    #end
  end
end
