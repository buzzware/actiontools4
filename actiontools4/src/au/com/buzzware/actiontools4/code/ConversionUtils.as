package au.com.buzzware.actiontools4.code {
import mx.utils.StringUtil;

public class ConversionUtils  {

	public static function convertValueToTypeByName(aValue: *, aToType: String, aDefault: * = null): * {
		switch (aToType) {
			case 'int':
				if (aValue is int)
					return aValue;
				if (aValue is Number)
					return int(aValue);
				if (aValue is String)
					return StringUtils.toInt(aValue,aDefault);
				if (aValue is Date)
					return int(Date(aValue).getTime());
			break;
			case 'Number':
				if (aValue is Number)
					return aValue;
				if (aValue is int)
					return Number(aValue);
				if (aValue is String)
					return StringUtils.toFloat(aValue,aDefault);
				if (aValue is Date)
					return Date(aValue).getTime();
			break;
			case 'Boolean':
				if (aValue is Boolean)
					return aValue;
				if (aValue is Number)
					return isNaN(Number(aValue)) ? aDefault : !!aValue;
				if (aValue is String)
					return StringUtils.toBoolean(aValue,aDefault);
				return !!aValue
			break;
			case 'String':
				if (aValue is String)
					return aValue;
				if (aValue is Number)
					return StringUtils.formatDecimals(Number(aValue),8);
				if (aValue is int)
					return aValue.toString();
				if (aValue is Date)
					return DateUtils.toW3C(aValue);
			break;
			case 'Date':
				if (aValue is Date)
					return aValue;
				if (aValue is Number)
					return new Date(aValue);
				if (aValue is int)
					return new Date(aValue);
				if (aValue is String)
					return DateUtils.parseW3C(aValue,-99999999,aDefault);
			break;
		}
		return aDefault;
	}

}

}
