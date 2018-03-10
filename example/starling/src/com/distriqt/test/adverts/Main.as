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
	import flash.system.Capabilities;
	
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.controls.ScrollContainer;
	import feathers.layout.VerticalLayout;
	import feathers.themes.MetalWorksMobileTheme;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
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
		private var _container	:ScrollContainer ;

		
		
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
		}
		
		
		public function log( tag:String, message:String ):void
		{
			trace( tag+"::"+message );
			if (_text)
				_text.text = tag+"::"+message + "\n" + _text.text ;
		}
		
		
		private function create():void
		{
			_text = new TextField( stage.stageWidth, stage.stageHeight, "", "_typewriter", 18, Color.WHITE );
			_text.hAlign = HAlign.LEFT;
			_text.vAlign = VAlign.TOP;
			_text.y = 40;
			_text.touchable = false;
			
			var layout:VerticalLayout = new VerticalLayout();
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_RIGHT;
			layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			layout.gap = 5;
			
			_container = new ScrollContainer();
			_container.y = 40;
			_container.layout = layout;
			_container.width = stage.stageWidth;
			_container.height = stage.stageHeight-40;
			
			_tests = new AdvertsTests( this );
			
			addAction( "Setup", _tests.setup );
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
			
			
			addAction( "Load Interstitial", _tests.loadInterstitial );
			addAction( "Show Interstitial", _tests.showInterstitial );
			
			
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