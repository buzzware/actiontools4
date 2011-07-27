/*-------------------------------------------------------------------------- 
 *
 *	ActionTools3 ActionScript Library
 *	(c) 2008-2009 Buzzware Solutions
 *
 *	ActionTools3 is freely distributable under the terms of an MIT-style license.
 *
 *--------------------------------------------------------------------------*/

package au.com.buzzware.actiontools4.code {
import au.com.buzzware.actiontools4.code.ReflectionUtils;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.ResizeEvent;
import mx.rpc.events.ResultEvent;

use namespace mx_internal;

public class EventUtils {

		public static function AddMultiListener(
			aTarget: IEventDispatcher,
			aEvents: Array,
			aHandler: Function, 
			use_capture:Boolean = false, 
			priority:int = 0, 
			weakRef:Boolean = false
		): void {
			for each (var e:* in aEvents) {
				aTarget.addEventListener(e,aHandler,use_capture,priority,weakRef);
			}
		}

	public static function EventToString(aEvent:Event):String {
		var tgt:Object = aEvent.target;
		var result:String = (tgt != null) ? ReflectionUtils.shortName(tgt.toString()) : 'null';
		result += ' ' + ReflectionUtils.getClassName(aEvent) + ' on '
		tgt = aEvent.currentTarget
		if (tgt)
			result += tgt == aEvent.target ? 'self' : ReflectionUtils.shortName(tgt.toString());
		else
			result += 'null';
		result += ' type=' + aEvent.type
		result += ' bubbles=' + aEvent.bubbles.toString()
		if (aEvent is ResultEvent) {
			if (ResultEvent(aEvent).result)
				result += "\n" + ResultEvent(aEvent).result.toString();
		}
		return result;
		//return MiscUtils.ClassName(aEvent)+': '+MiscUtils.ClassName(aEvent.currentTarget)+':"'+aEvent.currentTarget.id+'"'+' => '+aEvent.target;
	}

	public static function TraceEvent(aEvent:Event, aPrefix:String = null):void {
		var result:String = ''
		if (aPrefix)
			result += aPrefix
		result += EventToString(aEvent)
		trace(result)
	}

	public static function attachEventTracer(aTarget:IEventDispatcher = null, aPrefix:String = null):void {
		UIComponent.mx_internal::dispatchEventHook = function(aEvent:Event, aComponent:UIComponent):void {
			if (aTarget && (aComponent != aTarget))
				return;
			TraceEvent(aEvent, aPrefix);
		}
	}

	public static function callLater(aTime:Number, aHandler:Function):Timer {
		var result:Timer = new Timer(aTime);
		result.addEventListener(
			TimerEvent.TIMER,
			function(aEvent:Event):void {
				result.stop()
				result.removeEventListener(TimerEvent.TIMER, arguments.callee);
				aHandler(aEvent)
			}
		)
		result.start()
		return result;
	}

	public static function addOnceListener(aTarget:IEventDispatcher, aEventType:String, aEventHandler:Function):void {
		aTarget.addEventListener(
			aEventType,
			function(aEvent:Event):void {
				aTarget.removeEventListener(aEventType, arguments.callee)
				aEventHandler(aEvent)
			}
		)
	}

	// aTime is in milliseconds
	// aHandler is like function(aEvent: TimerEvent): Boolean {} and is called until it returns true
	public static function callUntil(aTime:Number, aHandler:Function):Timer {
		var result:Timer = new Timer(aTime);
		result.addEventListener(
			TimerEvent.TIMER,
			function(aEvent:TimerEvent):void {
				if (!result.running)
					return;
				var stop:Boolean = aHandler(aEvent)
				if (stop) {
					result.stop()
					result.removeEventListener(TimerEvent.TIMER, arguments.callee);
				}
			}
		)
		result.start()
		return result;
	}
}
}
