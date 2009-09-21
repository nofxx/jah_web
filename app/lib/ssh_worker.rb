require "net/ssh"

class ExecWithStatus
  def initialize(ssh, command)
    @command = command
    @channel = ssh.open_channel(&method(:channel_opened))
    @channel[:out] = ""
  end

  def result
    @channel[:out]
  end

  def status
    @status
  end

  private

  def channel_opened(channel)
    channel.exec(@command)
    channel.on_data(&method(:channel_data))
    channel.on_extended_data(&method(:channel_extended_data))
    channel.on_request("exit-status", &method(:exit_status))
  end

  def channel_data(channel, data)
    channel[:out] << data
  end

  def channel_extended_data(channel, type, data)
    channel[:out] << data
  end

  def exit_status(channel, request)
    @status = request.read_long

    puts "`#{@command}' failed with #{@status}"# unless status == 0
  end
end

class Net::SSH::Connection::Session
  def exec_with_status(command)
    ExecWithStatus.new(self, command)
  end
end



class SSHWorker
  attr_reader :buffer
  # connect and get info, stays on?


  def initialize(host, user, comm = nil)

    ssh_opts = {
         :port => host.port,
         :config => true,
         :keys => "~/.ssh/id_rsa",
         :verbose => :debug,
         :timeout => 20
         #:paranoid => true
    }

    ssh_opts.merge!(:password => host.pass) if host.pass && host.pass != ""
    p ssh_opts
    Net::SSH.start(host.addr, user, ssh_opts) do |ssh|
      #      puts hostname = ssh.exec_with_status("hostname").result
      if comm
        ex = ssh.exec_with_status(comm)
        ssh.loop
        @buffer = ex.result

      else
        @result = { }
        for sample in Stat::comm(host)
          puts "Executing #{sample}"
          @result[sample[0]]   = ssh.exec_with_status(sample[1])
        end

        ssh.loop
        @result.map { |k, v| @result[k] = v.result}
        s = host.stats.create(@result)
      end

      #s.save!
    end
  end
end
  #     puts "Connecting to #{host}"
#     @buffer = ""
#     @channels = []
#     @user = host.user
#     @options = {
#       :port => host.port || 22,
#       :keys => user.keys.first,
#       :password => host.pass,
#       :verbose => :debug
#     }
#     connect
#     do_get("uptime")
#     @session.loop
#     @session.close
#   end

#   def connect
#     if @options[:password]
#       @options[:auth_methods] = [ "password","keyboard-interactive" ]
#     end

#     @session = Net::SSH.start(@host, @user, @options)
#     puts "Connected!"
#   rescue SocketError, Errno::ECONNREFUSED => e
#     puts "!!! Could not connect to #{@host}. Check to make sure that this is the correct url."
#     # puts $! if $DBG > 0
#     exit
#   rescue Net::SSH::AuthenticationFailed => e
#     puts "!!! Could not authenticate on #{@host}. Make sure you have set the username and password correctly. Or if you are using SSH keys make sure you have not set a password."
#     # puts $! if $DBG > 0
#     exit
#   end

#   def do_get(comm)
#     puts "Trying #{comm}"

#     @ch = @session.open_channel do |c|
#       puts "Opening channel..#{@session.host}"

#       #c.request_pty :want_reply => true

#       c.on_data do |ch, data|
#         @buffer << data
#         parse_line(data)
#       end

#       #ch.exec comm

#       c.do_success do |ch|
#         c.exec "#{comm}"#  #{file} "
#       end

#       c.do_failure do |ch|
#         ch.close
#       end

#       c.on_extended_data do |ch, data|
#         puts "STDERR: #{data}\n"
#       end

#       c.do_close do |ch|
#         ch[:closed] = true
#       end

#       puts "Pushing #{@session}\n"# if($VRB > 0 || $DBG > 0)
#       @channels.push(c)
#     end

#   end


# end
