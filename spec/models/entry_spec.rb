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
end
