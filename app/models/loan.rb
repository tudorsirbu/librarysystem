class Loan < ActiveRecord::Base
  belongs_to :user
  belongs_to :item

  attr_accessor :barcode
  def self.loan_user_search(searchstr)
    if searchstr == 1
      joins(:user).where("users.id = 1")
    else
      joins(:user).where("users.id = ?",searchstr)
    end
  end

  def return_dates
    due_date = self.due_date
    dates = []
    for i in 1..2
      dates << [due_date + (i-1)*2.weeks,"#{i*2} weeks - #{due_date + (i-1)*2.weeks}"]
    end
    return dates
  end

  def return!
    update_attribute('returned_on', Time.now)
  end

  def self.ransackable_scopes(auth_object = nil)
    [:loan_user_search]
  end
end
