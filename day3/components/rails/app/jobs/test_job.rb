class TestJob < ApplicationJob
   def perform *args
     ap "  ===> TestJob performed: #{args}"
   end
end
