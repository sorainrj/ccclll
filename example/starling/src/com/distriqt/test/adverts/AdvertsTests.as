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
	import com.distriqt.extension.dialog.Dialog;
	import com.distriqt.extension.dialog.builders.AlertBuilder;
	
	import flash.utils.setTimeout;

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
				Dialog.init( "49ad0dbbfd9c6cfecd1c46c9ce71e2a9b68ce9f6DvbuB4AB3okhLjK1jzb4UKe6XF3AbXqImzadwEBITnA5q0e6JXlgjEgJ8+uuLs53dyMqjS9oDb5tWf6ZnyTOY3O2Tzr9UiCr2NctA/N7axj8XQaQf4sJUwz4zOfv2vShMQowTWOTI3WGxNG9BPHbT7MndJ6Cfbz5pAZKoT8b92xaI2Y270RPvjWOHNy+S7OR8NLuCOOGTenR9EegXYybBkwbWXAYBAFTzaqaJicht8+O+tO4p5f9ecudLf42eYoWr1IebB8oZrD2eUh9O8KUalXf7cgsTJpZrLx/V6QYKHmwZWNKLWf1vhhWieEBssCNkJoRaIsd+nep/L5xGxdD7A==" );
				if (Adverts.isSupported)
				{
					message( "Adverts.version = " + Adverts.service.version );
					
					Adverts.service.interstitials.addEventListener( InterstitialEvent.LOADED, loadedHandler );
					Adverts.service.interstitials.addEventListener( InterstitialEvent.ERROR, errorHandler );
					Adverts.service.interstitials.addEventListener( InterstitialEvent.DISMISSED, dismissedHandler );
					
					
					Adverts.service.initialisePlatform( AdvertPlatform.PLATFORM_ADMOB, "" );
					if (Adverts.service.implementation == "Android")
						Adverts.service.setTestDetails( [ "387007BB700741CF24FAB668D7990B80" ] );
				}
			}
			catch (e:Error)
			{
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
					if (Adverts.service.implementation == "Android")
						Adverts.service.interstitials.load( "ca-app-pub-4920614350579341/9513358916" );
					else 
						Adverts.service.interstitials.load( "ca-app-pub-4920614350579341/7447554111" );
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
					
//					setTimeout( function():void
//					{
//						message( "show dialog" );
//						Dialog.service.create(
//							new AlertBuilder( true )
//							.setTitle( "Alert" )
//							.setMessage( "Test Message" )
//							.addOption( "OK" )
//							.build()
//						).show();
//					}, 2000 );
//					
//					setTimeout( function():void
//					{
//						Adverts.service.interstitials.hide();
//					}, 4000 );
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
