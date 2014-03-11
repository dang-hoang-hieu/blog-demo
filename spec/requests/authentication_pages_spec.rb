require 'spec_helper'

describe "Authentication Pages" do
  subject { page }
  before { visit signin_path }
  let(:user) { FactoryGirl.create(:user) }
  describe "sign in page" do  	
  	it { should have_content('Sign in')}
  end

  describe "sign in action" do

  	let(:submit) { "Sign in" }
  	
  	describe " => when sign in fail" do
  		before { click_button submit }
  		it { should have_error_message('')}

  		describe " => after vising another page" do
	  		before { click_link "Home" }
	  		it { should_not have_error_message('')}
	  	end

      	describe "visiting the following page" do
          before { visit following_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "visiting the followers page" do
          before { visit followers_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "in the Relationships controller" do
	        describe "submitting to the create action" do
	          before { post relationships_path }
	          specify { expect(response).to redirect_to(signin_path) }
	        end

	        describe "submitting to the destroy action" do
	          before { delete relationship_path(1) }
	          specify { expect(response).to redirect_to(signin_path) }
	        end
      	end
  	end

  	

  	describe " => when sign in success" do
  		let(:user) { FactoryGirl.create(:user) }
  		before { 
  			sign_user_in user
  		}

  		it { should have_title(full_title(user.name))}
  		it { should have_welcome_message('')}
  		it { should_not have_link('Sign in', href: signin_path)}
  	end
  end
end
