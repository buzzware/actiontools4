/*-------------------------------------------------------------------------- 
 *
 *	ActionTools3 ActionScript Library
 *	(c) 2008-2009 Buzzware Solutions
 *
 *	ActionTools3 is freely distributable under the terms of an MIT-style license.
 *
 *--------------------------------------------------------------------------*/

package au.com.buzzware.actiontools4.code {
import au.com.buzzware.actiontools4.code.ReflectionUtils;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;

import mx.containers.ViewStack;
import mx.controls.Label;
import mx.core.Container;
import mx.core.UIComponent;
import mx.core.UITextField;
import mx.core.mx_internal;

public class ComponentUtils {
		public static function BringToFront(aDisplayObject: DisplayObject): void {
			if (!aDisplayObject.parent)
				return;
			aDisplayObject.parent.setChildIndex(aDisplayObject,aDisplayObject.parent.numChildren-1)
		}

		public static function SendToBack(aDisplayObject: DisplayObject): void {
			if (!aDisplayObject.parent)
				return;
			aDisplayObject.parent.setChildIndex(aDisplayObject,0)
		}

		public static function getChildIndexByName(aViewStack: ViewStack,aPageId: String): int {
			if (!aPageId || aPageId=='')
				return -1;
			var c:UIComponent = aViewStack.getChildByName(aPageId) as UIComponent
			return c ? aViewStack.getChildIndex(c) : -1
		}
		
		public static function getComponentChildByClass(
			aParent: UIComponent, 
			aClass: Class,
			aAfter: DisplayObject = null
		): DisplayObject {
			var i:int = 0;
			if (aAfter) {
				i = aParent.getChildIndex(aAfter);
				if (i==-1)
					return null;
				i++;
			}
			for (i;i<aParent.numChildren;i++) {
				var c: DisplayObject = aParent.getChildAt(i);
				if (c is aClass)
					return c;
			}
			return null;
		}
		
		public static function getComponentParentByClass(
			aComponent: UIComponent, 
			aClass: Class
		): DisplayObject {
			var result: DisplayObject = aComponent
			while (result = result.parent) {
				if (result is aClass)
					return result;
			}
			return null
		}
		
		public static function getComponentParentByClassName(
			aComponent: UIComponent, 
			aClassName: String
		): DisplayObject {
			var result: DisplayObject = aComponent
			while (result = result.parent) {
				if (ReflectionUtils.ClassName(result)==aClassName)
					return result;
			}
			return null
		}
		
		public static function setStyleOnChildByClass(
			aParent: UIComponent,
			aChildClass: Class, 
			aStyle: String,
			aValue: Object
		): void {			
			var c:UIComponent = ComponentUtils.getComponentChildByClass(aParent,aChildClass) as UIComponent;
			if (!c)
				return;
			c.setStyle(aStyle,aValue);
		}
		
		public static function getLabelUITextField(aLabel: Label): UITextField {
			use namespace mx_internal;
			return aLabel.mx_internal::getTextField() as UITextField;
		}

	public static function HideComponent(aComponent:UIComponent):UIComponent {
		var result:UIComponent = null
		var parent:DisplayObjectContainer = aComponent.parent
		parent.removeChild(aComponent);
		aComponent.visible = false;
		//aComponent.data.last_parent = parent
		return result;
	}

	public static function UnhideComponent(aComponent:UIComponent):void {
		throw new Error("Not yet implemented");
		//aComponent.visible = true;
		//var parent:DisplayObjectContainer = DisplayObjectContainer(aComponent.data.last_parent)
		//parent.addChild(aComponent);
	}

	public static function AttributeFromComponent(aComponent:Object, aNamePattern:Object):String {
		var name:String = UIComponent(aComponent).name;
		var re:RegExp = new RegExp(aNamePattern);
		var result:String = re.exec(name)[1]
		return result;
	}

	public static function NextDisplayObject(aDisplayObject:DisplayObject):DisplayObject {
		var iCurr:int = aDisplayObject.parent.getChildIndex(aDisplayObject)
		return (iCurr >= 0 && iCurr < aDisplayObject.parent.numChildren - 1) ? aDisplayObject.parent.getChildAt(iCurr + 1) : null;
	}


	// Gets recursive array of descendant controls for parent
		// The aArray argument is normally only used internally

	// from http://www.lucamarchesini.com/bRain/index.php?option=com_content&view=article&id=57:flex-recursive-getchildbyname&catid=38:entries&Itemid=67

	public static function getChildControlsRecursive(aParent:Container, aResult:Array = null):Array {
		var these:Array = aParent.getChildren()
		if (!aResult)
			aResult = [];
		for each (var c:DisplayObject in these) {
			aResult.push(c)
			if (c is Container)
				getChildControlsRecursive(c as Container, aResult);
		}
		return aResult
	}

	public static function getChildByNameRecursive(name:String, container:DisplayObjectContainer):DisplayObject {
		var child:DisplayObject = container.getChildByName(name);
		if (child)
			return child;
		for (var i:uint = 0; i < container.numChildren; i++) {
			if (container.getChildAt(i) is DisplayObjectContainer) {
				child = getChildByNameRecursive(name, container.getChildAt(i) as DisplayObjectContainer);
				if (child)
					return child;
			}
		}
		return child;
	}
}
}

