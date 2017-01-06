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
		
		private var _helper		: AdvertsTests;

		
		//	UI
		private var _text		: TextField;
		private var _buttons	: Vector.<Button>;

		
		
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
		
		
		////////////////////////////////////////////////////////
		//	INTERNALS
		//
		
		private function init():void
		{
			_helper = new AdvertsTests( this );
		}
		
		
		
		
		////////////////////////////////////////////////////////
		//	EVENT HANDLERS
		//
		
		protected function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler );
			
			var theme:MetalWorksMobileTheme = new MetalWorksMobileTheme();
			
			Config.scale = 2 * Capabilities.screenDPI / theme.originalDPI;
			
			_text = new TextField( stage.stageWidth, stage.stageHeight, "", "_typewriter", 18, Color.WHITE );
			_text.hAlign = HAlign.LEFT; 
			_text.vAlign = VAlign.TOP;
			_text.y = 40;
			_text.touchable = false;
			
			var layout:VerticalLayout = new VerticalLayout();
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_RIGHT;
			layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_BOTTOM;
			layout.gap = 5;
			var container:ScrollContainer = new ScrollContainer();
			container.layout = layout;
			container.width = stage.stageWidth;
			container.height = stage.stageHeight-50;
			
			_buttons = new Vector.<Button>();
			
			init();
			
			addAction( "Setup", _helper.setup );
			addAction( "Dispose", _helper.dispose );

			addAction( "Load Interstitial", _helper.loadInterstitial );
			addAction( "Show Interstitial", _helper.showInterstitial );
			
			
			
			
			addChild( _text );
			for each (var button:Button in _buttons)
			{
				container.addChild(button);
			}
			addChild( container );
			
		}

		
		private function addAction( label:String, listener:Function ):void
		{
			var b:Button = new Button();
			b.label = label;
			b.addEventListener( starling.events.Event.TRIGGERED, listener );
			_buttons.push( b );
		}
		
		
	}
}