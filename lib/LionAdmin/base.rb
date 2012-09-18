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

		def host_status(host)
			ping_count = 10
			server = host
			result = %x[ping -q -c #{ping_count} #{server}]
			if ($?.exitstatus == 0)
				return true
			else
				return false
			end
		end

	end
end