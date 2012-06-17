PiratesFr.org
===========

PiratesFr.org is a french web site speaking of Linux and Free Software.

This git repository is the rails application that run on PiratesFr.org.

It's been forked from the LinuxFr.org rails application

Install
-------

The following instructions will help you to install the Rails part of
PiratesFr.org on a Debian box.

1) First install some Debian packages:

    # aptitude install mysql-server mysql-client libmysql++-dev
    # aptitude install build-essential openssl libreadline6 libreadline6-dev
    # aptitude install curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev
    # aptitude install libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev bison
    # aptitude install libxslt-dev autoconf libc6-dev ncurses-dev automake libtool
    # aptitude install imagemagick hunspell hunspell-fr  subversion
    # aptitude install openjdk-6-jdk libhunspell-dev

2) Configure the database: 

    # mysql -p -u root
    <enter your root password for mysql>
    > CREATE DATABASE piratesfr_rails;
    > GRANT ALL PRIVILEGES ON piratesfr_rails.* TO "piratesfr_rails"@"localhost";
    > CREATE DATABASE piratesfr_test;
    > GRANT ALL PRIVILEGES ON piratesfr_test.* TO "piratesfr_test"@"localhost";
    > flush privileges;
    > DROP DATABASE piratesfr_rails;
    > DROP DATABASE piratesfr_test;
    > use mysql
    > update user set password=PASSWORD("NEW-PASSWORD-HERE") where User='piratesfr_rails"@"localhost';
    > update user set password=PASSWORD("NEW-PASSWORD-HERE") where User='piratesfr_test"@"localhost';
    > commit;
    > QUIT;
    (return to user)

    Statistics need time zone at SQL level. You'll need to population time_zone* tables.
    # mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -p -u root mysql

3) Install and start redis:

    $ wget "http://redis.googlecode.com/files/redis-2.4.2.tar.gz"
    $ tar xzf redis-2.4.2.tar.gz
    $ cd redis-2.4.2
    $ make
    (optional, takes about ten minutes, $ make test )
    $ src/redis-server redis.conf

4) Install RVM (more details on https://rvm.beginrescueend.com/rvm/install/ ):

    $ bash < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)

   And follow the instructions.

5) Install Ruby with RVM:

    $ rvm install 1.9.3
    $ rvm use --default 1.9.3

6) Clone the repository, configure and install gems:

    $ git clone git://github.com/nka11/piratesfr.org.git
    $ cd piratesfr.org
    $ cp config/database.yml{.sample,}
    $ cp config/secret.yml{.sample,}
    $ gem install bundler rake
    $ bundle install
    $ rake db:setup
    (if you're updating, you'll need an other step: redis-cli flushdb)

7) Let's run it:
bundle exec springboard -c config/elasticsearch
    $ bundle exec springboard -c config/elasticsearch
    $ bundle exec rails server thin
    $ x-www-browser http://127.0.0.1:3000/

8) Create an admin account:

* Create an account
* Get confirmation link in the console and confirm the account
* Get password in the console
* Give admin role to this account with
  `mysql piratesfr_rails`
  `mysql> UPDATE accounts SET role='admin' WHERE login='xxxxxx';`
* Reload the page on the site, you should be admin.


See also
--------

If you want the full stack for running PiratesFr.org, you should also look at:

* [The admin files](https://github.com/nka11/admin-piratesfr.org)

-- in progress (not forked yet)
* [The board daemon](https://github.com/nka11/board-sse-piratesfr.org)
* [The share daemon](https://github.com/nka11/share-PiratesFr.org)


How to run the specs
--------------------

1) Be sure that redis is running and create the test database:

    $ rake db:test:prepare

2) Run [spork](https://github.com/timcharper/spork) in background:

    $ spork &

3) And now, just run rspec (and repeat this step until done):

    $ rspec spec


Copyheart
---------

The code is licensed as GNU AGPLv3. See the LICENSE file for the full license.

The [default avatar](http://piratesfr.org/images/default-avatar.png) is a modified
[Tux](http://en.wikipedia.org/wiki/Tux).

[Iconic icons](http://somerandomdude.com/projects/iconic/) are licenced
[CC by-sa 3.0](http://creativecommons.org/licenses/by-sa/3.0/us/).

♡2011 by Bruno Michel. Copying is an act of love. Please copy and share.
♡2012 by Nka11 & PolNetz for PirateFr adaptation. Copying is an act of love. Please copy and share.
