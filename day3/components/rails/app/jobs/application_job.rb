class ApplicationJob < ActiveJob::Base
  include Rails.application.routes.url_helpers
  
  def logger
    ActiveJob::Base.logger
  end
  
end
