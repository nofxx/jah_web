class Prok
  BANLIST = [/^ata/, /^init$/, /^scsi_/, /\/\d$/, /agetty/ ]
  attr_reader :pid, :comm, :cpu, :mem, :res, :shr, :virt

  def initialize(host, *args) #pid, user, pr, nice, virt, res, shr, state, cpu, mem, time, command, *extra )
    return unless args[0]
    @host = host
    @pid = args[0].chomp.to_i
    @comm = args[11]
    @cpu = args[8]
    @mem = args[9]
    @virt = args[4]
    @res = args[5]
    @shr = args[6]
  end

  def hup!
    exec "kill -1 #{pid}"
  end

  def kill!
    exec "kill #{pid}"
  end

  def move_to_acre!
    exec "kill -9 #{pid}"
  end

  def self.genocide!(ary, f = nil)
    for prok in ary
      prok.kill
    end
  end

  def exec(comm)
    SSHWorker.new(@host, @host.user, comm)
  end

  def force(f)
    { :hup => "-1", :die => "-9"}[f]
  end
end
