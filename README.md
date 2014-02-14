Clandestine
-----------

Clandestine allows you to store passwords in a local file using AES-CBC-256 encryption.

Requirements
------------

Ruby v2.0+

Currently only supported on OSX

Installation
------------

Clandestine can be installed using RubyGems:

    $ gem install clandestine

Usage
-----

    user$ clandestine
    Clandestine v0.1.0
    Usage: clandestine [option] [key]

        -a, --add <key>                  Add password for <key> (Passwords are randomly generated)
        -g, --get [key]                  Get password for [key] (Returns all keys if key isn't given)
        -d, --delete <key>               Delete <key> and related password
        -u, --update [key]               Update password for [key] (Updates password for safe if key isn't given)
        -l, --location                   Print location of safe (Default is ~/.cls if env variable CLANDESTINE_SAFE isn't set)
        -r, --remove                     Remove safe completely
        -v, --version                    Print version number
        -h, --help                       Print these options


Contributing
------------
1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Write specs (bundle exec rspec spec)
4. Commit your changes (git commit -am 'Add some feature')
5. Push to the branch (git push origin my-new-feature)
6. Create new Pull Request
