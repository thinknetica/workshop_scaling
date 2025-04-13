class MetricsController < ApplicationController
  def sync_sleep
    seconds = params[:seconds].to_f
    start_time = Time.now

    sleep(seconds)

    duration = Time.now - start_time
    log_metric("sync_sleep.duration", duration)

    render plain: "Slept for #{seconds} seconds"
  end

  private

  def log_metric(name, value)
    Rails.logger.info "[METRIC] #{name} = #{value.round(3)}s"
  end
end
