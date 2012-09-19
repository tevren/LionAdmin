require 'plist'
module LionAdmin
	class Config < Service
		def getSystemProfile
			cmd = "#{service_name}:command = getSystemProfile"
			tmp_command_file = "/tmp/#{service_name}.command.#{Time.current.to_formatted_s(:number)}"
			File.open(tmp_command_file, 'w') {|f| 
				f.write(cmd)
				f.close
			}
			plist = %x[#{@user_prefix} sudo #{@serveradmin} -x command < #{tmp_command_file}]
			getSystemProfile = Plist::parse_xml(plist)
			File.delete(tmp_command_file)
			return getSystemProfile
		end
		def setXsanControllerProperties
		end
		def setUpServer
		end
	end
end