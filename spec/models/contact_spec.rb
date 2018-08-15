require 'rails_helper'
# Testing
describe Contact do
  it 'is valid with a firstname, lastname and email' do
    expect(build(:contact)).to be_valid
  end

  it 'is invalid without a firstname' do
    contact = build(:contact, firstname: nil)
    contact.valid?
    expect(contact.errors[:firstname]).to include("can't be blank")
  end

  it 'is invalid without a lastname' do
    contact = build(:contact, lastname: nil)
    contact.valid?
    expect(contact.errors[:lastname]).to include("can't be blank")
  end

  it 'is invalid with duplucate email address' do
    FactoryBot.create(:contact, email: 'dthtien@gmail.com')
    contact = build(
      :contact,
      email: 'dthtien@gmail.com'
    )
    contact.valid?
    expect(contact.errors[:email]).to include('has already been taken')
  end

  it "returns a contact's full name as a string" do
    contact = build(:contact, firstname: 'Anthony', lastname: 'Dau')
    expect(contact.name).to eq "#{contact.firstname} #{contact.lastname}"
  end

  describe 'filter lastname by letter' do
    before :each do
      @smith = FactoryBot.create(
        :contact,
        firstname: 'John',
        lastname: 'Smith',
        email: 'jsmith@example.com'
      )
      @jones = Contact.create(
        :contact,
        firstname: 'Tim',
        lastname: 'Jones',
        email: 'tjone@ex'
      )
      @johnson = Contact.create(
        :contact,
        firstname: 'John',
        lastname: 'Johnson',
        email: 'jjohnson@example.com'
      )
    end
    context "with matching letters" do
      it 'returns sorted array of result that match' do
        expect(Contact.by_letter('J')).to eq [@johnson, @jones]
      end
    end
    context 'with non-matching letters' do
       it 'omits results that do not match' do
        expect(Contact.by_letter('J')).not_to include @smith
      end
    end
  end
  
  it 'has a valid factory' do
    expect(FactoryBot.build(:contact)).to be_valid
  end

  it 'has three phone number' do
    expect(create(:contact).phones.count).to eq 3
  end
end
