class Course < ActiveRecord::Base
  COURSE_TYPE = [1,2]
  has_many :classrooms, dependent: :destroy
  validates :name,               presence: true, uniqueness: true, length: { maximum: 45 }
  validates :description,        presence: true, length: { maximum: 45 }
  validates :status,             presence: true, inclusion: { in: COURSE_TYPE }
  before_create :default_values
  def default_values
    self.status = COURSE_TYPE[0]
  end

end
