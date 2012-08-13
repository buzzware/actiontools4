package au.com.buzzware.actiontools4.code {
import mx.rpc.IResponder;

public class MonoResponder implements IResponder {

	public var handler:Function;

	public function MonoResponder(aHandler:Function)
	{
			super();
			handler = aHandler;
	}

	public function result(data:Object):void {
		if (handler!=null)
			handler(data);
	}

	public function fault(info:Object):void {
		if (handler!=null)
			handler(info);
	}
    
}


}