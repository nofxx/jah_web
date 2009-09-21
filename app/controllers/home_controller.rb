class HomeController < ApplicationController

  def index

  end
  def status
    hosts = Host.active.all
    hosts.each {  |h| h.do_check }
    res = hosts.map do |h|
      { :id => h.id, :name => h.name, :state => h.state,
        :mem => h.graph_for("mem"),
        :cpu => h.graph_for("cpu"),
        :net => h.graph_for("net")
      }
    end
  #  render :text => "oi"
    render :text => {
        'jobs'            => Host.all,
        'hosts'           => res,
        'work_unit_count' => Host.all
    }.to_json

  end

  def config
    @key = `cat ~/.ssh/id_rsa.pub`
    @key = @key.scan(/(.{0,50})/).join("\n")
  end

  def heartbeat
    return head(:ok)
  end
end
