require File.dirname(__FILE__) + '/../spec_helper'

describe Host do

  it "should be valid" do
    Host.spawn.should be_valid
  end



end


# == Schema Information
#
# Table name: hosts
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  addr       :string(255)
#  path       :string(255)
#  user       :string(255)
#  pass       :string(255)
#  state      :string(255)
#  kind       :string(255)
#  port       :integer
#  timeout    :integer
#  ping       :integer
#  mem        :integer
#  cpu        :integer
#  limit_mem  :integer
#  limit_cpu  :integer
#  cores      :integer
#  info       :text
#  proks      :text
#  active     :boolean
#  god        :boolean
#  sudo       :boolean
#  created_at :datetime
#  updated_at :datetime
#

