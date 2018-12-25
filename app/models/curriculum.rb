class Curriculum < ApplicationRecord
  # relationships
  has_many :camps

  # validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  ratings_array = [0] + (100..3000).to_a
  validates :min_rating, numericality: { only_integer: true }, inclusion: { in: ratings_array }
  validates :max_rating, numericality: { only_integer: true }, inclusion: { in: ratings_array }
  validate :max_rating_greater_than_min_rating

  # scopes
  scope :alphabetical, -> { order('name') }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :for_rating, ->(rating) { where("min_rating <= ? and max_rating >= ?", rating, rating) }
  
  before_destroy do 
      cannot_destroy_object
  end


  before_update :deactivate_curriculum
  attr_accessor :destroyable


  private

  def cannot_destroy_object
    self.destroyable = false
    msg = "This #{self.class.to_s.downcase} cannot be deleted at this time. If this is a mistake, please alert the administrator."
    errors.add(:base, msg)
    throw(:abort) if errors.present? 
  end

  def deactivate_curriculum
    return true unless self.camps.upcoming.size > 0 
    self.camps.upcoming.each do |c|
      if c.registrations.size != 0
        errors.add(:base, "cannot be made inactive")
        throw(:abort) if errors.present? 
      end
    end
    #self.update_attribute(:active, false)


  end

  def max_rating_greater_than_min_rating
    # only testing 'greater than' in this method, so...
    return true if self.max_rating.nil? || self.min_rating.nil?
    unless self.max_rating > self.min_rating
      errors.add(:max_rating, "must be greater than the minimum rating")
    end
  end




end
