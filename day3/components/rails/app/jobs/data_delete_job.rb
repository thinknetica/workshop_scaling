class DataDeleteJob < ApplicationJob
  queue_as :default

  def perform
    DataFile.with_advisory_lock('data_delete_job_lock') do
      to_delete = DataFile.processed.limit(100)
      deleted_count = to_delete.delete_all

      ActiveSupport::Notifications.instrument('metrics.deleted_data_counter', count: deleted_count)
      Rails.logger.info "Deleted #{deleted_count} files"
    end
  end
end