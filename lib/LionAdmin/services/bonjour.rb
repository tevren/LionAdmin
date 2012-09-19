require 'plist'
module LionAdmin
	class Bonjour < Service
		def getBonjourInstanceNames
			cmd = "#{service_name}:command = getBonjourInstanceNames\n#{service_name}:serviceType = _afpovertcp._tcp"
			tmp_command_file = "/tmp/#{service_name}.command.#{Time.current.to_formatted_s(:number)}"
			File.open(tmp_command_file, 'w') {|f| 
				f.write(cmd)
				f.close
			}
			plist = %x[#{@user_prefix} sudo #{@serveradmin} -x command < #{tmp_command_file}]
			getBonjourInstanceNames = Plist::parse_xml(plist)
			File.delete(tmp_command_file)
			return getBonjourInstanceNames
		end
	end
end