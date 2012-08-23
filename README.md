# DeReNo - Deployments Release Notes

Show release notes (Git commits / Pivotal Tracker stories) before deployments.

Notify deployments release notes via email (and optionnal Campfire notification).

## Installation

In your Gemfile :

```rb
gem 'dereno'
```

and then `bundle install`

## Usage

In your deploy.rb or equivalent :

```rb
require 'dereno'

role :dereno , 'my_host'
set :dereno_options, {
  to: 'team@foo.bar',
  from: 'deployment@foo.bar',

  # optional Pivotal Tracker credentials
  pivotal_tracker: {
    token: 'my_token',
    project_id: 123456
  },

  # optional Campfire credentials
  campfire: {
    subdomain: 'my_domain',
    token: 'my_token',
    room: 'my_room'
  }
}

after 'deploy:restart', 'release_notes:notify'
```

and then after each deployments your team will be notify about what's new in production.

## Tasks

Show release notes between local current branch and latest deployed release. 
```rb
bundle exec cap production release_notes:show
```

Deployment release notes (between current and previous deployed releases) notification via email (optionnal Campfire notification).
```rb
bundle exec cap production release_notes:notify
```

## Email template

```
John deployed MyApp (branch master to production), on 05/08/2012 at 05:29 PM CEST

*** Pivotal Tracker Stories ***

[BUG] Users can't upload, https://www.pivotaltracker.com/story/show/12345678

*** Git Commits ***

deaf044 [Story #12345678] Fixed upload bug (John)
27cf576 [Story #12345678] Fixed upload bug tests (John)
```

## Notes

This gem also adds a rake task (send_email[path]) to the Rails project.
This task is used by the release_notes:notify Capistrano task to send the deployment email *FROM* the server and not from the local machine.
