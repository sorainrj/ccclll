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
	import com.distriqt.extension.application.Application;
	import com.distriqt.extension.playservices.base.ConnectionResult;
	import com.distriqt.extension.playservices.base.GoogleApiAvailability;
	import com.distriqt.test.adverts.AdvertsTests;
	
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
			
			if (Adverts.service.implementation == "Android")
			{
				Config.admob_adUnitId_banner = Config.admob_android_adUnitId_banner;
				Config.admob_adUnitId_interstitial = Config.admob_android_adUnitId_interstitial;
				Config.admob_adUnitId_rewardedVideoAd = Config.admob_android_adUnitId_rewardedVideo;
				Config.admob_adUnitId_nativeAd = Config.admob_android_adUnitId_nativeAd;
			}
			else
			{
				Config.admob_adUnitId_banner = Config.admob_ios_adUnitId_banner;
				Config.admob_adUnitId_interstitial = Config.admob_ios_adUnitId_interstitial;
				Config.admob_adUnitId_rewardedVideoAd = Config.admob_ios_adUnitId_rewardedVideo;
				Config.admob_adUnitId_nativeAd = Config.admob_ios_adUnitId_nativeAd;
			}
			
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
				if (Adverts.isSupported)
				{
					log( "Adverts.isSupported = " + Adverts.isSupported );
					log( "Adverts.version     = " + Adverts.service.version );
					
					
					
					Adverts.service.addEventListener( ErrorEvent.ERROR, errorHandler );
					
					Adverts.service.setup(
							AdvertPlatform.PLATFORM_ADMOB,
							Config.admob_ios_appId
					);
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
					
					_rewardedVideoAd.setAdUnitId( Config.admob_adUnitId_rewardedVideoAd );
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
			_adView.setAdUnitId( Config.admob_adUnitId_banner );

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
		
		
		
		
		//
		//	USER MESSAGING PLATFORM
		//
		
		
		public function ump_getConsentStatus():void
		{
			log( "ump_getConsentStatus()" );
			if (Adverts.service.ump.isSupported)
			{
				var consentInformation:ConsentInformation = Adverts.service.ump.getConsentInformation();
				log( "consent getConsentStatus(): " + consentInformation.getConsentStatus() );
				log( "consent getConsentType():   " + consentInformation.getConsentType() );
				log( "consent isConsentFormAvailable():   " + consentInformation.isConsentFormAvailable() );
			}
		}
		
		
		public function ump_updateConsent():void
		{
			log( "ump_updateConsent()" );
			if (Adverts.service.ump.isSupported)
			{
				var params:ConsentRequestParameters = new ConsentRequestParameters()
						.setTagForUnderAgeOfConsent( false )
						.setConsentDebugSettings(
								new ConsentDebugSettings()
										.addTestDeviceHashedId( "56A70AEC8354671E4E086619542E5E2F" )
//										.addTestDeviceHashedId( "7E98056F-6BE4-4380-A4A1-C79D1BCD80AC" )
										.setDebugGeography( com.distriqt.extension.adverts.ump.DebugGeography.DEBUG_GEOGRAPHY_EEA )
						)
				;
				
				var consentInformation:ConsentInformation = Adverts.service.ump.getConsentInformation();
				consentInformation.addEventListener( ConsentInformationEvent.CONSENT_INFO_UPDATE_SUCCESS, consentInformation_updateSuccessHandler );
				consentInformation.addEventListener( ConsentInformationEvent.CONSENT_INFO_UPDATE_FAILURE, consentInformation_updateFailureHandler );
				consentInformation.requestConsentInfoUpdate( params );
			}
		}
		
		private function consentInformation_updateSuccessHandler( event:ConsentInformationEvent ):void
		{
			log( "consentInformation_updateSuccessHandler()" );
			event.currentTarget.removeEventListener( ConsentInformationEvent.CONSENT_INFO_UPDATE_SUCCESS, consentInformation_updateSuccessHandler );
			event.currentTarget.removeEventListener( ConsentInformationEvent.CONSENT_INFO_UPDATE_FAILURE, consentInformation_updateFailureHandler );
		}
		
		private function consentInformation_updateFailureHandler( event:ConsentInformationEvent ):void
		{
			log( "consentInformation_updateFailureHandler() : ["+event.error.errorID+"] " + event.error.message );
			event.currentTarget.removeEventListener( ConsentInformationEvent.CONSENT_INFO_UPDATE_SUCCESS, consentInformation_updateSuccessHandler );
			event.currentTarget.removeEventListener( ConsentInformationEvent.CONSENT_INFO_UPDATE_FAILURE, consentInformation_updateFailureHandler );
		}
		
		
		
		public function ump_loadForm():void
		{
			log( "ump_loadForm()" );
			if (Adverts.service.ump.isSupported)
			{
				var consentInformation:ConsentInformation = Adverts.service.ump.getConsentInformation();
				
				if (consentInformation.isConsentFormAvailable())
				{
					Adverts.service.ump.addEventListener( UserMessagingPlatformEvent.CONSENT_FORM_LOAD_SUCCESS, ump_loadFormSuccessHandler );
					Adverts.service.ump.addEventListener( UserMessagingPlatformEvent.CONSENT_FORM_LOAD_FAILURE, ump_loadFormFailureHandler );
					Adverts.service.ump.loadConsentForm();
				}
				else
				{
					log( "ump_loadForm() No form available" );
				}
			}
		}
		
		private function ump_loadFormSuccessHandler( event:UserMessagingPlatformEvent ):void
		{
			log( "ump_loadFormSuccessHandler()" );
		}
		
		private function ump_loadFormFailureHandler( event:UserMessagingPlatformEvent ):void
		{
			log( "ump_loadFormFailureHandler() : ["+event.error.errorID+"] " + event.error.message );
		}
		
		
		
		public function ump_showForm():void
		{
			log( "ump_showForm()" );
			if (Adverts.service.ump.isSupported)
			{
				var consentInformation:ConsentInformation = Adverts.service.ump.getConsentInformation();
				
				if (consentInformation.isConsentFormAvailable())
				{
					Adverts.service.ump.addEventListener( UserMessagingPlatformEvent.CONSENT_FORM_DISMISSED, ump_showFormDismissedHandler );
					Adverts.service.ump.showConsentForm();
				}
				else
				{
					log( "ump_showForm() No form available" );
				}
			}
		}
		
		private function ump_showFormDismissedHandler( event:UserMessagingPlatformEvent ):void
		{
			log( "ump_showFormDismissedHandler()" );
		}
		
		
		
		public function ump_reset():void
		{
			Adverts.service.ump.getConsentInformation().reset();
		}
		
		
		
		
		//
		//	NATIVE ADS
		//
		
		private var _nativeAd : NativeAd;
		
		public function na_create():void
		{
			if (_nativeAd != null) return;
			
			if (Adverts.service.nativeAds.isSupported)
			{
				_nativeAd = Adverts.service.nativeAds.createNativeAd( Config.admob_adUnitId_nativeAd );
				
				_nativeAd.addEventListener( NativeAdEvent.LOADED, nativeAd_loadedHandler );
				_nativeAd.addEventListener( NativeAdEvent.ERROR, nativeAd_errorHandler );
				_nativeAd.addEventListener( NativeAdEvent.CLOSED, nativeAd_closedHandler );
				_nativeAd.addEventListener( NativeAdEvent.CLICKED, nativeAd_clickedHandler );
				_nativeAd.addEventListener( NativeAdEvent.OPENED, nativeAd_openedHandler );
			}
		}
		
		public function na_load():void
		{
			if (_nativeAd != null)
			{
				_nativeAd.load( new AdRequestBuilder().build() );
			}
		}
		
		public function na_show():void
		{
			if (_nativeAd != null)
			{
				var style:NativeAdTemplateStyle = new NativeAdTemplateStyle()
						.setMainBackgroundColor( 0xFFFF0000 )

						.setCallToActionBackgroundColor( 0xFFFF00FF )
						.setCallToActionTypefaceColor( 0xFF000000 )
						.setCallToActionTextSize( 30 )

						.setPrimaryTextBackgroundColor( 0xFF00FF00 )
						.setPrimaryTextTypefaceColor( 0xFF000000 )

						.setSecondaryTextBackgroundColor( 0xFF0000FF )
						.setSecondaryTextTypefaceColor( 0xFF000000 )

						.setTertiaryTextBackgroundColor( 0xFF666666 )
						.setTertiaryTextTypefaceColor( 0xFF000000 )
				;
				
				var initialParams:AdViewParams = new AdViewParams();
				initialParams.width = Starling.current.nativeStage.stageWidth;
				initialParams.height = 300;
				initialParams.verticalAlign = AdViewParams.ALIGN_BOTTOM;
				
				_nativeAd.showWithTemplate(
						NativeAdTemplate.SMALL,
						initialParams,
						style
				);
			}
		}
		
		
		public function na_show_medium():void
		{
			if (_nativeAd != null)
			{
				var style:NativeAdTemplateStyle = new NativeAdTemplateStyle()
						.setMainBackgroundColor( 0xFFFF0000 )

						.setCallToActionBackgroundColor( 0xFFFF00FF )
						.setCallToActionTypefaceColor( 0xFF000000 )

						.setPrimaryTextBackgroundColor( 0xFF00FF00 )
						.setPrimaryTextTypefaceColor( 0xFF000000 )

						.setSecondaryTextBackgroundColor( 0xFF0000FF )
						.setSecondaryTextTypefaceColor( 0xFF000000 )

						.setTertiaryTextBackgroundColor( 0xFF666666 )
						.setTertiaryTextTypefaceColor( 0xFF000000 )
				;
				
				var initialParams:AdViewParams = new AdViewParams();
				initialParams.y = 0;
				initialParams.x = 0;
				initialParams.width = Starling.current.nativeStage.stageWidth * 0.8;
				initialParams.height = 350 / 320 * initialParams.width;
				
				_nativeAd.showWithTemplate(
						NativeAdTemplate.MEDIUM,
						initialParams,
						style
				);
			}
		}
		
		
		private var _naViewParamsState:int = -1;
		public function na_viewParams():void
		{
			if (null != _nativeAd)
			{
				var params:AdViewParams = new AdViewParams();

				_naViewParamsState++;
				switch (_naViewParamsState)
				{
					case 0:
						params.width = Starling.current.nativeStage.stageWidth * Math.random();
						params.height = 400;
						params.x = 50;
						params.y = Math.random() * 1000;
						break;
					
					case 1:
						params.width = 500;
						params.height = 150;
						params.verticalAlign = AdViewParams.ALIGN_TOP;
						params.horizontalAlign = AdViewParams.ALIGN_RIGHT;
						break;
					
					case 2:
						params.verticalAlign = AdViewParams.ALIGN_BOTTOM;
						break;
					
					case 3:
						params.width = 800;
						params.height = 200;
						params.x = 50;
						params.verticalAlign = AdViewParams.ALIGN_BOTTOM;
						break;
					
					case 4:
						params.width = Starling.current.nativeStage.stageWidth * 0.7;
						params.height = 400;
						params.verticalAlign = AdViewParams.ALIGN_BOTTOM;
						params.horizontalAlign = AdViewParams.ALIGN_CENTER;
						break;
					
					
					case 5:
						params.width = Starling.current.nativeStage.stageWidth * 0.5;
						params.height = Starling.current.nativeStage.stageHeight / Starling.current.nativeStage.stageWidth * params.width;
						break;
					
					case 6:
						params.width = Starling.current.nativeStage.stageWidth * 0.9;
						params.height = Starling.current.nativeStage.stageHeight / Starling.current.nativeStage.stageWidth * params.width;
						break;
					
					case 7:
						params.width = Starling.current.nativeStage.stageWidth;
						params.height = Starling.current.nativeStage.stageHeight;
						setTimeout( na_viewParams, 2000 );
						break;
						
					default:
						_naViewParamsState = -1;
						setTimeout( na_viewParams, 100 );
				}

				try
				{
					_nativeAd.setViewParams( params );
				}
				catch (e:Error)
				{
					log( e.message );
				}
			}
		}
		
		public function na_getViewParams():void
		{
			if (null != _nativeAd)
			{
				var p:AdViewParams = _nativeAd.getViewParams();
				log( "getViewParams(): " + p.toString() );
			}
		}
		
		
		public function na_toggleVisible():void
		{
			if (null != _nativeAd)
			{
				_nativeAd.visible = !_nativeAd.visible;
			}
		}
		
		
		public function na_destroy():void
		{
			if (_nativeAd != null)
			{
				_nativeAd.removeEventListener( NativeAdEvent.LOADED, nativeAd_loadedHandler );
				_nativeAd.removeEventListener( NativeAdEvent.CLOSED, nativeAd_closedHandler );
				_nativeAd.removeEventListener( NativeAdEvent.ERROR, nativeAd_errorHandler );
				_nativeAd.removeEventListener( NativeAdEvent.CLICKED, nativeAd_clickedHandler );
				_nativeAd.removeEventListener( NativeAdEvent.OPENED, nativeAd_openedHandler );
				_nativeAd.destroy();
				_nativeAd = null;
			}
		}
		
		private function nativeAd_loadedHandler( event:NativeAdEvent ):void
		{
			log( "nativeAd_loadedHandler" );
		}
		
		
		private function nativeAd_closedHandler( event:NativeAdEvent ):void
		{
			log( "nativeAd_closedHandler" );
		}
		
		
		private function nativeAd_errorHandler( event:NativeAdEvent ):void
		{
			log( "nativeAd_errorHandler: " + event.errorCode + "::"+event.errorMessage );
		}
		
		
		private function nativeAd_clickedHandler( event:NativeAdEvent ):void
		{
			log( "nativeAd_clickedHandler" );
		}
		
		
		private function nativeAd_openedHandler( event:NativeAdEvent ):void
		{
			log( "nativeAd_openedHandler" );
		}
	}
}
