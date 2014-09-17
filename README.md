# Pax Checker

A tool for watching for watching for PAX events to start selling tickets.
Checks every minute and then notifies you via SMS or Email immediately. Runs
on Heroku.

## Deploying to Heroku

  * Clone the repository

```bash
git clone http://github.com/tedkulp/activitystream.git
```

  * Create & configure for Heroku

```bash
heroku create example-paxchecker
heroku addons:add mongohq:sandbox
heroku addons:add sendgrid:starter
heroku addons:add telapi:test                        # Not adding this disables SMS attempts
heroku config:set BUILDPACK_URL=https://github.com/appstack/heroku-buildpack-nodejs-gulp.git
heroku config:add SERVICE_URL="http://$(heroku domains | grep "herokuapp.com")"
```

  * Push to heroku

```bash
git push heroku master
```

  * Navigate to your new site, register, and set notifications
