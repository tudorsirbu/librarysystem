class User < ActiveRecord::Base
  has_many :loans
  has_many :item_requests
  validates_presence_of :ucard_no, :surname, :forename, :job_title, :email

  def self.import
    users = Rails.root.join('db').join('users.csv')

    CSV.foreach(users, :headers => true) do |row_user|

      user = User.new
      user.ucard_no = "00" + row_user["ucard_no"]
      user.surname = row_user["forename"]
      user.forename = row_user["surname"]
      user.job_title = row_user["job_title"]
      user.save(validate: false)
    end
  end
  def self.full_name_search(searchstr)
    where("LOWER(users.forename) || LOWER(users.surname) LIKE ?","%#{searchstr.downcase}%")
  end

  def already_requested?(item)
    !ItemRequest.where(item_id: item.id, user_id: self.id).empty?
  end

  def self.ransackable_scopes(auth_object = nil)
    [:full_name_search]
  end
  def to_label
    "#{self.forename} #{self.surname}"
  end
end
