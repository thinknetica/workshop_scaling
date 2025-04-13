class TestSidekiqJob < ApplicationJob
  self.queue_adapter = :sidekiq

   def perform *args
     ap "  ===> TestSidekiqJob performed: #{args}"
   end
end
