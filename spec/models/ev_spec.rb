require File.dirname(__FILE__) + '/../spec_helper'

describe Ev do

  it "should be valid" do
    Ev.spawn.should be_valid
  end

end


# == Schema Information
#
# Table name: evs
#
#  id         :integer         not null, primary key
#  host_id    :integer
#  user_id    :integer
#  name       :string(255)
#  kind       :string(255)
#  comm       :string(255)
#  result     :text
#  sudo       :boolean
#  count      :integer
#  time_taken :integer
#  created_at :datetime
#  updated_at :datetime
#

