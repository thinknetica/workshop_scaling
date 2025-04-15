class DataDeleteJob < ApplicationJob
  queue_as :default

  def perform
    if DataFile.processed.exists?

      DataFile.with_advisory_lock('data_delete_job_lock') do
        to_delete = DataFile.processed.limit(100)
        deleted_count = to_delete.delete_all
        Rails.logger.info "Deleted #{deleted_count} files"
      end
    else
      Rails.logger.info "No files to delete"
    end
  end
end