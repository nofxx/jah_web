require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Stat do
  before(:each) do
    @valid_attributes = {
      :proc => 1,
      :mem => 1,
      :value => "value for value"
    }
  end

  it "should create a new instance given valid attributes" do
    Stat.create!(@valid_attributes)
  end
end

# == Schema Information
#
# Table name: stats
#
#  id         :integer         not null, primary key
#  host_id    :integer
#  cpu        :integer
#  mem        :integer
#  temp       :integer
#  value      :string(255)
#  net        :string(255)
#  cpus       :string(255)
#  disks      :string(255)
#  temps      :string(255)
#  proks      :text
#  created_at :datetime
#  updated_at :datetime
#

