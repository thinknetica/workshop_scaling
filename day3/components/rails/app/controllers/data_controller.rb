class DataController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:input]

  def input
    files = JSON.parse(params[:files]) || []
    files.each do |file_name|
      DataFile.create(file: file_name)
    end
    head :ok
  end
end
