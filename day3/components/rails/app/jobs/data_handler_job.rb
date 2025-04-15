class DataHandlerJob < ApplicationJob
  queue_as :default

  def perform#(arg = nil)
    if DataFile.raw.exists?
      raw_data = DataFile.raw.limit(3)
      raw_data.each do |data_file|
        data_file.update(status: 1)
        sleep(2)
      end

      Rails.logger.info "Processed #{raw_data.size} files"
    else
      Rails.logger.info "No files to process"
    end
  end
end
