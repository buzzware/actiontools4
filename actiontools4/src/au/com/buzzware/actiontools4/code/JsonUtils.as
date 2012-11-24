package au.com.buzzware.actiontools4.code {
public class JsonUtils {

	public static function jsonDecode(aString: String): * {
		if (!aString || aString == '')
			return null;
		try {
			//return com.adobe.serialization.json.JSON.decode(aString) || null
			return JSON.parse(aString, function (aKey: String, aValue: *): * {
				if (((typeof(aValue) == 'number') && isNaN(aValue)) || (aValue === undefined))
					return null;
				else
					return aValue;
			})
		} catch (e: Error) {
			return e
		}
		return null
	}

	public static function jsonEncode(aInput: *): String {
		return JSON.stringify(aInput, function (aKey: String, aValue: *): * {
			if (((typeof(aValue) == 'number') && isNaN(aValue)) || (aValue === undefined))
				return null;
			else
				return aValue;
		})
	}

}
}
