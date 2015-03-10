# Answers
This is a simple iOS app that relies on [Cloudant Sync datastore library] (https://github.com/cloudant/CDTDatastore) for persistence & synchronization.

So far, you can:

* Create/delete a question
* Add options to a question
* Create answers
* Pull to refresh to manually trigger a synchronization

## HOWTO create an answer

1. Press + to create a question
2. Select a question
3. Press + to create an option
4. Select one or multiple options and press Save

## Synchronization

After every action, the app tries to synchronize changes with a [Cloudant](https://cloudant.com/) database. You can also 'Pull to refresh' to trigger a synchronization. However the app is still able to work if there is not a remote database.

To provide a [Cloudant](https://cloudant.com/) database, first you have to create it:

1. [Sign in](https://cloudant.com/sign-in/) to access Dashboard
2. Create a database
3. Select the new database
4. Select 'Permissions'
5. Generate an API key
6. The API key requires read and write permissions

Then you have to add to the Xcode project a plist file called 'cloudantAnswersDatabaseURL.plist' and this content:

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
<key>url</key>
<string>https://<API KEY>:<API KEY PASSWORD>@<YOUR USERNAME>.cloudant.com/<DATABASE NAME></string>
</dict>
</plist>
```

## License

See [LICENSE](LICENSE)

### Used libraries
* [CDTDatastore](https://github.com/cloudant/CDTDatastore), is under the Apache License 2.0.
* [UIAlertView+Blocks](https://github.com/ryanmaxwell/UIAlertView-Blocks), is under the MIT License.