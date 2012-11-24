/*-------------------------------------------------------------------------- 
 *
 *	ActionTools3 ActionScript Library
 *	(c) 2008-2009 Buzzware Solutions
 *
 *	ActionTools3 is freely distributable under the terms of an MIT-style license.
 *
 *--------------------------------------------------------------------------*/

package au.com.buzzware.actiontools4.code {
	import br.com.stimuli.string.printf;
	
	import com.adobe.utils.DateUtil;

import mx.formatters.DateFormatter;

public class DateUtils {

	public static const msSecond:int = 1000;
	public static const msMinute:int = 1000 * 60;
	public static const msHour:int = 1000 * 60 * 60;
	public static const msDay:int = 1000 * 60 * 60 * 24;
		
		public static function difference(aDate1: Date, aDate2: Date): Number {
			return aDate2.time - aDate1.time
		}

		public static function addDays(aDate: Date,aDays: Number): Date {
			return new Date(aDate.getTime() + (aDays*msDay));
		}
		
		public static function addSeconds(aDate: Date,aSeconds: Number): Date {
			return new Date(aDate.getTime() + (aSeconds*1000));
		}
		
		public static function daysDifference(aDate1: Date, aDate2: Date): int {
			//var diff: Number = aDate2.time - aDate1.time
			return Math.floor((aDate2.time - aDate1.time)/msDay); 		
		}
		
		public static function millisecondsDifference(aDate1: Date, aDate2: Date): Number {
			return Math.floor(aDate2.time - aDate1.time);
		}

		public static function secondsDifference(aDate1: Date, aDate2: Date): int {
			return Math.floor((aDate2.time - aDate1.time)/msSecond);
		}

		public static function millisecondsSince(aDate: Date): Number {
			return millisecondsDifference(aDate,new Date())
		}

		public static function secondsSince(aDate: Date): Number {
			return secondsDifference(aDate,new Date())
		}

		public static function today(): Date {
			var result:Date = new Date();
			return new Date(result.fullYear,result.month,result.date);
		}
		
		public static function equals(aDate1: Date, aDate2: Date): Boolean {
			if (aDate1==null && aDate2==null)
				return true;
			if (aDate1==null || aDate2==null)
				return false;
			return (aDate1.getTime() == aDate2.getTime());
		}
		
		// year must be 4 digit, month must be 0-11
		public static function daysInMonth(aYear: int, aMonth: int): int {
			var d:Date = new Date(aYear, (aMonth+1)%12, 0);
			return d.date;
		}

		public static function parseW3C(
			aString: String, 		// a W3C date, with/without time eg. 1994-11-05T13:15:30Z, 1994-11-05T08:15:30-05:00 or 1994-11-05
			aTimezoneMinutes: int = -99999999,	// the timezone to use if not supplied, in minutes. eg Perth (+8 hours) would be 480 
			aDefault: Date = null	// default value to use if cannot parse
		): Date {
			if (aTimezoneMinutes==-99999999)
				aTimezoneMinutes = localTimezoneMinutes();
			try {
				return DateUtil.parseW3CDTF(aString)				
			}
			catch(error:Error) {
				if (aString && (aString.search(/^[0-9\-]+$/)==0))
					aString += 'T'+'00:00:00';
				if (aString && (aString.search(/T[0-9:]+$/)>=0))
					aString += W3CTimezone(aTimezoneMinutes);
				return parseW3C(aString,aTimezoneMinutes,aDefault)
			}
			return aDefault
		}

		public static function toW3C(aDate: Date, aTimezoneMinutes: int = -99999999, aIncludeMilliseconds: Boolean = false): String {
			if (!aDate)
				return null;
			if (aTimezoneMinutes==-99999999)
				aTimezoneMinutes = localTimezoneMinutes();
			var date: Date = new Date(aDate.time + aTimezoneMinutes*60000)
			var ms: String = aIncludeMilliseconds ? printf('.%03d',date.millisecondsUTC) : ''
			var tz: String = W3CTimezone(aTimezoneMinutes)
			var result: String = printf(
				'%02d-%02d-%02dT%02d:%02d:%02d',
				date.fullYearUTC,date.monthUTC+1,date.dateUTC,date.hoursUTC,date.minutesUTC,date.secondsUTC
			)+ms+tz;
			return result
		}

		public static function toW3CSimpleDate(aDate: Date, aTimezoneMinutes: int = -99999999): String {
			if (!aDate)
				return null;
			if (aTimezoneMinutes==-99999999)
				aTimezoneMinutes = localTimezoneMinutes();
			var date: Date = new Date(aDate.time + aTimezoneMinutes*60000)
			var result: String = printf(
				'%02d-%02d-%02d',
				date.fullYearUTC,date.monthUTC+1,date.dateUTC
			)
			return result
		}

		public static function toUniversal(aDate: Date, aTimezoneMinutes: int = -99999999): String {
			if (!aDate)
				return null;
			if (aTimezoneMinutes==-99999999)
				aTimezoneMinutes = localTimezoneMinutes();
			var date: Date = new Date(aDate.time + aTimezoneMinutes*60000)
			/*
			var result: String = printf(
				'%02d-%02d-%02d',
				date.fullYearUTC,date.monthUTC+1,date.dateUTC
			)
			*/
			var df: DateFormatter = new DateFormatter()
			df.formatString = "D MMM YYYY"
			var result: String = df.format(date)
			return result
		}		
		
		public static function parseW3CLocal(aString: String, aDefault: Date = null): Date {
			if (!aString)
				return aDefault;
			return parseW3C(aString,localTimezoneMinutes(),aDefault)
		}

		public static function parseW3CUTC(aString: String, aDefault: Date = null): Date {
			return parseW3C(aString,0,aDefault)
		}

		public static function localTimezoneMinutes(): int {
			return -(new Date()).timezoneOffset
		}
		
		public static function W3CTimezone(aTimezoneMinutes: int): String {
			var result: String = (aTimezoneMinutes >= 0 ? '+' : '')
			result += printf('%02d:%02d',(aTimezoneMinutes/60),(aTimezoneMinutes%60))
			return result			
		}
		
		public static function localW3CTimezone(): String {
			return W3CTimezone(localTimezoneMinutes())
		}

	}
}