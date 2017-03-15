
## Add the Extension

First step is always to add the extension to your development environment. 
To do this use the tutorial located [here](https://airnativeextensions.com/knowledgebase/tutorial/1).



## Required ANEs

### Core ANE

The Core ANE is required by this ANE. You must include and package this extension in your application.

The Core ANE doesn't provide any functionality in itself but provides support libraries and frameworks used by our extensions.
It also includes some centralised code for some common actions that can cause issues if they are implemented in each individual extension.

You can access this extension here: [https://github.com/distriqt/ANE-Core](https://github.com/distriqt/ANE-Core).


### Android Support ANE

Due to several of our ANE's using the Android Support library the library has been separated 
into a separate ANE allowing you to avoid conflicts and duplicate definitions.
This means that you need to include the some of the android support native extensions in 
your application along with this extension. 

You will add these extensions as you do with any other ANE, and you need to ensure it is 
packaged with your application. There is no problems including this on all platforms, 
they are just **required** on Android.

This ANE requires the following Android Support extensions:

- [com.distriqt.androidsupport.V4.ane](https://github.com/distriqt/ANE-AndroidSupport/raw/master/lib/com.distriqt.androidsupport.V4.ane)

You can access these extensions here: [https://github.com/distriqt/ANE-AndroidSupport](https://github.com/distriqt/ANE-AndroidSupport).

>
> **Note**: if you have been using the older `com.distriqt.AndroidSupport.ane` you should remove that
> ANE and replace it with the equivalent `com.distriqt.androidsupport.V4.ane`. This is the new 
> version of this ANE and has been renamed to better identify the ANE with regards to its contents.
>


### Google Play Services 

This ANE requires usage of certain aspects of the Google Play Services client library. 
The client library is available as a series of ANEs that you add into your applications packaging options. 
Each separate ANE provides a component from the Play Services client library and are used by different ANEs. 
These client libraries aren't packaged with this ANE as they are used by multiple ANEs and separating them 
will avoid conflicts, allowing you to use multiple ANEs in the one application.

This ANE requires the following Google Play Services:

- [com.distriqt.playservices.Base.ane](https://github.com/distriqt/ANE-GooglePlayServices/raw/master/lib/com.distriqt.playservices.Base.ane)
- [com.distriqt.playservices.Ads.ane](https://github.com/distriqt/ANE-GooglePlayServices/raw/master/lib/com.distriqt.playservices.Ads.ane)

You must include the above native extensions in your application along with this extension, 
and you need to ensure they are packaged with your application.

You can access the Google Play Services client library extensions here: 
[https://github.com/distriqt/ANE-GooglePlayServices](https://github.com/distriqt/ANE-GooglePlayServices).




## Android Manifest Additions

The CameraUI ANE requires a few additions to the manifest to be able to start certain activities and get access to the users media. 
You should add the listing below to your manifest, replacing `APPLICATION_ID` with your AIR application id on Android 
(eg `air.com.distriqt.test`) Note that it may be prefixed by `air.`.

```xml
<manifest android:installLocation="auto">
	
	<!--Required. Used to access the Internet to make ad requests-->
	<uses-permission android:name="android.permission.INTERNET"/>

	<!--Optional. Used to check if an internet connection is available prior to making an ad request.-->
	<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>

	<application>

		<meta-data android:name="com.google.android.gms.version" android:value="@integer/google_play_services_version"/>
		
		<activity 
			android:name="com.google.android.gms.ads.AdActivity"
			android:configChanges="keyboard|keyboardHidden|orientation|screenLayout|uiMode|screenSize|smallestScreenSize" 
			android:theme="@android:style/Theme.Translucent" />
			
	</application>

</manifest>
```


## iOS Additions

App Transport Security (ATS) is a privacy feature introduced in iOS 9. It's enabled 
by default for new applications and enforces secure connections.

All iOS 9 or higher devices running apps that don't disable ATS will be affected by 
this change. This may affect your app's integration with the Google Mobile Ads SDK.

The following log message appears when a non-ATS compliant app attempts to serve an 
ad via HTTP on iOS 9 or iOS 10:

> App Transport Security has blocked a cleartext HTTP (http://) resource load since it is insecure. Temporary exceptions can be configured via your app's Info.plist file.

To ensure your ads are not impacted by ATS, add the following to the `InfoAdditions`
node in your `iPhone` settings of your application descriptor:

```xml
<key>NSAppTransportSecurity</key>
<dict>
	<key>NSAllowsArbitraryLoads</key>
	<true/>
	<key>NSAllowsArbitraryLoadsForMedia</key>
	<true/>
	<key>NSAllowsArbitraryLoadsInWebContent</key>
	<true/>
</dict>
```

The `NSAllowsArbitraryLoads` exception is required to make sure your ads are not 
impacted by ATS on iOS 9 devices, while `NSAllowsArbitraryLoadsForMedia` and 
`NSAllowsAribtraryLoadsInWebContent` are required to make sure your ads are 
not impacted by ATS on iOS 10 devices.

