class Worker < ApplicationRecord
  has_many :shifts, dependent: :destroy
end
