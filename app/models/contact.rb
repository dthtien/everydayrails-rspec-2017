class Contact < ApplicationRecord
  validates :firstname, :lastname, :email, presence: true
  validates :email, uniqueness: true

  def name
    "#{firstname} #{lastname}"
  end

  def self.by_letter(letter)
    where("lastname LIKE ?", "%#{letter}%").order(:lastname)
  end
end
