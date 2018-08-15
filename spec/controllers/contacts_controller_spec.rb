require 'rails_helper'
# Contact test
RSpec.describe ContactsController, type: :controller do

  describe 'GET # index' do
    context 'with params[:letter]' do
      it 'populates an array of contacts starting with the letter' do
        smith = create(:contact, lastname: 'Smith')
        create(:contact, lastname: 'Jones')

        get :index, params: {letter: 'S'}
        expect(assigns(:contacts)).to match_array([smith])
      end

      it 'render the :index template' do
        get :index, params: {letter: 'S'}
        expect(response).to render_template :index
      end
    end

    context 'without params[:letter]' do
      it 'populates an array of all contacts' do
        smith = create(:contact, lastname: 'Smith')
        jones = create(:contact, lastname: 'Jones')

        get :index
        expect(assigns(:contacts)).to match_array([smith, jones])
      end

      it 'renders the :index template' do
        get :index
        expect(response).to render_template :index
      end
    end
  end

  describe 'Get #show' do
    it 'assigns the requested contact to @contact' do
      contact = create(:contact)
      get :show, params: { id: contact.id }
      expect(assigns(:contact)).to eq contact
    end

    it 'render the :show template' do
      contact = create(:contact)
      get :show, params: { id: contact.id }
      expect(response).to render_template :show
    end
  end

  describe 'Get #new' do
    it 'assigns a new contact to @contact' do
      get :new
      expect(assigns(:contact)).to be_a_new(Contact)
    end
    it 'render the :new template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'Get #edit' do
    it 'assigns the requested contact to @contact' do
      contact = create(:contact)
      get :edit, params: { id: contact.id }
      expect(assigns(:contact)).to eq contact
    end
    it 'render the :edit template' do
      contact = create(:contact)
      get :edit, params: { id: contact }
      expect(response).to render_template :edit
    end
  end

  describe 'POST @create' do
    before :each do
      @phones = [
        attributes_for(:phone),
        attributes_for(:phone),
        attributes_for(:phone)
      ]
    end

    context 'with valid attributes' do
      it 'save the new contact in the database' do
        expect{
          post :create, params: {
            contact: attributes_for(:contact, phones_attributes: @phones)
          }
        }.to change(Contact, :count).by(1)
      end

      it 'redirect to contacts#show' do
        post :create, params: {
          contact: attributes_for(
            :contact,
            phones_attributes: @phones
          )
        }
        expect(response).to redirect_to contact_path(assigns[:contact])
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new contact in the database' do
        expect{
          post :create, params: { contact: attributes_for(:invalid_contact) }
        }.to_not change(Contact, :count)
      end

      it 're-renders the :new template' do
        post :create, params: { contact: attributes_for(:invalid_contact) }
        expect(response).to render_template :new
      end
    end
  end
end
