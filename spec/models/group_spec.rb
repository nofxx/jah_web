require File.dirname(__FILE__) + '/../spec_helper'

describe Group do

  it "should be valid" do
    Group.spawn.should be_valid
  end
end

# == Schema Information
#
# Table name: groups
#
#  id          :integer         not null, primary key
#  name        :string(255)     not null
#  state       :string(255)
#  hosts_count :integer         default(0), not null
#  created_at  :datetime
#  updated_at  :datetime
#

