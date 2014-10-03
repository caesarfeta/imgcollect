# Install
## If you're using Amazon AWS
### Setup AWS instance
	https://www.amazon.com/ap/signin?openid.assoc_handle=aws&openid.return_to=https%3A%2F%2Fsignin.aws.amazon.com%2Foauth%3Fresponse_type%3Dcode%26client_id%3Darn%253Aaws%253Aiam%253A%253A015428540659%253Auser%252Fhomepage%26redirect_uri%3Dhttps%253A%252F%252Fconsole.aws.amazon.com%252Fconsole%252Fhome%253Fstate%253DhashArgs%252523%2526isauthcode%253Dtrue%26noAuthCookie%3Dtrue&openid.mode=checkid_setup&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&action=&disableCorpSignUp=&clientContext=&marketPlaceId=&poolName=326712126324&authCookies=&pageId=aws.iam&siteState=&accountStatusPolicy=P1&sso=&openid.pape.preferred_auth_policies=MultifactorPhysical&openid.pape.max_auth_age=120&openid.ns.pape=http%3A%2F%2Fspecs.openid.net%2Fextensions%2Fpape%2F1.0&server=%2Fap%2Fsignin%3Fie%3DUTF8&accountPoolAlias=326712126324&forceMobileApp=0
	EC2

	Launch Instance
		Ubuntu Server 14.04 LTS (PV) 
			64-bit
			Select

	Step 2: Choose an Instance Type
		m1.small
		6. Configure Security Group
			Select an existing security group
				sosolrails
				Review and Launch

## Install system dependencies
	sudo apt-get update
	sudo apt-get install build-essential
	sudo apt-get install unzip
	sudo apt-get install zlib1g-dev
	sudo apt-get install git
	sudo apt-get install openjdk-6-jre

## Setup shell -- optional
	mkdir ~/lib
	git clone http://github.com/caesarfeta/bash_lib ~/lib/bash_lib
	echo 'source ~/lib/bash_lib/profile' >> ~/.profile
	source ~/.profile

## Install rbenv -- optional
	git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
	echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
	echo 'eval "$(rbenv init -)"' >> ~/.bashrc
	source ~/.profile

## Install ruby-build -- optional
	git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

## Install jruby-1.7.11 -- optional
	rbenv install jruby-1.7.11
	rbenv global jruby-1.7.11
	rbenv rehash

## Install rails and bundler
	sudo apt-get install ruby-railties-3.2
	sudo apt-get install bundler
	gem install rails -v 3.2.3

## Install imagemagick
	sudo apt-get install imagemagick --fix-missing

## Install sparql_model gem
	cd /var/www
	git clone https://github.com/caesarfeta/sparql_model.git
	cd sparql_model
	gem build sparql_model.gemspec
	gem install sparql_model-0.0.0.gem

## Install imgcollect
	sudo chown ubuntu /var/www
	git clone https://github.com/caesarfeta/imgcollect.git /var/www/imgcollect
	cd /var/www/imgcollect/rails3
	bundle install

## Install jena-fuseki
	cd /var/www/imgcollect
	rake install:fuseki


## Install redis
	sudo apt-add-repository ppa:chris-lea/redis-server
	sudo apt-get update
	sudo apt-get install redis-server

## Configuration
Edit the following files for any custom environment configuration

### fuseki
	Rakefile

### rails
	rails3/config/application.rb
	rails3/config/environments/development.rb
	rails3/config/environments/production.rb

### redis
	rails3/config/redis.conf

### sidekiq
	rails3/config/sidekiq.yml

## Start it up!
The easiest way is to just use...

	rake start:all

or the individual component servers...

	rake start:rails
	rake start:fuseki
	rake start:sidekiq

if you need a console...

	rails console development

## Securing fuseki
The easiest way I know to basically secure Fuseki is to use an Apache proxy.
If anyone knows a better way of doing this let me know.

This goes in **/etc/apache2/httpd.conf**

	LoadModule proxy_http_module /usr/lib/apache2/modules/mod_proxy_http.so
	ProxyRequests Off
	<Proxy *>
	  Order deny,allow
	  Allow from all
	</Proxy>
	
	<Location /fuseki>
		ProxyPass http://localhost:8080
		ProxyPassReverse http://localhost:8080
	</Location>
	
	<LocationMatch /fuseki/[^/]+/update>
		Order deny,allow
		Deny from all
		Allow from 127.0.0.0
	</LocationMatch>

Then use iptables to drop all packets sent to :8080 from anywhere but localhost.

	sudo iptables -A INPUT -p tcp -s localhost --dport 8080 -j ACCEPT
	sudo iptables -A INPUT -p tcp --dport 8080 -j DROP

To undo this...

	sudo iptables -D INPUT -p tcp -s localhost --dport 8080 -j ACCEPT
	sudo iptables -D INPUT -p tcp --dport 8080 -j DROP

## Deploying in apache with Phusion Passenger
	gem install passenger
	passenger-install-apache2-module

This server could be running on a system with other servers using a different version of ruby, so you might be using 

If you're using **rbenv** instead of **rvm** you might get an error message like this one...

	passenger-install-apache2-module: command not found

Here's what you do to fix it...

	rbenv version
		2.1.2 (set by /Users/username/.rbenv/version)
	cd /Users/username/.rbenv/versions/2.1.2/bin/
	./passenger-install-apache2-module

If **passenger-install-apache2-module** opens follow the prompts.

At the end of the install, you'll be given a **passenger_module** configuration snippet.

	LoadModule passenger_module /Users/username/.rbenv/versions/2.1.2/lib/ruby/gems/2.1.0/gems/passenger-4.0.50/buildout/apache2/mod_passenger.so
	<IfModule mod_passenger.c>
	  PassengerRoot /Users/username/.rbenv/versions/2.1.2/lib/ruby/gems/2.1.0/gems/passenger-4.0.50
	  PassengerDefaultRuby /Users/username/.rbenv/versions/2.1.2/bin/ruby
	</IfModule>

Add it to your Apache configuration file, most likely in **/etc/apache2/httpd.conf**.

Create a Virtual Host configuration.  If you're using a non-standard port number make sure you add a Listen config.
Replace **/var/www/imgcollect** with your path to imgcollect

	Listen 80
	<VirtualHost *:80>
		PassengerEnabled On
		DocumentRoot /var/www/imgcollect/rails3/public
		RailsBaseURI /var/www/imgcollect/rails3
		RailsEnv production
	   <Directory /var/www/imgcollect/rails3/public >
		    Allow from all
		    Options -MultiViews
		</Directory>
	</VirtualHost>

### Setup proxy
If you can't run imgcollect off port 80 at the root of the webserver you'll need to setup a proxy.
Here's an example apache proxy config.

	Listen 7890
	<VirtualHost *:7890>
	     PassengerEnabled On
	     DocumentRoot /var/www/tools/imgcollect/rails3/public
	     RailsBaseURI /var/www/tools/imgcollect/rails3
	     RailsEnv production
		<Directory /var/www/tools/imgcollect/rails3/public >
		    Allow from all
		    Options -MultiViews
		</Directory>
	</VirtualHost>
	<Location /imgcollect>
	        ProxyPass http://localhost:7890
		ProxyPassReverse http://localhost:7890
	</Location>


# Troubleshooting
### logs
	rails3/logs

### Test redis 
Ping it.

	redis-cli ping
	> PONG

Make sure you can set a key value pair.

	redis-cli
		set key val
		get key

### Test sidekiq
Check the web interface

	http://127.0.0.1:3000/sidekiq
	http://your.host.org/sidekiq