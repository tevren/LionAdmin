require 'plist'
module LionAdmin
	class Filebrowser < Service

		def getDirectoryEntries
		end

		def getIconsForPaths
		end

		def getVolumeList(options={})
			if options[:includeSharePoints] && options[:includeSharePoints] = true
				cmd = "#{service_name}:command = getVolumeList\n#{service_name}:includeSharePoints = YES"
			else
				cmd = "#{service_name}:command = getVolumeList"
			end
			tmp_command_file = "/tmp/#{service_name}.command.#{Time.current.to_formatted_s(:number)}"
			File.open(tmp_command_file, 'w') {|f| 
				f.write(cmd)
				f.close
			}
			plist = %x[#{@user_prefix} sudo #{@serveradmin} -x command < #{tmp_command_file}]
			getVolumeList = Plist::parse_xml(plist)
			File.delete(tmp_command_file)
			return getVolumeList
		end

		def getOpenDirectoryRecords
		end

		def newFolder(path="/")
			cmd = "#{service_name}:command = newFolder\n#{service_name}:path = #{path}"
			tmp_command_file = "/tmp/#{service_name}.command.#{Time.current.to_formatted_s(:number)}"
			File.open(tmp_command_file, 'w') {|f| 
				f.write(cmd)
				f.close
			}
			plist = %x[#{@user_prefix} sudo #{@serveradmin} -x command < #{tmp_command_file}]
			newFolder = Plist::parse_xml(plist)
			File.delete(tmp_command_file)
			return newFolder
		end

		def nfsMount(host,share,nfs_reshare_path="/",createMountRec="NO")
			if !host.nil? && !share.nil? && !nfs_reshare_path.nil?
				cmd = "#{service_name}:command = nfsMount\n#{service_name}:nfsServerHostName = #{host}\n#{service_name}:nfsExportPath = #{share}\n#{service_name}:nfsResharePath = #{nfs_reshare_path}\n#{service_name}:createMountRec = #{createMountRec}"
				tmp_command_file = "/tmp/#{service_name}.command.#{Time.current.to_formatted_s(:number)}"
				File.open(tmp_command_file, 'w') {|f| 
					f.write(cmd)
					f.close
				}
				plist = %x[#{@user_prefix} sudo #{@serveradmin} -x command < #{tmp_command_file}]
				nfsMount = Plist::parse_xml(plist)
				File.delete(tmp_command_file)
				return nfsMount
			end
		end

		def nfsUnMount(nfsResharePath)
			if !nfsResharePath.nil?
				cmd = "#{service_name}:command = nfsUnMount\n#{service_name}:nfsResharePath = #{nfsResharePath}"
				tmp_command_file = "/tmp/#{service_name}.command.#{Time.current.to_formatted_s(:number)}"
				File.open(tmp_command_file, 'w') {|f| 
					f.write(cmd)
					f.close
				}
				plist = %x[#{@user_prefix} sudo #{@serveradmin} -x command < #{tmp_command_file}]
				nfsUnMount = Plist::parse_xml(plist)
				File.delete(tmp_command_file)
				return nfsUnMount
			end
		end

	end
end