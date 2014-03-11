require 'spec_helper'

describe User do
  before { @user = FactoryGirl.create(:user) }

  subject { @user }

  it { should respond_to( :name) }
  it { should respond_to( :email) }
  it { should respond_to( :password_digest) }
  it { should respond_to( :password )}
  it { should respond_to( :password_confirmation )}
  it { should respond_to( :authenticate )}
  it { should respond_to( :remember_token )}

  it { should be_valid}

  describe "when be a admin" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end
    it { should be_admin}
  end

  describe "when password is too short" do
  	before { @user.password = @user.password_confirmation = "a" * 5 }

  	it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com hfef@mail...com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "return value of authenticate method" do 
  	before { @user.save }
  	let(:found_user) { User.find_by(email: @user.email)}

  	describe "user should be accessed" do  		
  		it { should eq found_user.authenticate(@user.password)}
  	end

  	describe "user should not be accessed" do
  		let(:user_for_invalid) { found_user.authenticate("invalid") }
  		it { should_not eq user_for_invalid }
  		specify { expect(user_for_invalid).to be_false}
  	end
  end

  describe "when password is not present" do
  	before { 
  		@user.password = " "
  		@user.password_confirmation = " "
  	}

  	it { should_not be_valid}
  end

  describe "when password is not match" do
  	before do 
  		@user.password_confirmation = "mismatch"
  	end
  	it { should_not be_valid}
  end
  describe "When name is not present" do
  	before { @user.name = "" }
  	it { should_not be_valid}
  end

  describe "when name is too long" do
  	before { @user.name = "a" * 51 }
  	it { should_not be_valid}
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when email is already taken" do
  	before {
  		user_with_same_email = @user.dup
  		user_with_same_email.email = @user.email.upcase
  		user_with_same_email.save
  	}
  end

  describe "email should be downcase before save to db" do
  	let(:mix_case_email) { "HoangHIEU@mail.com" }  	
  	before {  		
  		@user.email = mix_case_email
  		@user.save
  	}
  	it " => should be downcase" do  		
  		expect(@user.reload.email).to eq mix_case_email.downcase
  	end
  end

  describe "before create" do
    before { @user.save }
      its(:remember_token) { should_not be_blank}
  end

  # describe " following user" do
  #   let(:other_user) { FactoryGirl.create(:user) }
  #   before {
  #     @user.save
  #     @user.follow!(other_user)
  #   }

  #   it { should be_following(other_user) }
  #   its(:followed_users) { should include(other_user)}

  #   describe " and unfollowing user" do
  #     before { @user.unfollow!(other_user) }
  #     it { should_not be_following(other_user) }
  #     its(:followed_users) { should_not include(other_user)}
  #   end
  #   describe "followed_users "  do
  #     subject { other_user }
  #     its(:followers) { should include(@user) }
  #   end

  #   describe " should send mail notify follow =>" do
  #     describe " length > 0" do
  #       ActionMailer::Base.deliveries.length > 0
  #     end

  #     describe " email address eq" do
  #       ActionMailer::Base.deliveries == nil
  #     end
      
  #   end
  # end
 

end
