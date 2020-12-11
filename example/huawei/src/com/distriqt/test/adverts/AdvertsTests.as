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
	import com.distriqt.extension.adverts.AdapterStatus;
	import com.distriqt.extension.adverts.AdvertPlatform;
	import com.distriqt.extension.adverts.AdvertisingIdInfo;
	import com.distriqt.extension.adverts.Adverts;
	import com.distriqt.extension.adverts.InterstitialAd;
	import com.distriqt.extension.adverts.builders.AdViewParamsBuilder;
	import com.distriqt.extension.adverts.builders.AdRequestBuilder;
	import com.distriqt.extension.adverts.consent.Consent;
	import com.distriqt.extension.adverts.consent.ConsentDialogContent;
	import com.distriqt.extension.adverts.consent.ConsentOptions;
	import com.distriqt.extension.adverts.consent.DebugGeography;
	import com.distriqt.extension.adverts.events.AdViewEvent;
	import com.distriqt.extension.adverts.events.AdvertisingIdEvent;
	import com.distriqt.extension.adverts.events.AdvertsEvent;
	import com.distriqt.extension.adverts.events.ConsentEvent;
	import com.distriqt.extension.adverts.events.InterstitialAdEvent;
	import com.distriqt.extension.adverts.events.NativeAdEvent;
	import com.distriqt.extension.adverts.events.RewardedVideoAdEvent;
	import com.distriqt.extension.adverts.nativeads.NativeAd;
	import com.distriqt.extension.adverts.nativeads.NativeAdTemplate;
	import com.distriqt.extension.adverts.nativeads.NativeAdTemplateStyle;
	import com.distriqt.extension.adverts.rewarded.RewardedVideoAd;
	import com.distriqt.extension.adverts.ump.ConsentDebugSettings;
	import com.distriqt.extension.adverts.ump.ConsentInformation;
	import com.distriqt.extension.adverts.ump.ConsentRequestParameters;
	import com.distriqt.extension.adverts.ump.ConsentStatus;
	import com.distriqt.extension.adverts.ump.events.ConsentInformationEvent;
	import com.distriqt.extension.adverts.ump.events.UserMessagingPlatformEvent;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
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
				if (Adverts.isSupported)
				{
					log( "Adverts.isSupported = " + Adverts.isSupported );
					log( "Adverts.version     = " + Adverts.service.version );
					
					Adverts.service.addEventListener( ErrorEvent.ERROR, errorHandler );
					
					log( "AdMob Supported      = " + Adverts.service.isPlatformSupported( AdvertPlatform.PLATFORM_ADMOB ) );
					log( "Huawei Ads Supported = " + Adverts.service.isPlatformSupported( AdvertPlatform.PLATFORM_HUAWEI_ADS ) );
					
					
					Adverts.service.setup( AdvertPlatform.PLATFORM_HUAWEI_ADS );
					
					log( "Adverts.platformVersion = " + Adverts.service.platformVersion );
					
				}
			}
			catch (e:Error)
			{
				log( "ERROR: " + e.message );
			}
		}
		
		
		public function initialise():void
		{
			log( "initialise" );
			if (Adverts.isSupported)
			{
				Adverts.service.addEventListener( AdvertsEvent.INITIALISED, function( e:AdvertsEvent )
				{
					log( "initialised" );
					Adverts.service.removeEventListener( AdvertsEvent.INITIALISED, arguments.callee );

					for each (var adapterStatus:AdapterStatus in e.adapterStatus)
					{
						log( "adapter: " + adapterStatus.name + " : " + adapterStatus.state + " [" + adapterStatus.latency + "] - " + adapterStatus.description );
					}
				});
				
				// If required, delay this call until after consent has been requested.
				Adverts.service.initialise();
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
					_interstitial.setAdUnitId( Config.interstitial_id );
					
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
			showInterstitial();
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
				if (_rewardedVideoAd == null)
				{
					_rewardedVideoAd = Adverts.service.rewardedVideoAds.createRewardedVideoAd();
					
					_rewardedVideoAd.addEventListener( RewardedVideoAdEvent.LOADED, rewarded_eventHandler );
					_rewardedVideoAd.addEventListener( RewardedVideoAdEvent.ERROR, rewarded_errorHandler );
					
					_rewardedVideoAd.addEventListener( RewardedVideoAdEvent.OPENED, rewarded_eventHandler );
					_rewardedVideoAd.addEventListener( RewardedVideoAdEvent.CLOSED, rewarded_eventHandler );
					
					_rewardedVideoAd.addEventListener( RewardedVideoAdEvent.REWARD, rewarded_rewardHandler );
					
					_rewardedVideoAd.setAdUnitId( Config.rewardedVideoAd_id );
				}
				
				_rewardedVideoAd.load( new AdRequestBuilder().build() );
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
			log( event.type +"::"+event.errorCode + "::"+event.errorMessage );
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
//			adView.setAdSize( AdSize.SMART_BANNER );
			adView.setAdaptiveAdSize();
			adView.setAdUnitId( Config.banner_id );
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
			_adView.setAdUnitId( Config.banner_id );

			_adView.setAdSize( AdSize.SMART_BANNER );
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
//						.setIsDesignedForFamilies( true )
						.tagForChildDirectedTreatment( false )
//						.addKeyword( "distriqt" )
//						.maxAdContentRating( "G" )
//						.nonPersonalisedAds( true )
//						.tagForUnderAgeOfConsent( true )
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
			
			Adverts.service.consent.getConsentStatus( "" );
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
			
			options.setDialogContent(
					new ConsentDialogContent()
							.setContentText( "The Ads in this application are provided in collaboration with our advertising partners. To provide this service, we need to share certain information about you with these partners, including your location as well as your usage records for the news service.\n\n" +
													 "For more information about our partners and how your data is processed, please touch %MORE_INFO%.\n\n" +
													 "By touching AGREE, you indicate that you agree to share the above personal information with our partners so that they can provide you with personalized advertisements on behalf of their customers, based on interests and preferences identified or predicted through analysis of your personal information.\n\n" +
													 "You can withdraw your consent at any time by going to settings.\n\n" +
													 "If you touch SKIP, your data will not be shared with our partners and you will not receive personalized ads.")
							.setTitle( "Test Title" )
							.setMoreInfoText( "The Ads in HUAWEI X is provided in collaboration with our partners. You can find a full list of our partners for each country/region %MORE_INFO%.\n\n" +
													  "    In order to provide you with personalized advertisements, we need to share the following information with our partners:\n\n" +
													  "    •\tUser information, including advertising ID, city of residence, country, and language.\n\n" +
													  "    •\tDevice information, including device name and model, operating system version, screen size, and network type.\n\n" +
													  "    •\tService usage information, including news ID and records of views, clicks, dislikes, shares, and comments for news content and advertisements.\n\n" +
													  "    With your consent, the above information will be shared with our partners so that they can provide you with personalized advertisements on behalf of their customers, based on interests and preferences identified or predicted through analysis of your personal information.\n\n" +
													  "    You can withdraw your consent at any time by going to app settings.\n\n" +
													  "    Without your consent, no data will be shared with our partners and you will not receive personalized ads." )
							.setMediationPartnersText("You can find a full list of our partners for each country/region \n\n" )
			);
			
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
