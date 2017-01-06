
## Initialising the extension

You should perform this once in your application near where you are going to initially 
display an advert. This initialises the platform using your advertising settings. 

```as3
if (Adverts.isSupported)
{
	Adverts.service.initialisePlatform( AdvertPlatform.PLATFORM_ADMOB, YOUR_ACCOUNT_ID );
}
```

You can also check whether a platform is supported before initialising it to dynamically swap platforms.

```as3
if (Adverts.service.isPlatformSupported( AdvertPlatform.PLATFORM_ADMOB ))
{
	Adverts.service.initialisePlatform( AdvertPlatform.PLATFORM_ADMOB, ADMOB_UNIT_ID );
}
else if (Adverts.service.isPlatformSupported( AdvertPlatform.PLATFORM_IAD ))
{
	Adverts.service.initialisePlatform( AdvertPlatform.PLATFORM_IAD, IAD_ACCOUNT_ID );
}
else
{
	trace( "No platform not supported" );
}
```
