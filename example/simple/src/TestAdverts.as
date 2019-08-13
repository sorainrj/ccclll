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
 * This is a test application for the distriqt extension
 * 
 * @author Michael Archbold & Shane Korin
 * 	
 */
package
{
	import com.distriqt.extension.adverts.AdSize;
	import com.distriqt.extension.adverts.AdView;
	import com.distriqt.extension.adverts.AdViewParams;
	import com.distriqt.extension.adverts.AdvertPlatform;
	import com.distriqt.extension.adverts.Adverts;
	import com.distriqt.extension.adverts.builders.AdRequestBuilder;
	import com.distriqt.extension.adverts.builders.AdViewParamsBuilder;
	import com.distriqt.extension.adverts.events.AdViewEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	
	/**	
	 * Sample application for using the Adverts Native Extension
	 */
	public class TestAdverts extends Sprite
	{
		public static var APP_KEY : String = "APPLICATION_KEY";
		
		
		public static var admob_accountId:String = "";
		
		// TEST IDS
		public static var admob_android_adUnitId_banner : String = "ca-app-pub-3940256099942544/6300978111";
		public static var admob_ios_adUnitId_banner : String = "ca-app-pub-3940256099942544/2934735716";
		
		/**
		 * Class constructor 
		 */	
		public function TestAdverts()
		{
			super();
			create();
			init();
		}
		
		
		//
		//	VARIABLES
		//
		
		private var _adUnitId				: String;
		private var _text					: TextField;
		
		
		//
		//	INITIALISATION
		//	
		
		private function create( ):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			var tf:TextFormat = new TextFormat( "_typewriter", 16 );
			_text = new TextField();
			_text.defaultTextFormat = tf;
			_text.y = 40;
			addChild( _text );

			stage.addEventListener( Event.RESIZE, stage_resizeHandler, false, 0, true );
			stage.addEventListener( MouseEvent.CLICK, stage_clickHandler, false, 0, true );
		}
		
		
		private function init( ):void
		{
			try
			{
				message( "Adverts Supported:       " + Adverts.isSupported );
				message( "Adverts Version:         " + Adverts.service.version );
				
				message( "ADMOB Supported:         " + Adverts.service.isPlatformSupported( AdvertPlatform.PLATFORM_ADMOB ) );
				
				if (Adverts.isSupported)
				{
					if (Adverts.service.isPlatformSupported( AdvertPlatform.PLATFORM_ADMOB ))
					{
						message( "Initialising ADMOB" );
						
						if (Adverts.service.implementation == "Android")
						{
							_adUnitId = admob_android_adUnitId_banner;
						}
						else
						{
							_adUnitId = admob_ios_adUnitId_banner;
						}
						
						Adverts.service.initialisePlatform( AdvertPlatform.PLATFORM_ADMOB, admob_accountId );
					}
					else
					{
						message( "No platform supported" );
					}
				}
				else
				{
					message( "Not supported..." );
				}
			}
			catch (e:Error)
			{
				message( e.message );
			}
		}
		
		
		//
		//	FUNCTIONALITY
		//
		
		private function message( str:String ):void
		{
			trace( str );
			_text.appendText(str+"\n");
		}
		
		
		//
		//	EVENT HANDLERS
		//
		
		private function stage_resizeHandler( event:Event ):void
		{
			_text.width  = stage.stageWidth;
			_text.height = stage.stageHeight - 100;
		}
		
		
		private var _stage:int = 0;
		private var _adView:AdView;
		private function stage_clickHandler( event:MouseEvent ):void
		{
			if (Adverts.isSupported)
			{
				try
				{
					switch(_stage)
					{
						case 0:
						{
							message("show");
							_adView = Adverts.service.createAdView();
							_adView.setAdUnitId( _adUnitId );
							_adView.setAdSize( AdSize.SMART_BANNER );
							_adView.setViewParams( new AdViewParamsBuilder()
									.setVerticalAlign( AdViewParams.ALIGN_BOTTOM )
									.setHorizontalAlign( AdViewParams.ALIGN_CENTER )
									.build()
							);
							
							_adView.addEventListener( AdViewEvent.LOADED, adverts_receivedAdHandler );
							_adView.addEventListener( AdViewEvent.ERROR, adverts_errorHandler );
							_adView.load(
									new AdRequestBuilder()
											.addTestDevice( "c535ffba308207409d140138c8991c8b" )
											.build()
							);
							_adView.show();
							break;
						}
						
						case 1:
						{
							message( "refresh" );
							_adView.load( new AdRequestBuilder().build() );
							break;
						}
							
						case 2:
						{
							message( "destroy" );
							_adView.removeEventListener( AdViewEvent.LOADED, adverts_receivedAdHandler );
							_adView.removeEventListener( AdViewEvent.ERROR, adverts_errorHandler );
							_adView.destroy();
							_adView = null;
							break;
						}

						default:
							_stage = 0;
							return;
							
					}
				}
				catch (e:Error)
				{
					message( "ERROR::"+e.message );
				}
				_stage ++; 
			}
		}
		
		
		//
		//	EXTENSION LISTENERS
		//

		private function adverts_receivedAdHandler( event:AdViewEvent ):void
		{
			message( "adverts_receivedAdHandler" );
		}
		
		private function adverts_errorHandler( event:AdViewEvent ):void
		{
			message( "adverts_errorHandler:: " + event.errorCode );
		}
		
		
	}
	
}

