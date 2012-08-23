require 'plist'
module LionAdmin
	class Base
		SERVER_ADMIN="/Applications/Server.app/Contents/ServerRoot/usr/sbin/serveradmin"
		def initialize(user)
			@user_prefix = "ssh #{user} sudo"
			exit unless File.exists?(SERVER_ADMIN)
		end

		def version
			version = %x[#{@user_prefix} #{SERVER_ADMIN} -v]
		end
		def services
			services = %x[#{@user_prefix} #{SERVER_ADMIN} list].split("\n")
		end

		def fullstatus(service)
			fullstatus = Plist::parse_xml(%x[#{@user_prefix} #{SERVER_ADMIN} fullstatus -x #{service}])
		end

		def status(service)
			status = Plist::parse_xml(%x[#{@user_prefix} #{SERVER_ADMIN} status -x #{service}])
		end

		def settings(service=nil)
			service = "all" if service.nil?
			settings = Plist::parse_xml(%x[#{@user_prefix} #{SERVER_ADMIN} settings -x #{service}])
		end

		def start_service(service)
			if check_if_running(service)
				return "service is already running..."
			else
				puts "starting service: #{service}..."
				%x[#{@user_prefix} #{SERVER_ADMIN} start #{service}]
				puts "service: #{service} started!"
			end
		end

		def stop_service(service)
			if check_if_running(service)
				puts "stopping service: #{service}..."
				%x[#{@user_prefix} #{SERVER_ADMIN} stop #{service}]
				puts "service: #{service} stopped!"
			else
				return "service is already stopped"
			end
		end

		def run_command(service,command)
			output = Plist::parse_xml(%x[#{@user_prefix} #{SERVER_ADMIN} command #{service}:command = #{command}])
			if output.match("UNEXPECTED_COMMAND")
				return "received unexpected command"
			else
				return output
			end
		end

		def change_settings(service,pref,value)
			output_plist = Plist::parse_xml(%x[#{@user_prefix} #{SERVER_ADMIN} settings #{service}:#{pref} = #{value} -x])
			return output_plist[pref]
		end

		def check_if_running(service)
			status = status(service)
			state = status["state"]
			if state.match(/RUNNING/)
				return true
			else 
				return false
			end
		end
	end
end