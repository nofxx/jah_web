require "digest/sha1"
require 'ipaddr'

#require 'app/lib/sample' # avoids class cache

class Host < ActiveRecord::Base
  NO_NAME = "No name"
  has_and_belongs_to_many :groups #, :counter_cache => true
  has_many :stats
  has_many :evs

  validates_inclusion_of :timeout, :in => 2..300, :allow_blank => true
  validates_inclusion_of :port, :in => 1..65535, :allow_blank => true
  validates_numericality_of :port, :timeout, :only_integer => true, :allow_nil => true

  named_scope :active, :conditions => { :active => true }
  named_scope :ordered, :order => "active DESC, name, addr"
  #validates_format_of :ip, :with => /^\S*$/, :allow_blank => true
  #  :with => /^[\d]{1,3}\.[\d]{1,3}\.[\d]{1,3}\.[\d]{1,3}|^[\w]{1,4}[:]{1,4}[\w]{1,4}/,
  #  :allow_blank => true

  state_machine :state, :initial => :active do
    event :activate do
      transition :from => :inactive, :to => :active
    end
    event :desactivate do
      transition :from => [:active, :err], :to => :inactive
    end
    event :stop do
      transition :from => :active, :to => :err
    end
    event :start do
      transition :from => :err, :to => :active
    end
  end

  def <=>(host)
    [addr, port, user] <=> [host.addr, host.port, host.user]
  end

  def to_s
     @to_s ||= begin
       s = addr
       s = "#{user}@#{s}" if user
       s = "#{s}:#{port}" if port && port != 22
       s
    end
  end

  def last_stat
    stats.ordered.first
  end

  def last_ones
    @last_ones ||= stats.ordered.last_ones
  end

  def graph_for(w, s = false, c = 30)
    (1..c).to_a.map do |i|
      calc = last_ones[i] ? last_ones[i].send(w) : 0
      s ?  calc : [i, calc]
    end
  end

  def do_check
    SSHWorker.new(self, user)
  end

  def wipe
    stats.each(&:destroy)
  end

  def name
    self[:name] && self[:name] != "" ? self[:name] : NO_NAME
  end

  def switch_watch!
    update_attribute(:active, active ? false : true)
  end


  def keys
    User.first.keys.map(&:value)
  end

  def before_create
    self[:active] = true
    self[:command] = true
    self[:key] = Host.keygen
  end

  def find_prok(pid)
    last_stat.proks.select { |p| p.pid == pid.to_i }[0]
  end

  # def valid_ip
  #   IPAddr.new( ip )#.mask(_self.mask)
  # end

  def self.keygen(length = 30)
    Digest::SHA1.hexdigest(Time.now.to_s + rand(12341234).to_s)[1..length]
  end

  #   def ping!
  #   return if state == "inativo"
  #   write_attribute(:ping, Ping.pingecho( source , timeout , porta ))
  #   ping ? voltou('ping') : problema('ping')
  # end

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

