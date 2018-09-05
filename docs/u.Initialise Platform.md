
## Initialising the extension

You should perform this once in your application near where you are going to initially 
display an advert. This initialises the platform using your advertising settings. 

```as3
if (Adverts.isSupported)
{
	Adverts.service.initialisePlatform( AdvertPlatform.PLATFORM_ADMOB, YOUR_ACCOUNT_ID );
}
```

The account id will be platform specific but is generally some form of application or user identifier.


### Checking Support

You can also check whether a platform is supported before initialising it to dynamically swap platforms, 
by using the `isPlatformSupported` function.

```as3
if (Adverts.service.isPlatformSupported( AdvertPlatform.PLATFORM_ADMOB ))
{
	Adverts.service.initialisePlatform( AdvertPlatform.PLATFORM_ADMOB, YOUR_ACCOUNT_ID );
}
else if (Adverts.service.isPlatformSupported( AdvertPlatform.PLATFORM_IAD ))
{
	Adverts.service.initialisePlatform( AdvertPlatform.PLATFORM_IAD, IAD_ACCOUNT_ID );
}
else
{
	trace( "No platform supported on the current device" );
}
```


### AdMob

With AdMob the account id is the app id from the console. The app id is of a similar form to ad unit ids 
so don't get confused between them.

**You should provide this account id on both iOS and Android now.** (Previously you only had to provide an account id on iOS). 

Call this as below:

```as3
Adverts.service.initialisePlatform( AdvertPlatform.PLATFORM_ADMOB, APP_ID );
```

You may have different app id's for iOS and Android:

```as3
if (Adverts.service.implementation == "Android")
{
	Adverts.service.initialisePlatform( AdvertPlatform.PLATFORM_ADMOB, ANDROID_APP_ID );
}
else 
{
	Adverts.service.initialisePlatform( AdvertPlatform.PLATFORM_ADMOB, IOS_APP_ID );
}

