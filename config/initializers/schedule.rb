require 'rufus-scheduler'

InitializerHelpers.skip_console_rake_generators do
  # execute this block only when we are not in console, rake or rails generators
  manager = ScheduleManager.new
  manager.create_email_cron_job
end
