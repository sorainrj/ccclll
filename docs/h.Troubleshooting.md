

## Common Issues


### Waiting

It can take an hour or two for a new ad unit to become available. Make sure you have waited a decent amount of time before testing your ad unit ids.


### Error Code 0

Error code 0 (`ERROR_CODE_INTERNAL_ERROR`) can occur for many reasons. It is an Internal Error that may indicate that something unexpected has happened, such as an error from the SDK, or an invalid response from the server.

Firstly check that your identifier's are all correct. If you are on iOS also check that you have provided the correct account id to the `initialisePlatform` call.

The most common cause that we have encountered of this issue is an application id (package name) that has been denied or blocked by AdMob. This can occur if you have been using live ad unit ids while developing your application rather than using the test id's or specifying the test device id. 

To confirm this you can try changing your application id and serving the same ad unit id from this new application id. If it works from this new application id then you can assume your application id has been blocked.  

>
> If you suspect that your app's Package Name has been blocked from serving ads, then it's not something specific to the Mobile Ads SDK and this ANE. We recommend that you reach out to the [Product Support Team](https://support.google.com/admob/contact/account_setup) to get this issue sorted out, or you can use this [Troubleshooter](https://support.google.com/admob/troubleshooter/6401922). 
> 
> Make sure to provide them the necessary information, such as any affected Ad Unit IDs and Package Names for them to assist you quicker.
>




