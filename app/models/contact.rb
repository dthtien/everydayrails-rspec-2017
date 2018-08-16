class Contact < ApplicationRecord
  has_many :phones, dependent: :destroy
  validates :firstname, :lastname, :email, presence: true
  validates :email, uniqueness: true
  validates :phones, length: { is: 3 }
  accepts_nested_attributes_for :phones

  def name
    "#{firstname} #{lastname}"
  end

  def self.by_letter(letter)
    where("lastname LIKE ?", "%#{letter}%").order(:lastname)
  end

end
