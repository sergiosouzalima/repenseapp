class WelcomeController < ApplicationController

  def index
    @enrollments = Classroom.count
  end

end
