class TestSchedulerJob < ApplicationJob
  def perform(from, to)
    ap "  ===> TestSchedulerJob schedule: #{from} #{to}"
    timeseries(from: from, to: to).each do |(b, e)|
      TestJob.perform_later(b, e)
    end
  end

  def timeseries(from:, to:, step: 1.day)
    Enumerator.new do |y|
      stop = to.utc.beginning_of_day

      b = from.utc.beginning_of_day
      e = b + step

      while e <= stop
        y << [b, e]

        b = e
        e = b + step
      end
    end
  end
end
