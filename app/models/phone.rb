class Phone < ApplicationRecord
  belongs_to :contact

  validates :phone, presence: true, uniqueness: { scope: :contact_id }
end
