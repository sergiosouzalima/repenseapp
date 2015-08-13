class Classroom < ActiveRecord::Base
  belongs_to :student
  belongs_to :course
  validates  :student_id , presence: true, uniqueness: {scope: :course_id}
  validates  :course_id  , presence: true
  validates  :entry_at   , presence: true
  def default_values
    self.entry_at = Date.time.now
  end

end
