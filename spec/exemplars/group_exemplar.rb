class Group < ActiveRecord::Base
  generator_for :name, :method => :next_group_name
  generator_for :state => 'active'

  def self.next_group_name
    @last ||= "DB"
    @last = @last.succ
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

