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
 * @file   		Main.as
 * @created		08/01/2016
 */
package com.distriqt.test.adverts
{
	import feathers.layout.HorizontalAlign;
	import feathers.layout.VerticalAlign;
	
	import flash.geom.Rectangle;
	
	import flash.media.StageWebView;
	
	import flash.system.Capabilities;
	
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.controls.ScrollContainer;
	import feathers.layout.VerticalLayout;
	import feathers.themes.MetalWorksMobileTheme;
	
	import starling.core.Starling;
	
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.utils.Color;
	
	/**	
	 * 
	 */
	public class Main extends Sprite implements ILogger
	{
		////////////////////////////////////////////////////////
		//	CONSTANTS
		//
		
		
		////////////////////////////////////////////////////////
		//	VARIABLES
		//
		
		private var _tests		: AdvertsTests;

		
		//	UI
		private var _text		: TextField;
		private var _container	: ScrollContainer ;

		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		
		/**
		 *  Constructor
		 */
		public function Main()
		{
			super();
			addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
			
//			var options:NativeWebViewOptions = new NativeWebViewOptions();
//			NativeWebView.service.initialisePlatform( options, function( success:Boolean):void
//			{
//				// You can now create web views
//			});
		}
		
		
		public function log( tag:String, message:String ):void
		{
			trace( tag+"::"+message );
			if (_text)
				_text.text = tag+"::"+message + "\n" + _text.text ;
		}
		
		
		private function create():void
		{
			var tf:TextFormat = new TextFormat( "_typewriter", 12, Color.WHITE, HorizontalAlign.LEFT, VerticalAlign.TOP );
			_text = new TextField( stage.stageWidth, stage.stageHeight, "", tf );
			_text.y = 40;
			_text.touchable = false;
			
			var layout:VerticalLayout = new VerticalLayout();
			layout.horizontalAlign = HorizontalAlign.RIGHT;
			layout.verticalAlign = VerticalAlign.BOTTOM;
			layout.gap = 5;
			
			_container = new ScrollContainer();
			_container.y = 300;
			_container.layout = layout;
			_container.width = stage.stageWidth;
			_container.height = stage.stageHeight-300;
			
			
			addAction( "Add CustomWebView", addWebView );
			addAction( "Remove CustomWebView", removeWebView );
			
			_tests = new AdvertsTests( this );
			
			addAction( "Check Play Services", _tests.checkPlayServices );
			addAction( "Setup", _tests.setup );
			addAction( "Initialise", _tests.initialise );
			addAction( "Dispose", _tests.destroy );
			addAction( "Get Advertising Id", _tests.getAdvertisingId );
			

			addAction( "Simple Test :AdView", _tests.simpleCreateAndShowTest );
			addAction( "Create :AdView", _tests.adView_create );
			addAction( "Load :AdView", _tests.adView_load );
			addAction( "Destroy :AdView", _tests.adView_destroy );
			addAction( "Get Size :AdView", _tests.adView_getSize );
			addAction( "Show :AdView", _tests.adView_show );
			addAction( "View Params (adsize) :AdView", _tests.adView_setViewParams_fromAdSize );
			addAction( "View Params (align) :AdView", _tests.adView_setViewParams_align );
			addAction( "Hide :AdView", _tests.adView_hide );
			
			
			
			addAction( "Load :Interstitial", _tests.loadInterstitial );
			addAction( "Show :Interstitial", _tests.showInterstitial );
			
			
			addAction( "Load :Rewarded Video", _tests.rewardedVideo_load );
			addAction( "Show :Rewarded Video", _tests.rewardedVideo_show );
			
			
			addAction( "Create :Native Ad", _tests.na_create );
			addAction( "Load :Native Ad", _tests.na_load );
			addAction( "Show :Native Ad", _tests.na_show );
			addAction( "Show (medium) :Native Ad", _tests.na_show_medium );
			addAction( "View Params :Native Ad", _tests.na_viewParams );
			addAction( "Get View Params :Native Ad", _tests.na_getViewParams );
			addAction( "Toggle Visible :Native Ad", _tests.na_toggleVisible );
			addAction( "Destroy :Native Ad", _tests.na_destroy );
			
			
//			addAction( "Set Debug :Consent", _tests.setConsentDebug );
//			addAction( "Get Consent Status :Consent", _tests.getConsentStatus );
//			addAction( "Ask For Consent :Consent", _tests.askForConsent );
			
			addAction( "Get Consent Status :UMP", _tests.ump_getConsentStatus );
			addAction( "Update Consent :UMP", _tests.ump_updateConsent );
			addAction( "Load Form :UMP", _tests.ump_loadForm );
			addAction( "Show Form :UMP", _tests.ump_showForm );
			addAction( "Reset :UMP", _tests.ump_reset );
			
			addChild( _tests );
			addChild( _text );
			addChild( _container );
		}
		
		
		private function addAction( label:String, listener:Function ):void
		{
			var b:Button = new Button();
			b.label = label;
			b.addEventListener( starling.events.Event.TRIGGERED, listener );
			_container.addChild(b);
		}
		
		
//		private var stageWebView:StageWebView;
//
//
//		private var browser:CustomWebView;

		private function addWebView():void
		{
//			if (stageWebView == null)
//			{
//				stageWebView = new StageWebView();
//				stageWebView.stage = Starling.current.nativeStage;
//				stageWebView.viewPort = new flash.geom.Rectangle( 0,0,400, 300 );
//				stageWebView.loadURL( "https://distriqt.com" );
//			}
//
////			if (browser == null)
////			{
////				browser = new CustomWebView();
////				browser.width = 400;
////				browser.height = 300;
////				this.addChild( browser );
////
////				browser.loadURL( "https://distriqt.com" );
////			}
		}

		private function removeWebView():void
		{
//			if (stageWebView != null)
//			{
//				stageWebView.stage = null;
//				stageWebView.dispose();
//				stageWebView = null;
//			}

//			if (browser != null)
//			{
//				removeChild( browser );
//				browser.dispose();
//				browser = null;
//			}
		}
		
		
		////////////////////////////////////////////////////////
		//	EVENT HANDLERS
		//
		
		protected function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler );
			var theme:MetalWorksMobileTheme = new MetalWorksMobileTheme();
			create();
		}

		
	}
}