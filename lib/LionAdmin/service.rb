require 'plist'
module LionAdmin
	class Service < Base

		def service_name
			self.class.name.split("::").last.downcase
		end
		def getState(options={})
			if options[:detail] && options[:details] = true
				cmd = "#{service_name}:command = getState\n#{service_name}:variant = withDetails"
			else
				cmd = "#{service_name}:command = getState"
			end
			tmp_command_file = "/tmp/#{service_name}.command.#{Time.current.to_formatted_s(:number)}"
			File.open(tmp_command_file, 'w') {|f| 
				f.write(cmd)
				f.close
			}
			plist = %x[#{@user_prefix} sudo #{@serveradmin} -x command < #{tmp_command_file}]
			getState = Plist::parse_xml(plist)
			File.delete(tmp_command_file)
			return getState
		end
		
		def setState(state,options={})
			cmd = "#{service_name}:command = setState\n#{service_name}:state = #{state.upcase}"
			tmp_command_file = "/tmp/#{service_name}.command.#{Time.current.to_formatted_s(:number)}"
			File.open(tmp_command_file, 'w') {|f| 
				f.write(cmd)
				f.close
			}
			plist = %x[#{@user_prefix} sudo #{@serveradmin} -x command < #{tmp_command_file}]
			getState = Plist::parse_xml(plist)
			File.delete(tmp_command_file)
			return getState
		end

		def readSettings(options={})
			cmd = "#{service_name}:command = readSettings\n"
			tmp_command_file = "/tmp/#{service_name}.command.#{Time.current.to_formatted_s(:number)}"
			File.open(tmp_command_file, 'w') {|f| 
				f.write(cmd)
				f.close
			}
			plist = %x[#{@user_prefix} sudo #{@serveradmin} -x command < #{tmp_command_file}]
			readSettings = Plist::parse_xml(plist)
			File.delete(tmp_command_file)
			return readSettings
		end

		def writeSettings(config={},options={})
			tmp_config_file = "/tmp/#{service_name}.config.#{Time.current.to_formatted_s(:number)}"
			File.open(tmp_config_file, 'w'){|line|
				config.each_pair do |key,value|
					line.write("#{service_name}:#{key} = #{value}")
				end
			}
			plist = %x[#{@user_prefix} sudo #{@serveradmin} -x settings < #{tmp_config_file}]
			writeSettings = Plist::parse_xml(plist)
			File.delete(tmp_config_file)
			return writeSettings
		end

	end
end