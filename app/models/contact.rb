class Contact < ApplicationRecord
  has_many :phones
  validates :firstname, :lastname, :email, presence: true
  validates :email, uniqueness: true
  validates :phones, length: { is: 3 }

  def name
    "#{firstname} #{lastname}"
  end

  def self.by_letter(letter)
    where("lastname LIKE ?", "%#{letter}%").order(:lastname)
  end
end
