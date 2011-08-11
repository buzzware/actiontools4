package au.com.buzzware.actiontools4.code{
	import au.com.buzzware.actiontools4.code.ObjectAndArrayUtils;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.events.DynamicEvent;
	import mx.rpc.IResponder;

	/*
	
	From http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/events/DynamicEvent.html :
	
	"
	This subclass of Event is dynamic, meaning that you can set arbitrary event properties on its instances at runtime.
	By contrast, Event and its other subclasses are non-dynamic, meaning that you can only set properties that are declared 
	in those classes. When prototyping an application, using a DynamicEvent can be easier because you don't have to write an 
	Event subclass to declare the properties in advance. However, you should eventually eliminate your DynamicEvents and write 
	Event subclasses because these are faster and safer. A DynamicEvent is so flexible that the compiler can't help you catch 
	your error when you set the wrong property or assign it a value of an incorrect type.
	
	Example:
	
		var event:DynamicEvent = new DynamicEvent("credentialsChanged");
		event.name = name;
		event.passsword = password; // misspelling won't be caught!
		dispatchEvent(event);
	"

	DynamicResponderEvent is a DynamicEvent that also serves as an IResponder. That means the same object used to 
	make a request also holds the front line response and failure handlers, which also means that the 
	code that gets the data doesn't have any dependency on the class that receives it. 
		
	Custom Event classes may also descend from DynamicResponderEvent and add custom fields.
	
	Also see ResponderEvent
	*/
	
	public dynamic class DynamicResponderEvent extends DynamicEvent implements IResponder
	{
		public var kind: String
		public var resultHandler: Function
		public var faultHandler: Function
		
		public function DynamicResponderEvent(type:String,bubbles:Boolean=true, cancelable:Boolean=true)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			var result: DynamicResponderEvent = new DynamicResponderEvent(type, bubbles, cancelable);
			result.kind = this.kind
			result.resultHandler = this.resultHandler
			result.faultHandler = this.faultHandler
			ObjectAndArrayUtils.merge_dynamic_properties_inplace(result,this)
			return result
		}
		
		public function result(aData:Object):void {
			if (resultHandler != null)
				resultHandler(aData);
		}
		
		public function fault(aData:Object):void {
			if (faultHandler != null)
				faultHandler(aData);
		}
		
		/*
		examples :
		1) dispatchAndRespond(this,'calculations','superPremium',resultHandler,faultHandler,{field1: 123, field2: 456})
		2) 	e = dispatchAndRespond(null,'calculations','superPremium')
				e.resultHandler = function(aEvent: Event): void {}
				e.field1 = 123
				e.field2 = 456
				dispatch(e)
		*/

		public static function dispatchAndRespond(
			aTarget: IEventDispatcher,					// if null, won't dispatch, so dispatch it yourself
			aType: String,
			aKind: String,
			aResultHandler: Function = null,
			aFaultHandler: Function = null,
			aDynamicValueObject: Object = null	// if supplied, _only_ dynamic properties will be copied from this to the event
		): DynamicResponderEvent {
			var result:DynamicResponderEvent = new DynamicResponderEvent(aType, true, true);
			result.kind = aKind;
			result.resultHandler = aResultHandler;
			result.faultHandler = aFaultHandler;
			if (aDynamicValueObject)
				ObjectAndArrayUtils.merge_dynamic_properties_inplace(result, aDynamicValueObject)			
			if (aTarget)
				aTarget.dispatchEvent(result);
			return result;
		}
		
	}
}