require 'spec_helper'

describe "EntriesPages" do
  subject { page }
  describe "GET /new_entry_path" do
  	before { visit new_entry_path }
  	# it { should have_title('Ruby on Rails Tutorial Blog App | Create new post')}
  end
end
