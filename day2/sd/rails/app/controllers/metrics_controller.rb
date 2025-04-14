class MetricsController < ApplicationController
  def sync_sleep
    seconds = params[:seconds].to_f
    start_time = Time.now

    sleep(seconds)

    duration = Time.now - start_time
    log_metric("sync_sleep.duration", duration)

    render plain: "Slept for #{seconds} seconds"
  end

  def cached_heavy_query
    result  = Rails.cache.fetch("heavy_query", expires_in: 12.hours) do
      heavy_query
    end

    render plain: result
  end

  private

  def log_metric(name, value)
    Rails.logger.info "[METRIC] #{name} = #{value.round(3)}s"
  end

  def heavy_query
    sleep(5)
  end
end
