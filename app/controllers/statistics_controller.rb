class StatisticsController < ApplicationController
  def index
    render json: { message: 'Hello World!' }, status: :ok
  end
  
  # This route will do the following:
  # - Receive MM Data
  # - Perform benchmark testing
  # - Calculate relevant statistics
  # - Persist CSV file with statistics to local
  # - Persist video file to local 
  def video; end
end
