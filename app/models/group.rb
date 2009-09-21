class Group < ActiveRecord::Base
  has_and_belongs_to_many :hosts

  validates_presence_of :name

    # STATE MACHINE
  state_machine :state, :initial => :active do
    event :ativate do
      transition :from => :inactive, :to => :active
    end

    event :deactivate do
      transition :from => :active, :to => :inactive
    end
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

