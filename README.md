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

The hyperloaded `survey_response/read` api is really just that. This gem does the best job it can to stay out of the way but provides some sane defaults to get survey responses to play with from the least amount of effort.  In particular, the parameters `column_list`, `output_format` and `user_list` all have defaults to provide the most useful (and most complete response) from the server. Please feel free to pass these parameters though if you know you want something different. An extremely simple example to get an array of all responses your current user has access to in the campaign `urn:campaign:sample`:

```ruby
responses = oh.survey_response_read(campaign_urn: 'urn:campaign:sample')
p responses # outputs the entire array of Ohmage::SurveyResponse objects
```

A few APIs can/must use files on the disk for uploading (`document/create`, `survey/upload` if sending multimedia). Passing the filename as the expected parameter will result in the expected behavior:

```ruby
oh.document_create(document: '/path/to/file/sample.docx', privacy_state: 'shared', document_class_role_list: 'urn:class:public;reader')
```
will create a document on the server with the `sample.docx` file as the content.

The `survey_upload` method requires a distinct parameter setup (make sure to take a look at the [server api](https://github.com/ohmage/server/wiki/Survey-Manipulation#surveyUpload) for details). Here's a simple example of how this method would work with an image. Note that it shells out to the `file` command to return a useful mime-type (required by ohmage).

```ruby
oh.survey_upload(campaign_creation_timestamp: '2015-05-13 08:53:00',
                 campaign_urn: 'urn:campaign:mobilize:steve:phototest',
                 surveys: [{survey_key: 'b08c05b2-67d0-4962-8c82-913edd534504',
                           location_status: 'unavailable',
                           time: 1434046871000,
                           timezone: 'America/Los_Angeles',
                           survey_id: 'test',
                           survey_launch_context: {
                             launch_time: 1434046871000,
                             launch_timezone: 'America/Los_Angeles',
                             active_triggers: []
                           },
                           responses: [
                             {prompt_id: 'photo',
                              value: 'a3d25bdd-8d4b-4db6-96f6-d26dcc9aeac3'}
                           ]}].to_json,
                 'a3d25bdd-8d4b-4db6-96f6-d26dcc9aeac3':'/path/to/image.png'
                 )
```

About object types! Calls that are able to return entities will return new instances of top-level objects: `Ohmage::User`, `Ohmage::Campaign`, `Ohmage::Clazz` (note the zz) and `Ohmage::Document`. Calls involving deletes (`user_delete`, `campaign_delete`) and `user_password` return `nil` if successful.

A list of the APIs which are currently implemented, and their internal method name:

| method                 | maps to                |
|------------------------|------------------------|
| user_create            | user/create            |
| user_update            | user/update            |
| user_password          | user/change_password   |
| user_read              | user/read              |
| user_info_read         | user_info/read         |
| user_delete            | user/delete            |
| class_read             | class/read             |
| class_create           | class/create           |
| class_update           | class/update           |
| class_delete           | class/delete           |
| class_search           | class/search           |
| campaign_read          | campaign/read          |
| campaign_create        | campaign/create        |
| campaign_update        | campaign/update        |
| campaign_delete        | campaign/delete        |
| survey_response_read   | survey_response/read   |
| survey_response_update | survey_response/update |
| survey_response_delete | survey_response/delete |
| survey_upload          | survey/upload          |
| server_config_read     | config/read            |
| auth_token, auth       | user/auth_token        |
| document_read          | document/read          |
| document_create        | document/create        |
| document_update        | document/update        |
| document_delete        | document/delete        |
| media_read             | media/read, etc*       |
| image_read*            | image/read             |
| audio_read*            | media/read             |
| video_read*            | media/read             |

* While media/read becomes support in server 2.17, this wrapper has mapped all methods to work regardless of the server version. Prefer the
`media_read` method for all media calls, regardless of type.


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
ohmage update password testuser --password "testpassword" # updates user's password. this is a different API in ohmage from user/update
```

## Copyright
Copyright (c) 2015 Steve Nolen
See [LICENSE][] for details.

[license]: LICENSE.txt

