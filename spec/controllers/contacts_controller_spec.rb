require 'rails_helper'
# Contact test
RSpec.describe ContactsController, type: :controller do
  shared_examples 'public to access to contacts' do
    before :each do
      @contact = create( :contact, firstname: 'Lawrence', lastname: 'Smith')
    end

    describe 'GET # index' do
      context 'with params[:letter]' do
        it 'populates an array of contacts starting with the letter' do
          smith = create(:contact, lastname: 'Smith')
          create(:contact, lastname: 'Jones')

          get :index, params: { letter: 'S' }
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
  end
  describe 'administator access' do
    before :each do
      set_user_session create(:admin)
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
          expect do
            post :create, params: { contact: attributes_for(:invalid_contact) }
          end.to_not change(Contact, :count)
        end

        it 're-renders the :new template' do
          post :create, params: { contact: attributes_for(:invalid_contact) }
          expect(response).to render_template :new
        end
      end

      describe 'PATCH #update' do
        before :each do
          @contact = create(
            :contact,
            firstname: 'Lawrence',
            lastname: 'Smith'
          )
        end

        context 'valid attributes' do
          it 'locates the requested @contact' do
            patch :update,
              params: { id: @contact.id, contact: attributes_for(:contact) }
            expect(assigns(:contact)).to eq(@contact)
          end

          it 'change attributes of @contact' do
            patch :update,
              params: {
              id: @contact,
              contact: attributes_for(
                :contact,
                firstname: 'Larry',
                lastname: 'Smith'
              )
            }
            @contact.reload
            expect(@contact.firstname).to eq('Larry')
            expect(@contact.lastname).to eq('Smith')
          end

          it 'redirects to updated contact' do
            patch :update, params: {
              id: @contact,
              contact: attributes_for(:contact)
            }

            expect(response).to redirect_to @contact
          end
        end

        context 'with invalid attributes' do
          it 'does not change the attributes of contact' do
            patch :update, params: {
              id: @contact,
              contact: attributes_for(
                :contact,
                firstname: 'Larry',
                lastname: nil
              )
            }
            @contact.reload
            expect(@contact.firstname).to_not eq('Larry')
            expect(@contact.lastname). to eq('Smith')
          end

          it 're-renders the edit template' do
            patch :update,
              params: {
              id: @contact,
              contact: attributes_for(:invalid_contact)
            }
            expect(response).to render_template :edit
          end
        end
      end

      describe 'DELETE #destroy' do
        before :each do
          @contact = create(:contact)
        end

        it 'deletes the contact' do
          expect do
            delete :destroy,
              params: { id: @contact }
          end.to change(Contact, :count).by(-1)
        end

        it 'redirects to contacts#index' do
          delete :destroy, params: { id: @contact }
          expect(response).to redirect_to contacts_url
        end
      end
    end

    describe 'PATCH hide_contact' do
      before :each do
        @contact = create(:contact)
      end

      it 'marks the contact as hidden' do
        patch :hide_contact, params: { id: @contact }
        expect(@contact.reload.hidden?).to be true
      end

      it 'redirects to contacts#index' do
        patch :hide_contact, params: { id: @contact }
        expect(response).to redirect_to contacts_url
      end
    end

    describe 'CSV output' do
      it 'returns a CSV file' do
        get :index, format: :csv
        expect(response.headers['Content-Type']).to match 'text/csv'
      end

      it 'returns content' do
        create(
          :contact,
          firstname: 'Aaron',
          lastname: 'Sumner',
          email: 'aaron@sample.com'
        )

        get :index, format: :csv
        expect(response.body).to match 'Aaron,Sumner,aaron@sample.com'
      end
    end
  end

  describe 'guest access' do
    describe 'Get #new' do
      it 'requires login' do
        get :new
        expect(response).to redirect_to login_url
      end
    end

    describe 'GET #edit' do
      it 'requires login' do
        contact = create(:contact)
        get :edit, id: contact
        expect(response).to redirect_to login_url
      end
    end

    describe 'POST #create' do
      it 'requires login' do
        post :create, params: {
          id: create(:contact), contact: attributes_for(:contact)
        }
        expect(response).to redirect_to login_url
      end
    end
  end
end
