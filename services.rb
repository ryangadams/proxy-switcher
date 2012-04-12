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
    Services.make_the_change("#{Dir.home}/.subversion/servers", "http-proxy-host", "# http-proxy-host", on_or_off)
    Services.make_the_change("#{Dir.home}/.subversion/servers", "http-proxy-port", "# http-proxy-port", on_or_off)
    # File.open("#{Dir.home}/.subversion/servers.tmp", "w+") do |saved|
    #       File.foreach("#{Dir.home}/.subversion/servers") do |line|  
    #         if on_or_off == :off
    #           line = line.gsub(/^http-proxy-host/, "# http-proxy-host")
    #           line = line.gsub(/^http-proxy-port/, "# http-proxy-port")
    #         end
    #         if on_or_off == :on
    #           line = line.gsub(/^# http-proxy-host/, "http-proxy-host")
    #           line = line.gsub(/^# http-proxy-port/, "http-proxy-port")
    #         end
    #         saved.puts(line)
    #       end
    #     end
    #     FileUtils.mv("#{Dir.home}/.subversion/servers", "#{Dir.home}/.subversion/servers.orig")
    #     FileUtils.mv("#{Dir.home}/.subversion/servers.tmp", "#{Dir.home}/.subversion/servers")
  end
  
  def Services.bash(on_or_off)
    puts "toggling bash profile - #{on_or_off}"
    
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