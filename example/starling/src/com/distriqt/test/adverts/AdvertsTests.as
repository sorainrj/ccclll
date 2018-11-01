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
	import com.distriqt.extension.adverts.consent.Consent;
	import com.distriqt.extension.adverts.consent.ConsentOptions;
	import com.distriqt.extension.adverts.consent.DebugGeography;
	import com.distriqt.extension.adverts.events.AdViewEvent;
	import com.distriqt.extension.adverts.events.AdvertisingIdEvent;
	import com.distriqt.extension.adverts.events.ConsentEvent;
	import com.distriqt.extension.adverts.events.InterstitialAdEvent;
	import com.distriqt.extension.adverts.events.RewardedVideoAdEvent;
	import com.distriqt.extension.adverts.rewarded.RewardedVideoAd;
	import com.distriqt.extension.playservices.base.ConnectionResult;
	import com.distriqt.extension.playservices.base.GoogleApiAvailability;
	
	import flash.events.ErrorEvent;
	
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
		
		
		
		public function checkPlayServices():void
		{
			var result:int = GoogleApiAvailability.instance.isGooglePlayServicesAvailable();
			if (result != ConnectionResult.SUCCESS)
			{
				if (GoogleApiAvailability.instance.isUserRecoverableError( result ))
				{
					GoogleApiAvailability.instance.showErrorDialog( result );
				}
				else
				{
					log( "Google Play Services aren't available on this device" );
				}
			}
			else
			{
				log( "Google Play Services are Available" );
			}
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
						Config.admob_adUnitId_rewardedVideoAd = Config.admob_android_adUnitId_rewardedVideo;
					}
					else
					{
						Config.admob_adUnitId_banner = Config.admob_ios_adUnitId_banner;
						Config.admob_adUnitId_interstitial = Config.admob_ios_adUnitId_interstitial;
						Config.admob_adUnitId_rewardedVideoAd = Config.admob_ios_adUnitId_rewardedVideo;
					}
					
					Adverts.service.addEventListener( ErrorEvent.ERROR, errorHandler );
					
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
		
		private function errorHandler( event:ErrorEvent ):void
		{
			log( "error::" + event.text );
		}
		
		
		public function destroy():void
		{
			log( "destroy" );
			try
			{
				disposeAdView();
				disposeInterstitial();
				
				Adverts.service.removeEventListener( ErrorEvent.ERROR, errorHandler );
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
		
		
		
		
		//
		//
		//	REWARDED VIDEO AD
		//
		//
		
		private var _rewardedVideoAd : RewardedVideoAd;
		
		
		public function rewardedVideo_load():void
		{
			log( "rewardedVideo_load" );
			if (Adverts.service.rewardedVideoAds.isSupported)
			{
				_rewardedVideoAd = Adverts.service.rewardedVideoAds.createRewardedVideoAd();
				
				if (_rewardedVideoAd != null)
				{
					_rewardedVideoAd.addEventListener( RewardedVideoAdEvent.LOADED, rewarded_eventHandler );
					_rewardedVideoAd.addEventListener( RewardedVideoAdEvent.ERROR, rewarded_errorHandler );
					
					_rewardedVideoAd.addEventListener( RewardedVideoAdEvent.OPENED, rewarded_eventHandler );
					_rewardedVideoAd.addEventListener( RewardedVideoAdEvent.CLOSED, rewarded_eventHandler );
					_rewardedVideoAd.addEventListener( RewardedVideoAdEvent.LEFT_APPLICATION, rewarded_eventHandler );
					_rewardedVideoAd.addEventListener( RewardedVideoAdEvent.VIDEO_STARTED, rewarded_eventHandler );
					
					_rewardedVideoAd.addEventListener( RewardedVideoAdEvent.REWARD, rewarded_rewardHandler );
					
					_rewardedVideoAd.load(
							Config.admob_adUnitId_rewardedVideoAd,
							new AdRequestBuilder().build()
					);
				}
				else
				{
					log( "ERROR creating rewarded video ad" );
				}
			}
			else
			{
				log( "Rewarded Video Ads NOT SUPPORTED" );
			}
		}
		
		
		public function rewardedVideo_show():void
		{
			log( "rewardedVideo_show" );
			if (_rewardedVideoAd != null)
			{
				if (_rewardedVideoAd.isLoaded())
				{
					_rewardedVideoAd.show();
				}
				else
				{
					log( "Not loaded" );
				}
			}
		}
		
		
		private function rewarded_eventHandler( event:RewardedVideoAdEvent ):void
		{
			log( event.type );
		}
		
		private function rewarded_errorHandler( event:RewardedVideoAdEvent ):void
		{
			log( event.type +"::"+event.errorCode );
		}
		
		private function rewarded_rewardHandler( event:RewardedVideoAdEvent ):void
		{
			log( event.type + "::" +event.rewardAmount + "["+event.rewardType+"]" );
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
			_adView.setViewParams( new AdViewParamsBuilder()
					.setHorizontalAlign( AdViewParams.ALIGN_CENTER )
					.setVerticalAlign( AdViewParams.ALIGN_BOTTOM )
					.build()
			);
			
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
				var builder:AdRequestBuilder = new AdRequestBuilder()
						.setIsDesignedForFamilies( true )
						.tagForChildDirectedTreatment( true )
						.addKeyword( "distriqt" )
						.maxAdContentRating( "G" )
						.nonPersonalisedAds( true )
						.tagForUnderAgeOfConsent( true )
				;
				
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
		
		
		
		
		//
		//	CONSENT
		//
		
		public function setConsentDebug():void
		{
			log( "setConsentDebug()" );
//			Adverts.service.consent.addTestDevice( "44DB3CFE748FAAEA1B9816252214941E" );
			Adverts.service.consent.addTestDevice( "F1C0AFEFF151A60B62C089B377FFC555" );
			Adverts.service.consent.setDebugGeography( DebugGeography.DEBUG_GEOGRAPHY_EEA );
		}
		
		
		public function getConsentStatus():void
		{
			log( "getConsentStatus()" );
			
			Adverts.service.consent.addEventListener( ConsentEvent.STATUS_UPDATED, consent_statusUpdatedHandler );
			Adverts.service.consent.addEventListener( ConsentEvent.STATUS_ERROR, consent_statusErrorHandler );
			
			Adverts.service.consent.getConsentStatus( Config.admob_publisher_id );
		}
		
		private function consent_statusUpdatedHandler( event:ConsentEvent ):void
		{
			log( "consent_statusUpdatedHandler(): " + event.status
					+ " inEea:" + event.inEeaOrUnknown );
			Adverts.service.consent.removeEventListener( ConsentEvent.STATUS_UPDATED, consent_statusUpdatedHandler );
			Adverts.service.consent.removeEventListener( ConsentEvent.STATUS_ERROR, consent_statusErrorHandler );
		}
		
		private function consent_statusErrorHandler( event:ConsentEvent ):void
		{
			log( "consent_statusErrorHandler(): " + event.error );
			Adverts.service.consent.removeEventListener( ConsentEvent.STATUS_UPDATED, consent_statusUpdatedHandler );
			Adverts.service.consent.removeEventListener( ConsentEvent.STATUS_ERROR, consent_statusErrorHandler );
		}
		
		
		
		
		public function askForConsent():void
		{
			log( "askForConsent()" );
			var options:ConsentOptions = new ConsentOptions( "https://airnativeextensions.com/privacy" )
					.withPersonalizedAdsOption()
					.withNonPersonalizedAdsOption();
//					.withAdFreeOption();
			
			Adverts.service.consent.addEventListener( ConsentEvent.FORM_CLOSED, consent_formClosedHandler );
			Adverts.service.consent.addEventListener( ConsentEvent.FORM_ERROR, consent_formErrorHandler );
			
			Adverts.service.consent.askForConsent( options );
		}
		
		private function consent_formClosedHandler( event:ConsentEvent ):void
		{
			log( "consent_formClosedHandler(): " + event.status
					+ " inEea:" + event.inEeaOrUnknown
					+ " adFree:" + event.userPrefersAdFree );
			
			Adverts.service.consent.removeEventListener( ConsentEvent.FORM_CLOSED, consent_formClosedHandler );
			Adverts.service.consent.removeEventListener( ConsentEvent.FORM_ERROR, consent_formErrorHandler );
		}
		
		private function consent_formErrorHandler( event:ConsentEvent ):void
		{
			log( "consent_formErrorHandler(): " + event.error );
			
			Adverts.service.consent.removeEventListener( ConsentEvent.FORM_CLOSED, consent_formClosedHandler );
			Adverts.service.consent.removeEventListener( ConsentEvent.FORM_ERROR, consent_formErrorHandler );
		}
		
		
		
	}
}
