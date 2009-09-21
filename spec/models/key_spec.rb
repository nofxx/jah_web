require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Key do
  before(:each) do
    @valid_attributes = {
      :value => "value for value"
    }
  end

  it "should create a new instance given valid attributes" do
    Key.create!(@valid_attributes)
  end
end

# == Schema Information
#
# Table name: keys
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  value      :text
#  created_at :datetime
#  updated_at :datetime
#

