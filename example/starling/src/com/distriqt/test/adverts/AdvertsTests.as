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
	import com.distriqt.extension.adverts.AdvertPlatform;
	import com.distriqt.extension.adverts.Adverts;
	import com.distriqt.extension.adverts.events.InterstitialEvent;
	
	/**
	 */
	public class AdvertsTests
	{
		
		public static const TAG : String = "Ads";
		
		private var _l : ILogger;
		
		private function message( log:String ):void
		{
			_l.log( TAG, log );
		}
		
		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		public function AdvertsTests( logger:ILogger )
		{
			_l = logger;
		}
		
		
		public function setup():void
		{
			message( "setup" );
			try
			{
				Adverts.init( Config.distriqtApplicationKey );
				if (Adverts.isSupported)
				{
					message( "Adverts.version = " + Adverts.service.version );
					
					Adverts.service.interstitials.addEventListener( InterstitialEvent.LOADED, loadedHandler );
					Adverts.service.interstitials.addEventListener( InterstitialEvent.ERROR, errorHandler );
					Adverts.service.interstitials.addEventListener( InterstitialEvent.DISMISSED, dismissedHandler );
					
					Adverts.service.initialisePlatform( AdvertPlatform.PLATFORM_ADMOB );
					if (Adverts.service.implementation == "Android" && Config.testDeviceId.length > 0)
						Adverts.service.setTestDetails( [ Config.testDeviceId ] );
				}
			}
			catch (e:Error)
			{
				message( "ERROR: " + e.message );
			}
		}
		
		
		public function dispose():void
		{
			message( "dispose" );
			try
			{
				Adverts.service.dispose();
			}
			catch (e:Error)
			{
			}
		}
		
		
		public function loadInterstitial():void
		{
			message( "loadInterstitial" );
			if (Adverts.isSupported)
			{
				if (Adverts.service.interstitials.isSupported)
				{
					Adverts.service.interstitials.load( Config.admob_adUnitId_interstitial );
				}
			}
		}
		
		
		public function showInterstitial():void
		{
			message( "showInterstitial" );
			if (Adverts.isSupported)
			{
				if (Adverts.service.interstitials.isReady())
				{
					Adverts.service.interstitials.show();
				}
			}
		}
		
		
		
		
		
		////////////////////////////////////////////////////////
		//	EVENT HANDLERS
		//
		
		private function loadedHandler( event:InterstitialEvent ):void
		{
			message( "interstitial loaded and ready to display" );
		}
		
		private function errorHandler( event:InterstitialEvent ):void
		{
			// there was an error, you should try again in some appropriate interval
		}
		
		private function dismissedHandler( event:InterstitialEvent ):void
		{
			message( "interstitial dismissed control returns to your application" );
		}

		
		
	}
}
