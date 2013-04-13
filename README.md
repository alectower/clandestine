# Clandestine

Clandestine allows you to store passwords in a local file using AES-CBC-256 encryption.

## Requirements

Ruby

Currently only supported on OSX

## Installation

Clandestine can be installed using RubyGems:

    $ gem install clandestine

## Usage

    user$ clandestine

    Options:           
        -a <key>      ::   add password related to <key>
        -g <key>      ::   get password related to <key>
        -g            ::   get all keys
        -d <key>      ::   delete password related to <key>
        -d            ::   delete all passwords
        -l            ::   print current location of safe
        -l <path>     ::   move safe location to <path>
        -c            ::   change password to safe
        -r            ::   remove safe completely
        
        Passwords will be copied to the clipboard for 10 seconds