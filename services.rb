require "FileUtils"

module Services
  def Services.make_the_change(filename, on_state, off_state, on_or_off)
    File.open("#{filename}.tmp", "w+") do |saved|
      File.foreach("#{filename}") do |line|  
        if on_or_off == :off
          line = line.gsub(/^#{on_state}/, off_state)
        end
        if on_or_off == :on
          line = line.gsub(/^#{off_state}/, on_state)
        end
        saved.puts(line)
      end
    end
    FileUtils.mv("#{filename}", "#{filename}.orig")
    FileUtils.mv("#{filename}.tmp", "#{filename}")
  end
 
  def Services.subversion(on_or_off)
    puts "toggling subversion proxies - #{on_or_off}"
    servers_file = "#{Dir.home}/.subversion/servers"
    on_state_host = "http-proxy-host"
    on_state_port = "http-proxy-port"
    Services.make_the_change(servers_file, on_state_host, "# #{on_state_host}", on_or_off)
    Services.make_the_change(servers_file, on_state_port, "# #{on_state_port}", on_or_off)
  end
  
  def Services.bash(on_or_off)
    puts "toggling bash profile - #{on_or_off}"
    bash_profile = "#{Dir.home}/.bash_profile"
    proxy_on = 'PROXY_SET="on"'
    proxy_off = 'PROXY_SET="off"'
    Services.make_the_change(bash_profile, proxy_on, proxy_off, on_or_off)
    puts 'run "source ~/.bash_profile" to update environment settings'
  end
  def Services.git(on_or_off)
  end
  def Services.stunnel(on_or_off)
  end
  def Services.location(on_or_off)
  end
  
  
  
  def Services.toggle_all(on_or_off)
    Services.bash(on_or_off)
    Services.subversion(on_or_off)
    Services.git(on_or_off)
    Services.stunnel(on_or_off)
    Services.location(on_or_off)
  end
end