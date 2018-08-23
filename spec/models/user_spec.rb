require 'rails_helper'

RSpec.describe User, type: :model do
  feature 'User management' do
    scenario 'adds a new user' do
      admin = create(:admin)

      visit root_path
      click_link 'Login In'
      fill_in 'Email', with: admin.email
      fill_in 'Password', with: admin.password
      click_button 'Log In'

      visit root_path
      expect do
        click_link 'Users'
        click_link 'New User'
        fill_in 'Email', with: 'newuser@example.com'
        find('#password').fill_in 'Password', with: '123123'
        find('#password_confirmation').fill_in 'Password confirmation',
          with: '123123'
        click_button 'Create User'
      end.to change(User, :count).by(1)

      expect(current_path).to eq users_path
      expect(page).to have_content 'New user created'
      within 'h1' do
        expect(page).to have_content 'Users'
      end
      expect(page).to have_content 'newuser@example.com'
    end
  end
end
