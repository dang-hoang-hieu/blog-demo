require 'spec_helper'

describe "UserPages" do
  subject { page }
  
  describe "GET /signup" do
  	before { visit signup_path}
    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

  describe "profile page" do
  	let(:user){ FactoryGirl.create(:user) }
    
  	before { visit user_path(user) }

  	it "should have these content" do
  		expect(page).to have_content(user.name)
  	end
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before { 
        visit signup_path
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      }

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "when signup successfully" do
        before { click_button submit }

        describe "should return profile page" do
          it { should have_content("Example User")}
          it { should have_title("Example User") }  
          it { should have_welcome_message("welcome to sample app") }
        end

        describe " =>should have user info" do
          let(:user) { User.find_by(email: "user@example.com") }

          it { should have_title(full_title(user.name)) }
          it { should have_link('Sign out') }
          it { should have_welcome_message }
          it { should have_link('Users', href: users_path)}
          it { should have_link('Profile', href: user_path(user))}
          it { should have_link('Settings', href: edit_user_path(user))}

          describe " when signout" do
            before { click_link "Sign out"}
            it { should have_link('Sign in')}
          end
        end
      end
    end
  end

  describe "Edit page =>" do
    let(:user) { FactoryGirl.create(:user)}
    before do
      sign_user_in user
      visit edit_user_path(user) 
    end

    describe " should have these info" do
      it { should have_content('Update your profile') }
      it { should have_title('Edit user') }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe " when submit wrong info" do
      before { click_button "Save changes" }
      it { should have_error_message('') }
    end

    describe " when submit valid info" do
      let(:new_name) { "new name" }
      let(:new_email) { "new_email@email.com" }

      before do
        fill_in "Name",                  with: new_name
        fill_in "Email",                 with: new_email
        fill_in "Password",              with: user.password
        fill_in "Confirm Password",      with: user.password
        click_button "Save changes"
      end

      it { should have_welcome_message('') }
      it { should have_title(new_name)}
      it { should have_link('Sign out', href: signout_path)}

      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email}
    end
  end


  describe " Authorization =>" do
    describe "when not-signined user attempt =>" do
      let(:user) { FactoryGirl.create(:user) }
      describe " edit page" do
        before { visit edit_user_path(user) }
        it { should have_link('Sign in') }
        it { should have_title('Sign in') }

        describe "when signed in, show do friendly forwarding" do
          before { sign_user_in user }
          it { should have_title('Edit user')}
        end

        describe " when attempt sign in second time, should not do friendly forwarding" do
          # let(:password) { user.password}
          before do
            fill_in "Email",     with: user.email.upcase
            fill_in "Password",  with: "failse_password"
            click_button "Sign in"
            
            fill_in "Email",     with: user.email.upcase
            fill_in "Password",  with: user.password
            click_button "Sign in"

            # sign_user_in user, no_capybara: true
          end
          
          it { should_not have_title('Edit user')}
          it { should have_link('Settings')}
        end
      end

      # describe "in the Microposts controller" do

      #   describe "submitting to the create action" do
      #     before { post microposts_path }
      #     specify { expect(response).to redirect_to(signin_path) }
      #   end

      #   describe "submitting to the destroy action" do
      #     # before { delete micropost_path(FactoryGirl.create(:micropost)) }
      #     specify { expect(response).to redirect_to(signin_path) }
      #   end
      # end

      describe " submit value" do
        before do
          patch user_path(user)
        end
        specify { expect(response).to redirect_to(signin_path) }
      end

      describe " user index page =>" do
        describe " when not sign in yet =>" do
          before { visit users_path }
          it { should have_title('Sign in')}  
          it { should have_link('Sign in')}
        end
        
        describe " when signed in" do
          before do
            sign_user_in FactoryGirl.create(:user)
            FactoryGirl.create(:user, name: 'bobby', email: 'bob@mail.com')
            FactoryGirl.create(:user, name: 'mary',  email: 'mary@mail.com')
            visit users_path
          end

          it { should have_title('All users') }
          it { should have_content('All users') }

          it 'should list all users' do
            User.all.each do |user|
              expect(page).to have_selector('li', text: user.name)
            end
          end
        end
      end 
    end

    describe " as wrong user =>" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@email.com")}
      before { sign_user_in user, no_capybara: true }

      describe " GET request to wrong user" do
        before { get edit_user_path(wrong_user) } 
        specify { expect(response).to redirect_to(root_url)}
        specify { expect(response.body).not_to match(full_title('Edit user')) }
      end

      describe " PATCH reques to wrong user" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end

    describe " index page =>" do
      let(:user) { FactoryGirl.create(:user) }
      before(:each) do
        sign_user_in user
        visit users_path
      end

      it { should have_title('All users') }
      it { should have_content('All users') }

      describe " pagination" do
        before(:all) { 30.times { FactoryGirl.create(:user)} }
        after(:all)  { User.delete_all }

        it { should have_selector('div.pagination') }

        it ' should list each user' do
          User.paginate(page: 1).each do |user|
            expect(page).to have_selector('li', text: user.name)
          end
        end
      end

      # describe " delete user" do
      #   it { should_not have_link('delete', href: user_path(user))}
      #   describe " as admin" do
      #     let(:admin) { FactoryGirl.create(:admin) }
      #     before do
      #       # visit signout_path
      #       sign_user_in admin
      #       visit users_path
      #     end
      #     it { should have_link('delete', href: user_path(User.first))}
      #     it { should_not have_link('delete', href: user_path(admin)) }
      #     describe "admin able delete other" do
      #       it " delete each user" do
      #         expect do
      #           click_link "delete", match: :first
      #         end.to change(User, :count).by(-1)
      #       end
      #     end
      #   end

      #   describe " as non-admin" do
      #     let(:user) {FactoryGirl.create(:user) }
      #     let(:non_admin) { FactoryGirl.create(:user) }

      #     before { 
      #       sign_user_in non_admin, no_capybara: true
      #     } 

      #     describe " when delete" do
      #       before { delete user_path(user) }
      #       specify do
      #         expect(response).to redirect_to(root_url)
      #       end
      #     end
      #   end

      # end
    end

    # describe " user not allow to PATCH admin attribute" do
    #   let(:user) { FactoryGirl.create(:user) }
    #   before { sign_user_in user, no_capybara: true}
    #   describe " when try to PATCH, should return to root_url" do
    #     before { 
    #       user[:admin] = true
    #       patch user_path(user), user: { admin: true, password: user.password, password_confirmation: user.password}
    #     }
    #     specify {
    #       expect(response).to redirect_to(root_url)  
    #     }
        
    #   end
    # end

    describe "when signed-in user try to => " do
      let(:user) { FactoryGirl.create(:user) }
      before do
        sign_user_in user, no_capybara: true        
      end

      describe " create new user" do
        before { get signup_path }
        specify do
          expect(response).to redirect_to(root_url)
        end  
      end
      describe " submit to create new user" do
        let(:user_params) do {user: { name: "new name", 
                                    email: user.email,
                                    password: user.password, 
                                    password_confirmation: user.password }}
        end
        before { post users_path, user_params }

        specify do
          expect(response).to redirect_to(root_url)
        end
      end
    end

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        # FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        # FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_user_in user
        visit root_path
      end

      # it "should render the user's feed" do
      #   user.feed.each do |item|
      #     expect(page).to have_selector("li##{item.id}", text: item.content)
      #   end
      # end

    end

    # describe " microposts number in sidebar" do
    #   let(:user) { FactoryGirl.create(:user) }

    #   describe " side bar count" do
    #     describe "plural values" do
    #       before do
    #         FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")        
    #         FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
    #         sign_user_in user
    #         visit root_path
    #       end
    #       it { should have_content("#{user.microposts.count} microposts") }
    #     end        

    #     describe "singluar value" do
    #       before do
    #         FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")        
            
    #         sign_user_in user
    #         visit root_path
    #       end
    #       it { should have_content("#{user.microposts.count} micropost")}
    #     end
    #   end
    # end

  end
  
  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }

    describe "followed users" do
      before do
        sign_user_in user
        visit following_user_path(user)
      end

      it { should have_title(full_title('Following')) }
      it { should have_selector('h3', text: 'Following') }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end

    describe "followers" do
      before do
        sign_user_in other_user
        visit followers_user_path(other_user)
      end

      it { should have_title(full_title('Followers')) }
      it { should have_selector('h3', text: 'Followers') }
      it { should have_link(user.name, href: user_path(user)) }
    end


  end

  describe "follow/unfollow buttons" do
      let(:user) { FactoryGirl.create(:user) }
      let(:other_user) { FactoryGirl.create(:user) }
      before { 
        sign_user_in user 
        # user.follow!(other_user)
      }

      describe "following a user" do
        before { visit user_path(other_user) }        

        it "should increment the followed user count" do
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end

        it "should increment the other user's followers count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Follow" }
          it { should have_xpath("//input[@value='Unfollow']") }
        end
      end

      describe "unfollowing a user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "should decrement the followed user count" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end

        it "should decrement the other user's followers count" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { should have_xpath("//input[@value='Follow']") }
        end
      end
    end
end
