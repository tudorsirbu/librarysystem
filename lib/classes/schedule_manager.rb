class ScheduleManager
  require 'rufus-scheduler'

  def create_email_cron_job
    if (defined? $scheduler).nil?
      $scheduler = Rufus::Scheduler.new
    end
    $scheduler.cron '0 18 * * 1-5 Europe/London' do
      loans_controller = LoansController.new
      loans_controller.send_loan_reminders_due_today
    end
  end
end