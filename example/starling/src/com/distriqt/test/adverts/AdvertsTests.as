/**
 *        __       __               __ 
 *   ____/ /_ ____/ /______ _ ___  / /_
 *  / __  / / ___/ __/ ___/ / __ `/ __/
 * / /_/ / (__  ) / / /  / / /_/ / / 
 * \__,_/_/____/_/ /_/  /_/\__, /_/ 
 *                           / / 
 *                           \/ 
 * http://distriqt.com
 *
 * @file   		ShareTests.as
 * @created		08/01/2016
 */
package com.distriqt.test.adverts
{
	import com.distriqt.extension.adverts.AdRequest;
	import com.distriqt.extension.adverts.AdSize;
	import com.distriqt.extension.adverts.AdView;
	import com.distriqt.extension.adverts.AdViewParams;
	import com.distriqt.extension.adverts.AdvertPlatform;
	import com.distriqt.extension.adverts.AdvertisingIdInfo;
	import com.distriqt.extension.adverts.Adverts;
	import com.distriqt.extension.adverts.InterstitialAd;
	import com.distriqt.extension.adverts.builders.AdViewParamsBuilder;
	import com.distriqt.extension.adverts.builders.AdRequestBuilder;
	import com.distriqt.extension.adverts.events.AdViewEvent;
	import com.distriqt.extension.adverts.events.AdvertisingIdEvent;
	import com.distriqt.extension.adverts.events.InterstitialAdEvent;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	
	
	/**
	 */
	public class AdvertsTests extends Sprite
	{
		
		public static const TAG : String = "Ads";
		
		private var _l : ILogger;
		
		private function log( message:String ):void
		{
			_l.log( TAG, message );
		}
		
		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		public function AdvertsTests( logger:ILogger )
		{
			super();
			_l = logger;
		}
		
		
		public function setup():void
		{
			log( "setup" );
			try
			{
				Adverts.init( Config.distriqtApplicationKey );
				if (Adverts.isSupported)
				{
					log( "Adverts.isSupported = " + Adverts.isSupported );
					log( "Adverts.version     = " + Adverts.service.version );
					
					if (Adverts.service.implementation == "Android")
					{
						Config.admob_adUnitId_banner = Config.admob_android_adUnitId_banner;
						Config.admob_adUnitId_interstitial = Config.admob_android_adUnitId_interstitial;
					}
					else
					{
						Config.admob_adUnitId_banner = Config.admob_ios_adUnitId_banner;
						Config.admob_adUnitId_interstitial = Config.admob_ios_adUnitId_interstitial;
					}
					
					
					Adverts.service.initialisePlatform(
							AdvertPlatform.PLATFORM_ADMOB,
							Config.admob_ios_appId
					);
				}
			}
			catch (e:Error)
			{
				log( "ERROR: " + e.message );
			}
		}
		
		
		public function destroy():void
		{
			log( "destroy" );
			try
			{
				disposeAdView();
				disposeInterstitial();
				
				Adverts.service.dispose();
			}
			catch (e:Error)
			{
			}
		}
		
		
		////////////////////////////////////////////////////////
		//	ADVERTISING IDENTIFIER
		//
		
		public function getAdvertisingId():void
		{
			log( "getAdvertisingId()" );
			
			Adverts.service.addEventListener( AdvertisingIdEvent.ADVERTISING_ID, advertisingIdHandler );
			Adverts.service.getAdvertisingId();
			
//			Adverts.service.getAdvertisingId( printAdvertisingIdInfo );
		}
		
		
		private function advertisingIdHandler( event:AdvertisingIdEvent ):void
		{
			printAdvertisingIdInfo( event.info );
		}
		
		
		private function printAdvertisingIdInfo( info:AdvertisingIdInfo ):void
		{
			log( "advertisingId: " + info.advertisingId );
			log( "isLimitAdTrackingEnabled: " + info.isLimitAdTrackingEnabled );
		}
		
		
		
		
		////////////////////////////////////////////////////////
		//	INTERSTITIALS
		//
		
		private var _interstitial:InterstitialAd;
		
		public function loadInterstitial():void
		{
			log( "loadInterstitial" );
			if (Adverts.isSupported && Adverts.service.interstitials.isSupported)
			{
				if (_interstitial == null)
				{
					_interstitial = Adverts.service.interstitials.createInterstitialAd();
					_interstitial.setAdUnitId( Config.admob_adUnitId_interstitial );
					
					_interstitial.addEventListener( InterstitialAdEvent.LOADED, interstitial_loadedHandler );
					_interstitial.addEventListener( InterstitialAdEvent.ERROR, interstitial_errorHandler );
					_interstitial.addEventListener( InterstitialAdEvent.CLOSED, interstitial_closedHandler );
					_interstitial.addEventListener( InterstitialAdEvent.LEFT_APPLICATION, interstitial_leftApplicationHandler );
					_interstitial.addEventListener( InterstitialAdEvent.OPENED, interstitial_openedHandler );
				}
				
				_interstitial.load( new AdRequestBuilder().build() );
			}
		}
		
		
		public function showInterstitial():void
		{
			log( "showInterstitial" );
			if (_interstitial != null)
			{
				if (_interstitial.isLoaded())
				{
					_interstitial.show();
				}
			}
		}
		
		
		private function interstitial_loadedHandler( event:InterstitialAdEvent ):void
		{
			log( "interstitial loaded and ready to display" );
		}
		
		
		private function interstitial_errorHandler( event:InterstitialAdEvent ):void
		{
			// there was an error, you should try again in some appropriate interval
			log( "interstitial: error: " + event.errorCode)
		}
		
		
		private function interstitial_closedHandler( event:InterstitialAdEvent ):void
		{
			log( "interstitial_closedHandler" );
		}
		
		
		private function interstitial_openedHandler( event:InterstitialAdEvent ):void
		{
			log( "interstitial_openedHandler" );
		}
		
		
		private function interstitial_leftApplicationHandler( event:InterstitialAdEvent ):void
		{
			log( "interstitial_leftApplicationHandler" );
		}
		
		
		

		private function disposeInterstitial():void
		{
			if (_interstitial != null)
			{
				_interstitial.removeEventListener( InterstitialAdEvent.LOADED, interstitial_loadedHandler );
				_interstitial.removeEventListener( InterstitialAdEvent.ERROR, interstitial_errorHandler );
				_interstitial.removeEventListener( InterstitialAdEvent.CLOSED, interstitial_closedHandler );
				_interstitial.removeEventListener( InterstitialAdEvent.LEFT_APPLICATION, interstitial_leftApplicationHandler );
				_interstitial.removeEventListener( InterstitialAdEvent.OPENED, interstitial_openedHandler );
				_interstitial.destroy();
				_interstitial = null;
			}
		}
		
		
		
		
		////////////////////////////////////////////////////////
		//	AD VIEW
		//
		
		
		public function simpleCreateAndShowTest():void
		{
			var adView:AdView = Adverts.service.createAdView();
			adView.setAdSize( AdSize.SMART_BANNER );
			adView.setAdUnitId( Config.admob_adUnitId_banner );
			adView.setViewParams( new AdViewParamsBuilder()
					.setHorizontalAlign( AdViewParams.ALIGN_CENTER )
					.setVerticalAlign( AdViewParams.ALIGN_BOTTOM )
					.build()
			);
			adView.load( new AdRequestBuilder().build() );
			adView.show();
		}
		
		
		
		
		private var _adView : AdView;
		
		public function adView_create():void
		{
			log( "adView_create" );
			_adView = Adverts.service.createAdView();
			
			_adView.setAdSize( AdSize.SMART_BANNER );
			_adView.setAdUnitId( Config.admob_adUnitId_banner );
			
			_adView.addEventListener( AdViewEvent.LOADED, adView_loadedHandler );
			_adView.addEventListener( AdViewEvent.ERROR, adView_errorHandler );

			_adView.addEventListener( AdViewEvent.LEFT_APPLICATION, adView_leftApplicationHandler );
			_adView.addEventListener( AdViewEvent.OPENED, adView_openedHandler );
			_adView.addEventListener( AdViewEvent.CLOSED, adView_closedHandler );
		}
		
		
		
		public function adView_load():void
		{
			log( "adView_load" );
			if (_adView != null)
			{
				var builder:AdRequestBuilder = new AdRequestBuilder();
	
				if (Config.testDeviceId != null && Config.testDeviceId.length > 0)
					builder.addTestDevice( Config.testDeviceId );
				
				_adView.load( builder.build() );
			}
		}
		
		
		private function adView_loadedHandler( event:AdViewEvent ):void
		{
			log( event.type );
		}
		
		private function adView_errorHandler( event:AdViewEvent ):void
		{
			log( event.type + "::" + event.errorCode );
		}
		
		private function adView_leftApplicationHandler( event:AdViewEvent ):void
		{
			log( event.type );
		}
		
		private function adView_openedHandler( event:AdViewEvent ):void
		{
			log( event.type );
		}
		
		private function adView_closedHandler( event:AdViewEvent ):void
		{
			log( event.type );
		}
		
		
		
		//
		//	DESTROY
		//
		
		public function adView_destroy():void
		{
			log( "adView_destroy" );
			if (_adView != null)
			{
				_adView.destroy();
			}
		}
		
		
		
		
		
		//
		//	SIZE
		//
		
		public function adView_getSize():void
		{
			log( "adView_getSize" );
			if (_adView != null)
			{
				var size:AdSize = _adView.getAdSize();
				
				log( "size: " + size.width +"x" + size.height );
				log( "pixel size: " + size.widthInPixels +"x" + size.heightInPixels );
			}
		}
		
		
		
		//
		//	VIEW PARAMS
		//
		
		public function adView_setViewParams_align():void
		{
			log( "adView_setViewParams" );
			if (_adView != null)
			{
				var params:AdViewParams = new AdViewParams();
				params.horizontalAlign = AdViewParams.ALIGN_LEFT;
				params.verticalAlign = AdViewParams.ALIGN_BOTTOM;
				
				_adView.setViewParams( params );
			}
		}
		
		public function adView_setViewParams_fromAdSize():void
		{
			log( "adView_setViewParams" );
			if (_adView != null)
			{
				var size:AdSize = _adView.getAdSize();
				
				var params:AdViewParams = new AdViewParams();
				params.x = 10;
				params.y = 10;
				params.width = size.widthInPixels;
				params.height = size.heightInPixels;
				
//				var guide:Quad = new Quad( 10, 200, 0xFF0000 );
//				addChild( guide );
				
				_adView.setViewParams( params );
			}
		}
		
		
		
		
		//
		//	ADVERT DISPLAY
		//
		
		public function adView_show():void
		{
			log( "adView_show" );
			if (_adView != null)
			{
				_adView.show();
			}
		}
		
		
		public function adView_hide():void
		{
			log( "adView_hide" );
			if (_adView != null)
			{
				_adView.hide();
			}
		}
		
		
		//
		//	ADVERT DISPOSE
		//

		private function disposeAdView():void
		{
			if (_adView != null)
			{
				_adView.removeEventListener( AdViewEvent.LOADED, adView_loadedHandler );
				_adView.removeEventListener( AdViewEvent.ERROR, adView_errorHandler );
				_adView.removeEventListener( AdViewEvent.LEFT_APPLICATION, adView_leftApplicationHandler );
				_adView.removeEventListener( AdViewEvent.OPENED, adView_openedHandler );
				_adView.removeEventListener( AdViewEvent.CLOSED, adView_closedHandler );
				_adView.destroy();
				_adView = null;
			}
		}
		
	}
}
