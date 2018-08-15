require 'rails_helper'

RSpec.describe Phone do
  it 'it does not allow duplicate phone number per contact' do
    contact = create(:contact)
    create(:home_phone, contact: contact, phone: '7855551234')

    mobile_phone = build(
      :mobile_phone,
      contact: contact,
      phone: '7855551234'
    )

    mobile_phone.valid?
    expect(mobile_phone.errors[:phone]).to include('has already been taken')
  end

  it "allows two contacts to share a phone number" do
    create(:phone, phone_type: 'home', phone: '7855551234')
    expect(build(:phone, phone_type: 'home', phone: '7855551234')).to be_valid
  end
end
