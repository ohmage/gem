ohmage gem
====

[![Build Status](https://travis-ci.org/ohmage/gem.svg)](https://travis-ci.org/ohmage/gem)

Description
-----------
The ohmage ruby gem is a lightweight API wrapper interacting with an ohmage 2.x server.  While this gem is still in early development, it can be found to be extremely helpful for scripting everyday tasks (and does it's best to stay out of the way, allowing the ohmage server to dictate failed interactions).  While the inclusion in a ruby script is a great way to do lots of tasks, this gem also comes with a stripped down CLI for use.


Installation
------------
`gem install ohmage`


Gem Documentation
-----------------
Getting started is quite easy, just go ahead and instantiate a new client for interaction (note full http url)

```ruby
oh = Ohmage::Client.new(user: 'testuser', password: 'testpassword', server_url: 'https://test.mobilizingcs.org/')
```

You can also pass a block for configuration:

```ruby
oh = Ohmage::Client.new do |conf|
  conf.user = 'testuser'
  conf.password = 'testpassword'
  conf.server_url = 'https://test.mobilizingcs.org/'
  # defaults here, but offering in case you need something else!
  conf.path = 'app/'
  conf.client_string = 'ruby-ohmage'
  conf.port = 443
end
```

From there you can just start making calls! Take a look at the (ohmage 2.x API specs)[https://github.com/ohmage/server/wiki/APIs-for-2.x-Top-Level-Entities] to see what params are needed for which calls.  Here's a sample call using the client defined above:

```ruby
oh.user_create(username: 'newuser', password: 'newpassword', admin: false, enabled: true, new_account: true)
```

About object types! Calls that are able to return entities will return new instances of top-level objects: `Ohmage::User`, `Ohmage::Campaign`, `Ohmage::Clazz` (note the zz) and `Ohmage::Document`. Calls involving deletes (`user_delete`, `campaign_delete`) and `user_password` return `nil` if successful.

A list of the APIs which are currently implemented, and their internal method name:

| method             | maps to              |
|--------------------|----------------------|
| user_create        | user/create          |
| user_update        | user/update          |
| user_password      | user/change_password |
| user_read          | user/read            |
| user_info_read     | user_info/read       |
| user_delete        | user/delete          |
| class_read         | class/read           |
| class_create       | class/create         |
| class_delete       | class/delete         |
| campaign_read      | campaign/read        |
| campaign_delete    | campaign/delete      |
| server_config_read | config/read          |
| auth_token, auth   | user/auth_token      |
| document_read      | document/read        |


CLI Documentation
-----------------
Getting started with the CLI is a piece of cake.  In the current implementation, you need to set 3 environment variables for access. Let's get that out of the way:

```bash
export OHMAGE_SERVER_URL = 'https://test.mobilizingcs.org/'
export OHMAGE_USER = 'testuser'
export OHMAGE_PASSWORD = 'testpass'
```

Now you can make api calls via some really nice shorthands. the basic layout of the CLI is:
`ohmage <action> <entity> <entity_options>`

A few examples:

```bash
ohmage ls class # returns list of class urns the current user can view
ohmage ls class -t # returns a table of classes and info the current user can view
ohmage create user testuser --password "testpassword" # creates a new user with defaults (enabled, new_account set, not admin)
ohmage update user testuser --no-admin --new # sets admin to false and new_account to true for testuser
```

## Copyright
Copyright (c) 2015 Steve Nolen
See [LICENSE][] for details.

[license]: LICENSE.txt

