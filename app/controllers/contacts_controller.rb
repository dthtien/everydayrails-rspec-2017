class ContactsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit updated destroy]
  before_action :set_contact, only: %i[show edit update destroy hide_contact]
  # GET /contacts
  # GET /contacts.json
  def index
    letter = params[:letter]
    @contacts = letter ? Contact.by_letter(letter) : Contact.all

    respond_to do |format|
      format.html
      format.csv do
        send_data Contact.to_csv(@contacts),
          type: 'text/csv; charset=iso-8859-1; header=present',
          disposition: 'attachment; filename=contact.csv'
      end
    end
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  def hide_contact
    @contact.toggle!(:hidden)
    redirect_to contacts_path, notice: 'Success!'
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:firstname, :lastname, :email,
        phones_attributes: %i[id phone phone_type])
    end
end
