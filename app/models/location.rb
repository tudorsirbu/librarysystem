class Location < ActiveRecord::Base
has_many :items
def to_label
  "#{self.building} - #{self.room}"
end
end
