require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Prok do
  before(:each) do
    @valid_attributes = {
      :pid => 1,
      :user => "value for user",
      :command => "value for command",
      :mem => 1,
      :cpu => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Prok.create!(@valid_attributes)
  end
end
