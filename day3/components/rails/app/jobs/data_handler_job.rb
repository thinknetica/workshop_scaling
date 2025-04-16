class DataHandlerJob < ApplicationJob
  queue_as :default

  def perform
    raw_data = DataFile.raw

    raw_data.each do |data_file|
      data_file.update(status: 1)
      ActiveSupport::Notifications.instrument('metrics.processed_data_counter')
      sleep(2)
    end

    Rails.logger.info "Processed #{raw_data.size} files"
  end
end
