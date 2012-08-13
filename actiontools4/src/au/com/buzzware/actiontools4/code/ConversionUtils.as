package au.com.buzzware.actiontools4.code {
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;
import flash.utils.IDataInput;

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
				if (aValue is int)
					return aValue.toString();
				if (aValue is Number)
					return StringUtils.formatDecimals(Number(aValue),8);
				if (aValue is Date)
					return DateUtils.toW3C(aValue);
			break;
			case 'Date':
				if (aValue is Date)
					return aValue;
				if (aValue is int)
					return new Date(aValue);
				if (aValue is Number)
					return new Date(aValue);
				if (aValue is String)
					return DateUtils.parseW3C(aValue,-99999999,aDefault);
			break;
		}
		return aDefault;
	}

	public static function toInt(aValue:*,aDefault: int=0): int {
		return convertValueToTypeByName(aValue,'int',aDefault) as int
	}

	public static function toString(aValue:*,aDefault: String=null): String {
		return convertValueToTypeByName(aValue,'String',aDefault) as String
	}

	public static function toNumber(aValue: *,aDefault: Number=NaN): Number {
		return convertValueToTypeByName(aValue,'Number',aDefault) as Number
	}

	public static function toBoolean(aValue: *, aDefault: Boolean=false): Boolean {
		return convertValueToTypeByName(aValue,'Boolean',aDefault) as Boolean
	}

	public static function byteArrayFromDataInput(aData: IDataInput): ByteArray {
		var result: ByteArray = new ByteArray();
		aData.readBytes(result);
		result.position = 0
		return result
	}

	public static function byteArrayToFile(aImageBytes: ByteArray, aFile: File): File {
		var stream: FileStream = new FileStream()
		stream.open(aFile, FileMode.WRITE)
		stream.writeBytes(aImageBytes)
		stream.close()
		return aFile
	}

}

}
