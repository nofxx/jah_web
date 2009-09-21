require File.dirname(__FILE__) + '/../spec_helper'

describe SSHWorker do

   it "should connect to a server" do

    server = mock("S", :addr => "localhost", :port => 22, :user => "nofxx", :pass => "rock")
    user = mock("U", :keys => [])
    SSHWorker.new(server, user).buffer.should eql("1")

    end


end

