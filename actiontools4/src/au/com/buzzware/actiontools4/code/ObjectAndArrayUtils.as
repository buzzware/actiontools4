/**
 * Created by IntelliJ IDEA.
 * User: gary
 * Date: 13/06/11
 * Time: 7:57 PM
 * To change this template use File | Settings | File Templates.
 */
package au.com.buzzware.actiontools4.code {
public class ObjectAndArrayUtils {
	public function ObjectAndArrayUtils() {
	}

	public static function cloneArray(aArray:Array):Array {
		return aArray.map(function(e:*, ...r):* {
			return e
		});
	}

	// find all dynamic objects in an array that have matching values for the contents of aAndCriteria
	public static function ObjectArrayFind(aArray:Array, aAndCriteria:Object):Array {
		return aArray.filter(
			function(item:*, index:int, array:Array):Boolean {
				// for all items in aAndCriteria, aItem has matching values
				for (var i:String in aAndCriteria) {
					if (aAndCriteria[i] != item[i])
						return false;
				}
				return true;
			}
		);
	}

	public static function ObjectArrayFindIndex(aArray:Array, aAndCriteria:Object):int {
		return ArrayFindIndex(
			aArray,
			function(item:Object):Boolean {
				if (!item)
					return false;
				for (var i:String in aAndCriteria) {
					if (aAndCriteria[i] != item[i])
						return false;
				}
				return true;
			}
		)
	}

	// like ObjectArrayFind except only returns one object. Could be optimised to quit searching when one is found
	// adds listener and removes on first occurrence
	public static function ObjectArrayFindOne(aArray:Array, aAndCriteria:Object):Object {
		var results:Array = ObjectArrayFind(aArray, aAndCriteria);
		return results[0];
	}

	public static function ObjectArrayLookup(aArray:Array, aAndCriteria:Object, aProperty:String):Object {
		var results:Array = ObjectArrayFind(aArray, aAndCriteria);
		var item:Object = results[0];
		if (!item)
			return null;
		return item[aProperty];
	}

	public static function ObjectArrayExtractPropertyValues(aArray:Array, aProperty:String, aAndCriteria:Object = null):Array {
		var items:Array = (aAndCriteria ? ObjectArrayFind(aArray, aAndCriteria) : aArray)
		var results:Array = new Array()
		for each (var i:Object in items)
			results.push(i[aProperty]);
		return results
	}

	public static function ArrayFindFirst(aArray:Array, aCriteria:Function):Object {
		for each (var i:Object in aArray) {
			if (aCriteria(i))
				return i;
		}
		return null;
	}

	public static function ArrayFindIndex(aArray:Array, aCriteria:Function):int {
		var i:int;
		for (i = 0; i < aArray.length; i++) {
			if (aCriteria(aArray[i]))
				return i;
		}
		return -1;
	}

	/**
	 * Merge a number of arrays.
	 *
	 * N.B: This method does not return an array with unique values.
	 *
	 * @return array
	 */
	public static function mergeArrays(...args):Array {
		var retArr:Array = new Array();
		for each (var arg:* in args) {
			if (arg is Array) {
				for each (var value:* in arg) {
					retArr.push(value);
				}
			}
		}
		return retArr;
	}

	public static function getPathValue(aObject:Object, aPath:String, aDefault:* = null):* {
		var nodes:Array = aPath.split('.')
		var curr:* = aObject
		for each (var name:String in nodes) {
			if (curr == null)
				return aDefault;
			if (curr.hasOwnProperty(name)) {
				curr = curr[name];
			} else {
				return aDefault;		// name doesn't exist
			}
		}
		return curr
	}

	// merges dynamic properties of aSource into aDest and returns the result
	public static function merge_dynamic_properties(aDest:Object, aSource:Object, aOverwrite:Boolean = true):Object {
		if (aDest == null)
			return clone_dynamic_properties(aSource);
		if (aSource == null)
			return clone_dynamic_properties(aDest);

		var result:Object = clone_dynamic_properties(aDest);
		merge_dynamic_properties_inplace(result, aSource, aOverwrite);
		return result
	}

	public static function merge_dynamic_properties_inplace(aDest:Object, aSource:Object, aOverwrite:Boolean = true):Object {
		for (var p:String in aSource) {
			if (aOverwrite || (aDest[p] == undefined || aDest[p] == null))
				try {
					aDest[p] = aSource[p];
				}
				catch(e:Error) {
					// do nothing
				}

		}
		return aDest;
	}

	public static function copy_properties(aDest:Object, aSource:Object, aProperties:Array = null, aExceptProperties:Array = null):Object {
		if (!aProperties && !aExceptProperties)
			return merge_dynamic_properties_inplace(aDest, aSource);
		if (!aProperties)
			aProperties = getDynamicPropertyNames(aSource);

		for each (var p:String in aProperties) {
			if (aExceptProperties && (aExceptProperties.indexOf(p) != -1))
				continue;
			try {
				aDest[p] = aSource[p];
			}
			catch(e:Error) {
				// do nothing
			}
		}
		return aDest;
	}

	public static function firstDynamicPropertyName(aObject:Object):String {
		for (var p:String in aObject)
			return p;
		return null;
	}

	public static function createEmptyClone(aObject:*):* {
		var klass:Class = ReflectionUtils.getClass(aObject)
		return new klass()
	}

	public static function deleteProperty(aObject:Object, aProperty:*):* {
		var result:* = aObject[aProperty]
		delete aObject[aProperty]
		return result
	}

	public static function DynamicPropertiesToString(aObject:Object, aNewLines:Boolean = true):String {
		var result:String = ''
		for (var p:String in aObject) {
			result += p + ": " + aObject[p] + (aNewLines ? "\n" : '');
		}
		return result
	}

	public static function TraceDynamicProperties(aObject:Object, aNewLines:Boolean = true, aPrefix:String = null):void {
		var result:String = ''
		if (aPrefix)
			result += aPrefix + (aNewLines ? '\n' : '')
		result += DynamicPropertiesToString(aObject)
		trace(result)
	}

	public static function clone_dynamic_properties(aSource:Object):Object {
		if (aSource == null)
			return {};
		var result:Object = {}
		for (var p:String in aSource)
			result[p] = aSource[p];
		return result
	}

	public static function getDynamicPropertyNames(aObject:Object):Array {
		var result:Array = [];
		for (var n:String in aObject)
			result.push(n);
		return result;
	}

	public static function arrayRemove(aArray:Array, aItem:*): void {
		var i: int = aArray.indexOf(aItem)
		if (i>=0)
			aArray.splice(i, 1)
	}

	// returns properties from source object with values within aAllowed
	public static function selectPropertiesByValues(aObject: Object,aAllowed: Array): Object {
		var result: Object = new Object()
		for (var p:String in aObject) {
			if (aAllowed.indexOf(aObject[p])>=0)
				result[p] = aObject[p];
		}
		return result
	}

	public static function propertyNamesWithValues(aObject:Object, aAllowed:Array):Array {
		var result: Array = new Array()
		for (var p:String in aObject) {
			if (aAllowed.indexOf(aObject[p])>=0)
				result.push(p);
		}
		return result
	}

	public static function isSimpleObject(aObject:Object): Boolean {
		if (!aObject)
			return false;
		var cn: String = ReflectionUtils.getClassName(aObject)
		if (!cn)
			return false;
		return (cn=='Object') || (cn=='BindableObject')
	}

}
}
