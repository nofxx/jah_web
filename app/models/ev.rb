class Ev < ActiveRecord::Base
  belongs_to :host
  belongs_to :user
  named_scope :history, :limit => 100 , :order => "created_at DESC"

  def before_create
    kind ||= "out"
    if kind == "out"
      @t = Time.now
      self[:result] = SSHWorker.new(host, host.user, comm).
        buffer.gsub(/\n/, "<br/>").gsub(/<\w\s/, "   ")
      self[:time_taken] = Time.now - @t
    end
  end

  def self.search(search,page)
    paginate :page => page, :order => "created_at DESC"
  end

  def name
    self[:name] && self[:name] != "" ? self[:name] : comm
  end

  def res
    result[0..50]
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

