class Student < ActiveRecord::Base
  STUDENT_TYPE = [1,2]
  has_many :classrooms, dependent: :destroy
  validates :name,               presence: true, uniqueness: true, length: { maximum: 45 }
  validates :register_number,    presence: true, uniqueness: true, length: { maximum: 45 }
  validates :status,             presence: true, inclusion: { in: STUDENT_TYPE }
  before_create :default_values
  def default_values
    self.status = STUDENT_TYPE[0]
  end

end
