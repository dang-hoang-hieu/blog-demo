require 'spec_helper'

describe Entry do
  before { 
  	@user = FactoryGirl.create(:user)
  	@entry = @user.entries.create(title: "title demo", body: "noi dung body")
  }

  subject { @entry }

  it { should respond_to( :title) }
  it { should respond_to( :body) }
  it { should respond_to( :user) }
  it { should be_valid }

  describe "when title is absent" do
  	before { 
  		@entry.title = ""
  	}

  	it { should_not be_valid }
  end

  describe "when body is absent" do
   	before { 
   		@entry.body = ""
   	}
   	it { should_not be_valid }
  end 

  describe "when user is absent" do
  	before { 
  		@entry.user = nil
  	}

  	it { should_not be_valid }
  end 

  describe " get entries from followed_users" do
    before do
      @user = FactoryGirl.create(:user)
    @followed_user = FactoryGirl.create(:user)
    @user.follow!(@followed_user)
    @entry = @user.entries.create(title: "title demo", body: "noi dung body")
    end
  end
end
