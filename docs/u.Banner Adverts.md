
## Displaying an Banner Advert

The process of showing an advert is relatively straight forward

```as3
var position:AdvertPosition = new AdvertPosition();
position.verticalAlign   = AdvertPosition.ALIGN_BOTTOM;
position.horizontalAlign = AdvertPosition.ALIGN_CENTER;

Adverts.service.showAdvert( position );
```


You can also listen for events to react when the advert is displayed (received).

```as3
Adverts.service.addEventListener( AdvertEvent.RECEIVED_AD, adverts_receivedAdHandler );
private function adverts_receivedAdHandler( event:AdvertEvent ):void
{
	trace( "received an advertisement" );
}
```


### Hiding an Advert

Hiding an advert is a simple call. This will remove the advert from being 
displayed and clear from system memory. The advert will no longer be refreshed.

```as3
Adverts.service.hideAdvert();
```


### Refreshing/Updating an advert

If you wish to manually refresh the advert you can call the refresh function. 
This will make the advert update with a new ad request.

```as3
Adverts.service.refresh();
```
