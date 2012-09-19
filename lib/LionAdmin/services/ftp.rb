require 'plist'
module LionAdmin
	class Ftp < Service

		def getConnectedUsers
			cmd = "#{service_name}:command = getConnectedUsers"
			tmp_command_file = "/tmp/#{service_name}.command.#{Time.current.to_formatted_s(:number)}"
			File.open(tmp_command_file, 'w') {|f| 
				f.write(cmd)
				f.close
			}
			plist = %x[#{@user_prefix} sudo #{@serveradmin} -x command < #{tmp_command_file}]
			getConnectedUsers = Plist::parse_xml(plist)
			File.delete(tmp_command_file)
			return getConnectedUsers
		end
		
		def getLogPaths
			cmd = "#{service_name}:command = getLogPaths"
			tmp_command_file = "/tmp/#{service_name}.command.#{Time.current.to_formatted_s(:number)}"
			File.open(tmp_command_file, 'w') {|f| 
				f.write(cmd)
				f.close
			}
			plist = %x[#{@user_prefix} sudo #{@serveradmin} -x command < #{tmp_command_file}]
			getLogPaths = Plist::parse_xml(plist)
			File.delete(tmp_command_file)
			return getLogPaths
		end

		def tailFile(params={:id => "",:path => "",:offset => 0,:amount => 10000},options={})
			if params[:id].blank?
				cmd = "#{service_name}:command = tailFile\n#{service_name}:path = #{params[:path]}\n#{service_name}:offset = #{params[:offset]}\n#{service_name}:amount = #{params[:amount]}"
			else
				cmd = "#{service_name}:command = tailFile\n#{service_name}:identifier = #{params[:id]}\n#{service_name}:offset = #{params[:offset]}\n#{service_name}:amount = #{params[:amount]}"
			end
			tmp_command_file = "/tmp/#{service_name}.command.#{Time.current.to_formatted_s(:number)}"
			File.open(tmp_command_file, 'w') {|f| 
				f.write(cmd)
				f.close
			}
			plist = %x[#{@user_prefix} sudo #{@serveradmin} -x command < #{tmp_command_file}]
			tailFile = Plist::parse_xml(plist)
			File.delete(tmp_command_file)
			return tailFile
		end
		
		def intialSetup(dataLocation)
			cmd = "#{service_name}:command = intialSetup\n#{service_name}:dataLocation = #{dataLocation}"
			tmp_command_file = "/tmp/#{service_name}.command.#{Time.current.to_formatted_s(:number)}"
			File.open(tmp_command_file, 'w') {|f| 
				f.write(cmd)
				f.close
			}
			plist = %x[#{@user_prefix} sudo #{@serveradmin} -x command < #{tmp_command_file}]
			intialSetup = Plist::parse_xml(plist)
			File.delete(tmp_command_file)
			return intialSetup
		end
	end
end