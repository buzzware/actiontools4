package au.com.buzzware.actiontools4.code {

import au.com.buzzware.actiontools4.air.FileUtils;
import au.com.buzzware.actiontools4.code.XmlUtils;

import flash.filesystem.File;

public class BaseConfig2 extends BindableObject {

	protected var _file: File;
	protected var _rootName: String;

	public function mergeProperties(aObject: *): void {
		var sourceFields: Object = ReflectionUtils.getFieldsWithClassNames(aObject)
		var destFields: Object = ReflectionUtils.getFieldsWithClassNames(this)
		for (var f:* in sourceFields) {
			var v: * = aObject[f]
			if (destFields.hasOwnProperty(f))
				v = ConversionUtils.convertValueToTypeByName(v, destFields[f]);
			this[f] = v
		}
	}

	public function readDynamicProperties(aSimpleItems:Object):BaseConfig2 {
		var destFields: Object = ReflectionUtils.getFieldsWithClassNames(this)
		for (var f:* in aSimpleItems) {
			var v: * = aSimpleItems[f]
			if (destFields.hasOwnProperty(f))
				v = ConversionUtils.convertValueToTypeByName(v, destFields[f]);
			this[f] = v
		}
		return this
	}

	public function readFile(aFileOrName:Object, aKeep: Boolean = true): void {
		aFileOrName = FileUtils.toFile(aFileOrName)
		if (aKeep)
			_file = aFileOrName as File;
		var xSimpleItems:XML = XmlUtils.getFileXml(aFileOrName,'simpleItems');
		if (xSimpleItems) {
			var root: XML = XmlUtils.upToRoot(xSimpleItems)
			if (aKeep && root)
				_rootName = root.name();
			var oSimpleItems:Object = XmlUtils.getSimpleItemsObject(xSimpleItems);
			readDynamicProperties(oSimpleItems)
		}
	}

	public function writeFile(aFileOrName: Object = null, aRootTag: String = null): void {
		if (!aFileOrName) {
			if (!_file)
				throw new Error('Config: no file supplied to write to');
			aFileOrName = _file
		}
		if (!aRootTag) {
			aRootTag = _rootName || 'config'
		}
		var file: File = FileUtils.toFile(aFileOrName)
		XmlUtils.objectToXmlConfigFile(this,aRootTag,file)
	}

}
}
