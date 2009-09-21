class Stat < ActiveRecord::Base
  belongs_to :host

  def self.comm(host)
   out = {
    :top => "top -bn 1",
    :disks =>  "df -h",
    :net  =>  "netstat -n | grep -i established | wc -l",
    :uptime => "uptime" # /proc/stat"
#    :mem => "free -mo"
    #    :ps => "ps ax -o user,pid,ppid,command,%mem,%cpu,time"
    #:net2 => "netstat -nat | awk '{print $6}' | sort | uniq -c | sort -n"
    # count by ip netstat -atun | awk '{print $5}' | cut -d: -f1 | sed -e '/^$/d' |sort | uniq -c | sort -n
    # we need to create command recipes =D
  }
    out.merge!(:cores => "cat /proc/cpuinfo | grep 'model name' | wc -l") unless host.cores
    out.merge!(:hostname => "hostname") unless host.name && host.name != Host::NO_NAME
    out
  end
  # def before_save
  #   self.cpu = cpus
  # end

  named_scope :ordered, :order => "created_at DESC"
  named_scope :last_ones, :limit => 31

  def cores
    @cores || self.host.cores || 1
  end

  def before_create
    self[:cpu] = @uptime * 100 / cores if @uptime
    host.update_attribute(:cores, @cores) unless host.cores
    host.update_attribute(:name, @hostname) if @hostname
    host.update_attributes(:mem => mem, :cpu => cpu)
  end


  def proks
    return unless self[:proks]
    self[:proks].map do |prok|
      Prok.new(host, *prok)
    end
  end


  def proc=(res)
  end

  def hostname=(res)
    @hostname = res.chomp
  end

  def cores=(res)
    @cores = if res =~ /(\d+)/
      $1.to_i
    else
      raise "Couldn't use /proc/cpuinfo as expected."
    end
  end


  def uptime=(res)
    @uptime = if res =~ /load average(s*): ([\d.]+)(,*) ([\d.]+)(,*) ([\d.]+)\Z/
       { :one    => $2.to_f,
         :five   => $4.to_f,
         :ten    => $6.to_f }[:one]
    end
  end

  def top=(res)
    info, tasks, cpus, mem, swap, n, n, *rest = *res
    n, total, used, free, buffered = *mem.match(/(\d*)k\D*(\d*)k\D*(\d*)k\D*(\d*)k.*/)
    cached = swap.match(/(\d*)k cached/)[0]
    proks = rest.map do |r|
      r.split(" ")
    end

    # fail... top don't show a good stat....
    #self[:cpu]= 100 - cpus.match(/(\d*)\.\d*%id/)[0].to_i #.gsub(/\..*/, "").to_i
    self[:mem] = (used.to_i - cached.to_i - buffered.to_i) * 100 / total.to_i
    self[:proks] = proks.reject do |p|
      p[0] == nil || Prok::BANLIST.select{ |pl| pl =~ p[11] }[0]
    end
  end

  def disks=(res)
    self[:disks] = res.split("\n").reject { |dl| dl =~ /Size|none/ }.map do |l|
      path, total, used, avail, use = l.split(" ")
    end
  end

  #def mem=
  #      res = res.split(" ")
  #     total, used, free, cached, swap = res[7], res[8], res[9], res[12], res[15]
  #     (used.to_i - cached.to_i) * 100 / total.to_i
  #
  #end

  serialize :proks
  serialize :disks
  serialize :cpus
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

