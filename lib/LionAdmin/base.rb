require 'plist'
module LionAdmin
	class Base

		def initialize(user)
			@user_prefix = "ssh #{user}"
			@os_version = %x[#{@user_prefix} defaults read loginwindow SystemVersionStampAsString]
			if @os_version.match(/10\.7.*|10\.8.*/)
				@serveradmin="/Applications/Server.app/Contents/ServerRoot/usr/sbin/serveradmin"
			else
				@serveradmin="/usr/sbin/serveradmin"
			end
		end

		def version
			version = %x[#{@user_prefix} #{@serveradmin} -v]
		end

		def hostname
			hostname = %x[#{@user_prefix} hostname].chomp
		end

		def serialnumber
			serial = String.new
			system_profiler = %x[#{@user_prefix} system_profiler SPHardwareDataType]
			system_profiler.each_line do |line|
				if line.match("Serial Number") && line.match("system")
					serial = line.split(":").last.chomp.strip
				end
			end
			return serial
		end

		def services
			services = %x[#{@user_prefix} sudo #{@serveradmin} list].split("\n")
		end

		def fullstatus(service)
			fullstatus = Plist::parse_xml(%x[#{@user_prefix} sudo #{@serveradmin} fullstatus -x #{service}])
		end

		def status(service)
			status = Plist::parse_xml(%x[#{@user_prefix} sudo #{@serveradmin} status -x #{service}])
		end

		def settings(service)
			settings = Plist::parse_xml(%x[#{@user_prefix} sudo #{@serveradmin} settings -x #{service}])
		end

		def start_service(service)
			if check_if_running(service)
				return "service is already running..."
			else
				puts "starting service: #{service}..."
				%x[#{@user_prefix} sudo #{@serveradmin} start #{service}]
				puts "service: #{service} started!"
			end
		end

		def stop_service(service)
			if check_if_running(service)
				puts "stopping service: #{service}..."
				%x[#{@user_prefix} sudo #{@serveradmin} stop #{service}]
				puts "service: #{service} stopped!"
			else
				return "service is already stopped"
			end
		end

		def run_command(service,command)
			output = Plist::parse_xml(%x[#{@user_prefix} sudo #{@serveradmin} command #{service}:command = #{command}])
			if output.match("UNEXPECTED_COMMAND")
				return "received unexpected command"
			else
				return output
			end
		end

		def get_running_services
			running_services = Array.new
			list_of_services = services
			list_of_services.each do |s|
				if check_if_running(s)
					running_services.push(s)
				end
			end
			return running_services
		end

		def get_stopped_services
			stopped_services = Array.new
			list_of_services = services
			list_of_services.each do |s|
				unless check_if_running(s)
					stopped_services.push(s)
				end
			end
			return stopped_services
		end

		def change_settings(service,pref,value)
			output_plist = Plist::parse_xml(%x[#{@user_prefix} sudo #{@serveradmin} settings #{service}:#{pref} = #{value} -x])
			return output_plist[pref]
		end

		def check_if_running(service)
			status = status(service) if !service.nil?
			state = status["state"] if !status.nil?
			if !state.nil? && state.match(/RUNNING/)
				return true
			else 
				return false
			end
		end
	end
end