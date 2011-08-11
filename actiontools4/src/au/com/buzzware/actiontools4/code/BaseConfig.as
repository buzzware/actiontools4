/*-------------------------------------------------------------------------- 
 *
 *	ActionTools3 ActionScript Library
 *	(c) 2008-2009 Buzzware Solutions
 *
 *	ActionTools3 is freely distributable under the terms of an MIT-style license.
 *
 *--------------------------------------------------------------------------*/

/*

	This is a base class for application configuration objects. It is deisgned to meet the following requirements :
	+ quick simple access to configuration fields. <Item> tags that don'e have a matching property defined are still 
	accesible as dynamic properties of this object as Strings eg. config.UndefinedValueA 
	+ ability to formally define properties for faster access and to enable Flex Builder code completion to display 
	available values.
	+ ability to give default values for properties should they not appear or are not parseable in config file.
	+ ability to define type of properties, for speed of execution and consistency when using config values. 
	eg. its no good a integer property haveing a null value.
	+ a standard XML format is assumed (see below)
	+ configuration values are by design, intended to be read-only. Configuration is the set of values that enable an 
	application binary to be used in different environments or different circumstances without recompilation. It is 
	seperate from the application data structures, which may get initialized from the configuration. By making this 
	read-only, the application variables can be restored to their default state from the original configuration.

<?xml version="1.0" encoding="utf-8"?>
<Config>
	<SimpleItems>
		<Item Name="MyString">dfsddsfsdfsd</Item>
		<Item Name="MyInteger">1</Item>
		<Item Name="MyNumber">1.27</Item>
		<Item Name="MyBoolean">ON</Item>
		<Item Name="UndefinedValueA">Hello there</Item>
	</SimpleItems>
</Config>

	+ potentially another type of item could be defined - xmlItem. Giving a tag name, it would look below <Config>
	for a tag with that name.
 */

package au.com.buzzware.actiontools4.code {

import au.com.buzzware.actiontools4.code.ObjectAndArrayUtils;

import flash.events.EventDispatcher;

public dynamic class BaseConfig extends EventDispatcher {

		protected var _valueCache: Object = new Object()
		protected var _simpleItemsXml: XML;
		protected var _simpleItemsObject: Object;
		protected var _capitalized: Boolean = false;
		protected var _basePath: String
		
		// pass in XML object or Object or BindableObject or string beginning with < or {
		public function BaseConfig(aSource: Object = null,aBasePath: String = null) {
			super()
			if ((aSource is XML) || ((aSource is String) && (aSource.charAt(0)=='<'))) {
				_basePath = (aBasePath==null ? 'simpleItems' : aBasePath)
				readXml(aSource as XML);
			} else if ((ReflectionUtils.getClassName(aSource)=='Object') || (aSource is BindableObject)) {
				readObject(aSource as Object);
			/*
			} else if ((aSource is String) && (aSource.charAt(0)=='{')) {
				readJsonObject(aSource as String);
			*/
			}
		}
		
		public function readObject(aSource: Object): void {
			_simpleItemsObject = (_basePath==null ? aSource : ObjectAndArrayUtils.getPathValue(aSource,_basePath))
			if (!_simpleItemsObject)
				return;
			ObjectAndArrayUtils.copy_properties(_valueCache,_simpleItemsObject)
		}

		/*
		public function readJsonObject(aSource: String): void {
			var jso: Object = JSON.decode(aSource)
			readObject(jso);
		}
		*/

		protected var _sourceXml: XML;
		public function readXml(aSource: XML): void {
			_sourceXml = aSource
			var name: String
			var val: String
			if (aSource) {
				_simpleItemsXml = XmlUtils.AsNode(aSource.simpleItems)
				if (_simpleItemsXml) {
					_capitalized = false;
				} else {
					_simpleItemsXml = XmlUtils.AsNode(aSource.SimpleItems)
					if (_simpleItemsXml)
						_capitalized = true;
				}
			}			
			if (_simpleItemsXml) {
				var items: XMLList;
				if (_capitalized)
					items = _simpleItemsXml.Item;
				else 
					items = _simpleItemsXml.item;
				for each(var i: XML in items) {
					name = (_capitalized ? i.@Name : i.@name);
					val = i.text()
					if (this.hasOwnProperty(name)) {
						_valueCache[name] = val
					}
				}
			}
		}
		
		public function get capitalized(): Boolean {
			return _capitalized;
		}

		public function stringItem(aName: String,aDefault: String = null,aEmptyAsDefault: Boolean = true): String {
			if (_valueCache[aName]==undefined)
				return _valueCache[aName] = aDefault
			var value: Object = _valueCache[aName]
			if (value && !(value is String))
				throw new Error("Internal Error: property _valueCache type conflict");
			var result: String = String(value)
			return aEmptyAsDefault && result=='' ? aDefault : result;
		}

		protected function urlItem(aName: String,aDefault: String = null,aEmptyAsDefault: Boolean = true): String {
			return HttpUtils.RemoveSlash(stringItem(aName,aDefault,aEmptyAsDefault));
		}

		public function floatItem(aName: String,aDefault: Number = NaN): Number {
			if (_valueCache[aName]==undefined)
				return _valueCache[aName] = aDefault
			var value: Object = _valueCache[aName]
			if (value is Number)
				return Number(value);
			else if (value is String)
				return _valueCache[aName] = StringUtils.toFloat(String(value),aDefault);
			else
				throw new Error("Internal Error: _valueCache["+aName+"] should be a String or Number");
		}

		public function intItem(aName: String,aDefault: int = 0): int {
			if (_valueCache[aName]==undefined)
				return _valueCache[aName] = aDefault
			var value: Object = _valueCache[aName]
			if (value is int)
				return int(value);
			else if (value is String)
				return _valueCache[aName] = StringUtils.toInt(String(value),aDefault);
			else
				throw new Error("Internal Error: _valueCache["+aName+"] should be a String or int");
		}
		
		public function booleanItem(aName: String,aDefault: Boolean = false): Boolean {
			if (_valueCache[aName]==undefined)
				return _valueCache[aName] = aDefault
			var value: Object = _valueCache[aName]
			if (value is Boolean)
				return value;
			else if (value is String)
				return _valueCache[aName] = StringUtils.toBoolean(String(value),aDefault);
			else
				throw new Error("Internal Error: _valueCache["+aName+"] should be a String or Boolean");
		}
		
		public function get root(): XML {
			return _sourceXml && XmlUtils.AsNode(_sourceXml as XML);	
		}
	}	
}
