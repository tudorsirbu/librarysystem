require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.cron '0 17 * * 1-5' do
  loans_controller = LoansController.new
  loans_controller.send_loan_reminders_due_today
end