require "FileUtils"

module Services
  def Services.make_the_change(filename, on_state, off_state, on_or_off)
    File.open("#{filename}.tmp", "w+") do |saved|
      File.foreach("#{filename}") do |line|  
        if on_or_off == :off
          line = line.gsub(/^([ \t]*)*#{on_state}/, off_state)
        end
        if on_or_off == :on
          line = line.gsub(/^([ \t]*)#{off_state}/, on_state)
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
    puts "toggling gitconfig settings - #{on_or_off}"
    gitconfig = "#{Dir.home}/.gitconfig"
    proxy_set = "proxy"
    Services.make_the_change(gitconfig, proxy_set, "# #{proxy_set}", on_or_off)
  end
  def Services.curl(on_or_off)
    puts "toggling curl settings - #{on_or_off}"
    curlrc = "#{Dir.home}/.curlrc"
    proxy_set = "--proxy"
    Services.make_the_change(curlrc, proxy_set, "# #{proxy_set}", on_or_off) 
  end
  def Services.stunnel(on_or_off)
    puts "toggling stunnel settings - #{on_or_off}"
    `killall stunnel`
    stunnel_conf = "/usr/local/etc/stunnel/stunnel.conf"
    line_one_off = "sslVersion = SSLv3"
    line_two_off = "connect"
    line_one_on = "sslVersion = TLSv1"
    line_two_on = "exec"
    line_three_on = "execargs"
    Services.make_the_change(stunnel_conf, "; #{line_one_off}", line_one_off, on_or_off)
    Services.make_the_change(stunnel_conf, "; #{line_two_off}", line_two_off, on_or_off)
    Services.make_the_change(stunnel_conf, line_one_on, "; #{line_one_on}", on_or_off)
    Services.make_the_change(stunnel_conf, line_two_on, "; #{line_two_on}", on_or_off)
    Services.make_the_change(stunnel_conf, line_three_on, "; #{line_three_on}", on_or_off)
    `stunnel`
  end
  def Services.location(on_or_off)
    if on_or_off == :on then
      `scselect 'BBC On Network'`
    else
      `scselect 'BBC Off Network'`
    end
  end
  
  
  
  def Services.toggle_all(on_or_off)
    Services.bash(on_or_off)
    Services.subversion(on_or_off)
    Services.git(on_or_off)
    Services.curl(on_or_off)
    Services.stunnel(on_or_off)
    Services.location(on_or_off)
  end
end
