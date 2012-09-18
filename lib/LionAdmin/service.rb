require 'plist'
module LionAdmin
	class Service < Base
		def services
			services = %x[#{@user_prefix} sudo #{@serveradmin} list].split("\n")
		end

		def getState
		end
		
		def setState
		end

		def readSettings
		end

		def writeSettings
		end

	end
end