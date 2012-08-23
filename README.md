# LionAdmin

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'LionAdmin'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install LionAdmin


To configure your Lion/Mountain Lion server for passwordless ssh-entry run the following commands on the L/ML server:

	$ ssh-keygen -t rsa

This will prompt you for a location to save the keys, and a pass-phrase:

	Generating public/private rsa key pair.
	Enter file in which to save the key (/.ssh/id_rsa): 
	Enter passphrase (empty for no passphrase): 
	Enter same passphrase again: 
	Your identification has been saved in .ssh/id_rsa
	Your public key has been saved in .ssh/id_rsa.pub

To configure the webserver to login to the L/ML server using the key you just generated, paste the contents of .ssh/id_rsa.pub to .ssh/authorized_keys on your webserver (in the rails user's directory)
Next we want to configure L/ML server to run the serveradmin binary without prompting for a password:
	
	$ sudo su root
	$ chmod 640 /etc/sudoers
	$ emacs /etc/sudoers

Add the following lines to /etc/sudoers

	# run serveradmin without password
	RUBY_USER    ALL=NOPASSWD:  /Applications/Server.app/Contents/ServerRoot/usr/sbin/serveradmin

Where RUBY_USER is the name of the user that is ssh-ing to the server.


## Usage


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

