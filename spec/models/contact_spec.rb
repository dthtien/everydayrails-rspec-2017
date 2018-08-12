require 'rails_helper'
# Testing
describe Contact do
  it 'is valid with a firstname, lastname and email' do
    contact = Contact.new(
      firstname: 'Anthony',
      lastname: 'Daut',
      email: 'dthtien@gmail.com'
    )
    expect(contact).to be_valid
  end

  it 'is invalid without a firstname' do
    contact = Contact.new(firstname: nil)
    contact.valid?
    expect(contact.errors[:firstname]).to include("can't be blank")
  end

  it 'is invalid without a lastname' do
    contact = Contact.new(lastname: nil)
    contact.valid?
    expect(contact.errors[:lastname]).to include("can't be blank")
  end

  it 'is invalid with duplucate email address' do
    Contact.create(
      firstname: 'Anthony', lastname: 'The',
      email: 'dthtien@gmail.com'
    )
    contact = Contact.new(
      firstname: 'dthtien', lastname: 'Dau',
      email: 'dthtien@gmail.com'
    )
    contact.valid?
    expect(contact.errors[:email]).to include('has already been taken')
  end

  it "returns a contact's full name as a string" do
    contact = Contact.new(firstname: 'dhtien', lastname: 'tien',
                          email: 'dthtien1@gmail.com')
    expect(contact.name).to eq "#{contact.firstname} #{contact.lastname}"
  end

  describe 'filter lastname by letter' do
    before :each do
      @smith = Contact.create(
        firstname: 'John',
        lastname: 'Smith',
        email: 'jsmith@example.com'
      )
      @jones = Contact.create(
        firstname: 'Tim',
        lastname: 'Jones',
        email: 'tjone@ex'
      )
      @johnson = Contact.create(
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
end
