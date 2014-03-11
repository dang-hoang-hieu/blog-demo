require 'spec_helper'

describe "Static pages" do
  # let(:title) {  "Ruby on Rails Tutorial Sample App |"}
  subject { page }

  shared_examples_for "all static pages" do
    before { visit root_path }
    it { should have_selector('h1') }
    it { should have_title(full_title('')) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'Sample App' }
    let(:page_title) { '' }
    let(:user) { FactoryGirl.create(:user) }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }

    describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          visit signin_path
          sign_user_in user
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
  end

  describe "Help page" do
    before { visit help_path }

    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    it { should have_content('About Us') }
    it { should have_title(full_title('About Us')) }
  end

  describe "Contact page" do
    before { visit contact_path }
    it { should have_content('Contact') }
    it { should have_title(full_title('Contact')) }
  end

  describe " user not logined, should show welcome page" do
    before { visit root_path }
    it "should have the right links on the layout" do
      # before { sign_}
      visit root_path
      click_link "About"
      expect(page).to have_title(full_title('About Us'))
      click_link "Help"
      expect(page).to have_title(full_title('Help'))
      click_link "Contact"
      expect(page).to have_title(full_title('Contact'))
      click_link "Home"
      click_link "Sign up now!"
      expect(page).to have_title(full_title(''))
      click_link "sample app"
      expect(page).to have_title(full_title(''))
    end
  end
  
  describe " should have feed reply" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:replied_user) { FactoryGirl.create(:user) }
    let!(:other_user) { FactoryGirl.create(:user) }
    let!(:replied_post) { FactoryGirl.create(:micropost, user: user, in_reply_to: replied_user) }    
    
    before do
      user.follow!(replied_user)
      visit signin_path
      sign_user_in replied_user      
      visit root_path
    end

    it { should have_link("#{user.name}", user_path(user))}
    
  end
end

