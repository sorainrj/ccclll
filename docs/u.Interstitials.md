
## Displaying an Interstitial Advert

The interstitials are fullscreen adverts that you can use to transition between 
scenes in your application, such as after a game level.

The interstitials have their own `isSupported` flag as interstitials aren't available on all platforms.

>
> You must initialise an advert platform before calling any of the interstitial functionality. 
> See the "Initialising Platform" section.
>

Interstitials are preloaded, so you can trigger the `load` call at any time, and 
only display when your application is ready or when the advert has been loaded. 
You can check whether the advert is loaded by waiting for the `InterstitialEvent.LOADED` 
or checking the `isReady()` flag.

An error may be dispatched if the advert failed to load due to network problems 
or other such issues. You should simply restart the load perhaps after a period of time.

```as3
Adverts.service.interstitials.addEventListener( InterstitialEvent.LOADED, loadedHandler );
Adverts.service.interstitials.addEventListener( InterstitialEvent.ERROR, errorHandler );

if (Adverts.service.interstitials.isSupported)
{
	Adverts.service.interstitials.load( _adUnitIdInterstitial );
}
```

```as3
private function loadedHandler( event:InterstitialEvent ):void
{
	trace( "interstitial loaded and ready to display" );
}

private function errorHandler( event:InterstitialEvent ):void
{
	// there was an error, you should try again in some appropriate interval
}
```


When you are ready to display your advert you call `show()` as below. When showing an 
advert you should save any content in your application as the advert may take the user 
out of your application if they follow the presented action. The `InterstitialEvent.DISMISSED` 
event is dispatched when the user dismisses the advert and control returns to your 
application and you can then resume operation.


```as3
Adverts.service.interstitials.addEventListener( InterstitialEvent.DISMISSED, dismissedHandler );

if (Adverts.service.interstitials.isReady())
{
	Adverts.service.interstitials.show();
}
```

```as3
private function dismissedHandler( event:InterstitialEvent ):void
{
	trace( "interstitial dismissed control returns to your application" );
}
```
