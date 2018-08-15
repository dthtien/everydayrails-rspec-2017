class Phone < ApplicationRecord
  belongs_to :contact, optional: true

  validates :phone, presence: true, uniqueness: { scope: :contact_id }
end
