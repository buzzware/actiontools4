package au.com.buzzware.actiontools4.code {

import au.com.buzzware.actiontools4.code.StringUtils;

import flash.utils.describeType;

import flash.utils.getDefinitionByName;

import flash.utils.getQualifiedClassName;
import flash.utils.getQualifiedSuperclassName;

import mx.core.mx_internal;
import mx.rpc.events.ResultEvent; use namespace mx_internal;	// should be last import

public class ReflectionUtils {
	private static var _dumpString:String = "";
	private static var _dumpIndent:String = "";

			public static function metadataForAttribute(aClass: Class,aAttribute: String,aDescribeTypeXml: XML=null): XMLList {
				if (!aDescribeTypeXml)
					aDescribeTypeXml = describeType(aClass);
				var q: XMLList = aDescribeTypeXml.factory.children().(name()=='accessor' || name()=='variable').(attribute('name')==aAttribute).metadata
				return q
			}

			public static function attributeHasMetadata(aClass: Class,aAttribute: String,aMetadataName: String,aDescribeTypeXml: XML=null): Boolean {
				if (!aDescribeTypeXml)
					aDescribeTypeXml = describeType(aClass);
				var metadatas: XMLList = metadataForAttribute(aClass,aAttribute,aDescribeTypeXml).(@name==aMetadataName)
				return metadatas.length()>0
			}

			public static function attributeMetadataValue(aClass: Class,aAttribute: String,aMetadataName: String,aMetadataKey: String,aDescribeTypeXml: XML=null): String {  //  class,'comment','Bindable','event')
				if (!aDescribeTypeXml)
					aDescribeTypeXml = describeType(aClass);
				var metadatas: XMLList = metadataForAttribute(aClass,aAttribute,aDescribeTypeXml).(@name==aMetadataName)
				var arg: XML = XmlUtils.AsNode(metadatas.arg.(@key==aMetadataKey))
				var result: String = XmlUtils.Attr(arg,'value') //metadatas.arg.(@key==aMetadataKey).@value
				return result
			}

			public static function getFieldsWithClassNames(aObject: Object, aDescribeType: XML = null): Object {

				var result: Object = new Object()
				var dt: XML = describeType(aObject)
				var x: XML
				var name: String
				var className: String
				// get <accessor> (name and type)
				var accessors: XMLList = dt.accessor
				for each (x in accessors) {
					name = XmlUtils.Attr(x,'name')
					className = XmlUtils.Attr(x,'type')
					result[name] = className
				}

				// get <variable>
				var variables: XMLList = dt.variable
				for each (x in variables) {
					name = XmlUtils.Attr(x,'name')
					className = XmlUtils.Attr(x,'type')
					result[name] = className
				}
				// get dynamic properties
				for (var n:String in aObject) {
					className = getQualifiedClassName(aObject[n])
					result[n] = className
				}

				return result
			}

			public static function getFieldType(aObject:Object, aFieldName:String):String {
				// !!! this could be greatly optimised, to just look for the field and exit
				var f:Object = getFieldsWithClassNames(aObject)
				return f[aFieldName]
			}

			public static function getFieldNames(aObject:Object, aDescribeType: XML = null):Array {
				var result: Array = new Array()
				var dt: XML = (aDescribeType || describeType(aObject))
				var x: XML
				var name: String
				var className: String
				// get <accessor> (name and type)
				var accessors: XMLList = dt.accessor
				for each (x in accessors) {
					name = XmlUtils.Attr(x,'name')
					result.push(name)
				}

				// get <variable>
				var variables: XMLList = dt.variable
				for each (x in variables) {
					name = XmlUtils.Attr(x,'name')
					result.push(name)
				}
				// get dynamic properties
				for (var n:String in aObject) {
					result.push(n)
				}

				return result.sort()
			}

			public static function copyAllFields(aDest:*, aSource:*):Object {
				ObjectAndArrayUtils.copy_properties(
					aDest,
					aSource,
					getFieldNames(aSource),
					['mx_internal_uid']
				)
				return aDest
			}

			public static function getClassName(aObject: Object): String {
				return shortName(getQualifiedClassName(aObject));
			}

			public static function getSuperclass(aClass: Class): Class {
				var nameSuper: String = getQualifiedSuperclassName(aClass);
				var classSuper: Class = getDefinitionByName(nameSuper) as Class;
				return classSuper;
			}

			public static function getClass(aObject: Object): Class {
				var name: String = getQualifiedClassName(aObject);
				var c: Class = getDefinitionByName(name) as Class;
				return c;
			}

			public static function getSuperclasses(aClass: Class): Array {
				var currClass: Class = aClass;
				var currName: String;
				var result: Array = [];

				result.push(currClass);
				while (currClass!=Object) {
					currClass = getSuperclass(currClass);
					result.push(currClass);
				}
				return result;
			}


		// like XPath - from aObject, follows path of properties if possible, and returns the value of the last property
		// If a property along the way doesn't exist, return the default value
		// If the last property has the value null, null is returned regardless of aDefault
		// eg. getPathValue(object,'a.b.c',false) returns false if b is null, but if a and b are objects, the value of c will be returned.
		// This provides a save way to query a tree of objects, and get back either a valid value or the default, but won't

	public static function superclassesAsString(aClass:Class, aShort:Boolean = false):String {
		var sc:Array = getSuperclasses(aClass);
		if (sc.length == 0)
			return null;
		sc = sc.map(
			function(c:*, i:int, a:Array):String {
				return aShort ? shortName(getQualifiedClassName(c)) : getQualifiedClassName(c);
			}
		);
		return sc.join(' > ');
	}

	public static function shortName(aName:String):String {
		// If there is a package, strip it off.
		var index:int = aName.indexOf("::");
		if (index != -1)
			aName = aName.substr(index + 2);
		var iLastDot:int = aName.lastIndexOf('.')
		if (iLastDot >= 0)
			aName = aName.substring(iLastDot + 1);
		return aName;
	}

	public static function ObjectToString(aObject:Object):String {
		return dump(aObject);
	}

	public static function TraceObject(aObject:Object):void {
		trace(ObjectToString(aObject))
	}

	internal static function getLength(o:Object):uint {
		var len:uint = 0;
		for (var item:* in o)
			len++;
		return len;
	}

	////////////////////////////////////////////////////////////////////////////////
	//
	//  Debug
	//  *****
	//
	//  Copyright (C) 2008 Andrei Ionescu
	//  http://www.flexer.info/
	//
	//  Permission is hereby granted, free of charge, to any person
	//  obtaining a copy of this software and associated documentation
	//  files (the "Software"), to deal in the Software without
	//  restriction, including without limitation the rights to use, misuse,
	//  copy, modify, merge, publish, distribute, love, hate, sublicense,
	//  and/or sell copies of the Software, and to permit persons to whom the
	//  Software is furnished to do so, subject to no conditions whatsoever.
	//
	//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
	//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
	//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
	//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
	//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
	//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
	//  OTHER DEALINGS IN THE SOFTWARE. DON'T SUE ME FOR SOMETHING DUMB
	//  YOU DO.
	//
	//  PLEASE DO NOT DELETE THIS NOTICE.
	//
	////////////////////////////////////////////////////////////////////////////////
	internal static function recursiveDump(o:Object, isInside:Boolean = true):String {
		// check if is not called by itself which means
		// is called from the first time and from here
		// it will be called recursivelly
		if (!isInside) {
			// reinitializing the static dump strings
			_dumpString = "";
			_dumpIndent = "";
		}

		// type of the object
		var type:String = typeof(o);
		// another way to get the type more accuratelly
		// used for display
		var className:String = getQualifiedClassName(o);
		// starting from here we create the dump string
		_dumpString += _dumpIndent + className;
		if (className == 'Date') {
			_dumpString += " = " + StringUtils.UniDateFormat(o as Date, 'null') + "\n";
		} else if (type == "string") {
			_dumpString += " (" + o.length + ") = \"" + o + "\"\n";
		} else if (type == "number") {
			_dumpString += " = " + o.toString() + "\n";
		} else if (type == "object") {
			_dumpString += " (" + getLength(o) + ")";
			_dumpString += " {\n";
			_dumpIndent += "    ";
			for (var i:Object in o) {
				_dumpString += _dumpIndent + "[" + i + "] => "; //\n";
				// recursive call
				// by default isInside parameter is true
				// so the dump string will NOT be reinitialized
				recursiveDump(o[i]);
			}
			_dumpIndent = _dumpIndent.substring(0, _dumpIndent.length - 4);
			_dumpString += _dumpIndent + "}\n";
		} else if (type == "date") {
			_dumpString += "(" + o + ")\n";
		}
		// returning the dump string
		return _dumpString;
	}


		// these two static variables will be emptied when
		// the method recursiveDump is called with false
		// as isInside parameter

		// static string that will contain the dump
		// static string that will contain the indent

		// internal function to get the number of children
		// from the object - getting only the first level

		// internal recursive dump method
		// called by dump

		// our dump function
		// using ...rest parameter to have at least one
		// parameter and accept as many as needed

	public static function dump(o:Object, ...rest):String {
		var tmpStr:String = "";
		var len:uint = rest.length;
		// call for the first parameter (object)
		tmpStr += recursiveDump(o, false);
		// if we have more than one parameter
		// at method call we display them
		if (len > 0) {
			// looping through the ...rest array
			for (var i:uint = 0; i < len; i++) {
				// call internal recursive dump
				tmpStr += recursiveDump(rest[i], false);
			}
		}
		return tmpStr;
	}

	public static function isSubclassOf(aChildClass:Class, aAncestorClass:Class):Boolean {
		return Boolean(aAncestorClass.prototype.isPrototypeOf(aChildClass.prototype));
	}

	public static function isObjectOfClass(aObject: Object, aClass: Class): Boolean {
		return isSubclassOf(getClass(aObject),aClass)
	}
}
}
