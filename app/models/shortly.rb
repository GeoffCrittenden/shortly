class Shortly < ActiveRecord::Base
  validates :url, presence: true
  validates :url, format: { with: // }
end
