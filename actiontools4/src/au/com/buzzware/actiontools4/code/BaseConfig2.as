package au.com.buzzware.actiontools4.code {

public class BaseConfig2 extends BindableObject {

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
}
}
