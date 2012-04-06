package au.com.buzzware.actiontools4.code {
import mx.rpc.IResponder;

public class SafeResponder implements IResponder {

	public var resultHandler:Function;
	public var faultHandler:Function;

	public function SafeResponder(result:Function, fault:Function)
	{
			super();
			resultHandler = result;
			faultHandler = fault;
	}

	public function result(data:Object):void {
		if (resultHandler!=null)
			resultHandler(data);
	}

	public function fault(info:Object):void {
		if (faultHandler!=null)
			faultHandler(info);
	}
    
}


}