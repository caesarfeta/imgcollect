# Setup AWS instance
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

# Install system dependencies
	sudo apt-get update
	sudo apt-get install build-essential
	sudo apt-get install unzip
	sudo apt-get install zlib1g-dev
	sudo apt-get install git
	sudo apt-get install openjdk-6-jre

# Setup shell
	mkdir ~/lib
	git clone http://github.com/caesarfeta/bash_lib ~/lib/bash_lib
	echo 'source ~/lib/bash_lib/profile' >> ~/.profile
	source ~/.profile

# Install rbenv
	git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
	echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
	echo 'eval "$(rbenv init -)"' >> ~/.bashrc
	source ~/.profile

# Install ruby-build
	git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

# Install jruby-1.7.11
	rbenv install jruby-1.7.11
	rbenv global jruby-1.7.11
	rbenv rehash

# Install rails
	sudo apt-get install ruby-railties-3.2
	sudo apt-get install bundler
	gem install rails -v 3.2.3

# Install haml
	gem install haml-rails

# Install linked-data/RDF related gems
	gem install linkeddata
	gem install spira
	gem install sparql

# Install rubyzip
	gem install rubyzip

# Install imgcollect
	sudo chown ubuntu /usr/local
	git clone https://github.com/caesarfeta/imgcollect.git /usr/local/imgcollect

# Install jena-fuseki
	cd /usr/local/imgcollect
	curl -O http://www.interior-dsgn.com/apache//jena/binaries/jena-fuseki-1.0.1-distribution.tar.gz
	tar xvzf jena-fuseki-1.0.1-distribution.tar.gz
	ln -s jena-fuseki-1.0.1 fuseki
	chmod +x fuseki/fuseki-server fuseki/s-**

# Start it up!
## Fuseki
	cd /usr/local/imgcollect/fuseki
	./fuseki-server --update --mem --port=8080 /ds &

If you don't want output sent to STDOUT and would rather have it logged to nohup.out

	nohup ./fuseki-server --update --mem --port=8080 /ds &
## Rails
	cd /usr/local/imgcollect/rails3
	bundle install

Start the webserver...

	bundle exec rails server

... or if you're developing and just need a console

	rails console development
