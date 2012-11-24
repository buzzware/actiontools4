/**
 * Created with IntelliJ IDEA.
 * User: gary
 * Date: 13/08/12
 * Time: 9:50 PM
 * To change this template use File | Settings | File Templates.
 */
package au.com.buzzware.actiontools4.air {
import au.com.buzzware.actiontools4.code.JsonUtils;

import flash.data.EncryptedLocalStore;
import flash.utils.ByteArray;

public class EncryptedLocalStore2 extends EncryptedLocalStore {

	public static function setAsJson(aName: String, aValue: *): void {
		var s: String = JsonUtils.jsonEncode(aValue)
		setString(aName,s)
	}

	public static function getAsJson(aName: String): * {
		var s: String = getString(aName)
		return JsonUtils.jsonDecode(s)
	}

	public static function setString(aName: String, aValue: String): void {
		var bytes:ByteArray = new ByteArray();
		bytes.writeUTFBytes(aValue);
		EncryptedLocalStore.setItem(aName, bytes);
	}

	public static function getString(aName: String): String {
		var storedValue:ByteArray = EncryptedLocalStore.getItem(aName)
		if (!storedValue)
			return null;
		return storedValue.readUTFBytes(storedValue.length)
	}

}
}
