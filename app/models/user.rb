class User < ActiveRecord::Base
  def self.import
    users = Rails.root.join('db').join('users.csv')

    CSV.foreach(users, :headers => true) do |row_user|

      user = User.new
      user.ucard_no = "00" + row_user["ucard_no"]
      user.surname = row_user["surname"]
      user.forename = row_user["forename"]
      user.job_title = row_user["job_title"]
      user.save
    end

  end
end
