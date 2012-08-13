/*-------------------------------------------------------------------------- 
 *
 *	ActionTools3 ActionScript Library
 *	(c) 2008-2009 Buzzware Solutions
 *
 *	ActionTools3 is freely distributable under the terms of an MIT-style license.
 *
 *--------------------------------------------------------------------------*/

package au.com.buzzware.actiontools4.code {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.filesystem.File;
import flash.net.URLRequest;

	import flash.display.Stage;
	import mx.styles.StyleManager;	

	public class GraphicsUtils {

		/*
		Set application width and height to 100% so the stage doesn't grow with content that 
		is unlimited, and can be reasonably captured for rendering purposes.
		Flash scrollbars will appear, which are virtually the same as browser ones anyway
		*/
		/*
		public static function CaptureStageBitmapData(): BitmapData {
			var s:Stage = Application.application.stage
			var result:BitmapData = new BitmapData(s.stageWidth,s.stageHeight,false)
			result.draw(s,null,null,flash.display.BlendMode.NORMAL)
			return result;
		}
		*/
		
		//public static function ColorFromString(aString: String, aDefault: String = '#000000'): uint {
		//	var result: uint = StyleManager.getColorName(aString);
		//	if (result == StyleManager.NOT_A_COLOR)
		//		result = StyleManager.getColorName(aDefault);
		//	return result;
		//}

		public static function randomLightColor(aRange: int = 64): int {
			var colText: int = 255-int(Math.random()*aRange)
			colText <<= 8
			colText |= 255-int(Math.random()*aRange)
			colText <<= 8
			colText |= 255-int(Math.random()*aRange)
			return colText
		}

		public static function randomDarkColor(aRange: int = 64): int {
			var colText: int = int(Math.random()*aRange)
			colText <<= 8
			colText |= int(Math.random()*aRange)
			colText <<= 8
			colText |= int(Math.random()*aRange)
			return colText
		}

		public static function loadBitmap(aUrl: String, aHandler: Function): void {
			var loader: Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event: Event): void {
				var li: LoaderInfo = event.target as LoaderInfo
				aHandler(Bitmap(li.content))
			});
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(event: Event): void {
				aHandler(event)
			})
			var req: URLRequest = new URLRequest(aUrl)
			loader.load(req)
		}
	}
}
