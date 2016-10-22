package SJ.Game.richtext
{
	import feathers.controls.Label;
	
	import starling.display.DisplayObject;
	import starling.display.Image;

	public class CJRichTextElementHelper
	{
		
		/**
		 * 将json转换为CJRTElement
		 * @param json
		 * @return 
		 * 
		 */		
		public static function JsonToElements(json:String):Array
		{
			var elementArray:Array = new Array();
			var jsonObj:Array = JSON.parse(json) as Array;
			var length:int = jsonObj.length;
			var element:CJRTElement;
			for(var i:int=0; i < length; i++)
			{
				switch(jsonObj[i].type)
				{
					case "animate":
						element = new CJRTElementAnimate();
						break;
					case "br":
						element = new CJRTElementBr();
						break;
					case "button":
						element = new CJRTElementButton();
						break;
					case "image":
						element = new CJRTElementImage();
						break;
					case "label":
						element = new CJRTElementLabel();
						break;
				}
				element.loadFromJsonObject(jsonObj[i]);
				elementArray.push(element);
			}
			return elementArray;
		}
		
		/**
		 * 将CJRTElement转换为json
		 * @param elementArray
		 * @return 
		 * 
		 */		
		public static function elementsToJson(elementArray:Array):String
		{
			var json:String = "";
			json += '[';
			var element:CJRTElement;
			for (var i:int = 0; i < elementArray.length; i++)
			{
				element = elementArray[i];
				json += element.getJson();
				if (i != (elementArray.length - 1))
				{
					json += ",";
				}
			}
			json += ']';
			return json;
		}
	}
}