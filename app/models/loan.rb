class Loan < ActiveRecord::Base
  def self.loan_user_search(searchstr)
    joins(:user).where("users.id LIKE ?","%#{searchstr.downcase}%")
  end

  def self.ransackable_scopes(auth_object = nil)
    [:loan_user_search]
  end
end
