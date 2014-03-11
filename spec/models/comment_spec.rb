require 'spec_helper'

describe Comment do
	before { 
		@user = FactoryGirl.create(:user)
		@entry = @user.entries.create(title: "title", body: "body")
		@comment = @user.comments.create(content: "comment here", entry: @entry)
	}

	subject { @comment }

	it { should respond_to(:user)}
	it { should respond_to(:entry)}

	it { should be_valid }
end
