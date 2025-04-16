class DataController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:input]

  def input
    files = JSON.parse(params[:files]) || []
    data_count = 0

    files.each do |file_name|
      data = DataFile.new(file: file_name)

      if data.save
        data_count += 1
        ActiveSupport::Notifications.instrument('metrics.raw_data_counter')
      end
    end

    render json: { data_count: data_count }
  end
end
