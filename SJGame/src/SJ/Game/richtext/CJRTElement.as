package SJ.Game.richtext
{
	import engine_starling.utils.SObjectUtils;
	
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObject;

	/**
	 * CJRichTextElement 基类
	 * @author sangxu
	 * 
	 */
	public class CJRTElement
	{
		/** 类型 */
		private var _type:String;
		/** 元素 - 控件属性 */
		protected var _property:Object;
		/** 文字 */
		protected var _text:String = "";
		/** 与前一元素x方向间隔 */
		protected var _spacex:int = 0;
		/** 与前一元素y方向间隔 */
		protected var _spacey:int = 0;
		/** 是否响应点击事件 */
		protected var _clickable:Boolean = false;
		/** 高度 */
		protected var _height:int = 16;
		/*附加到element的信息*/
		private var _data:Dictionary = new Dictionary();
		
		public function CJRTElement(type:String)
		{
			this._type = type;
			this._property = new Object();
			this._property.size = 12;
		}
		
		/**
		 * 获取基类属性json字符串
		 * @return 
		 * 
		 */		
		protected function getBaseAttrJson():String
		{
			var json:String = "";
			json += '"type":"' + this.type + '",';
			json += '"text":"' + this.text + '",';
			json += '"spacex":"' + this.spacex + '",';
			json += '"clickable":"' + this.clickable + '"';
			return json;
		}
		
		/**
		 * 获取property属性json字符串，由子类重载, 返回字符串最后一属性后不需要加逗号
		 * @return 
		 * 
		 */		
		protected function getPropertyJson():String
		{
			return "";
		}
		
		/**
		 * 返回对象json字符串
		 * @return 
		 * 
		 */		
		public function getJson():String
		{
			var json:String = "{";
			var propJson:String = getPropertyJson();
			json += propJson;
			if ("" != propJson)
			{
				json += ",";
			}
			json += getBaseAttrJson();
			json += "}";
			return json;
		}
		
		public function loadFromJsonObject(JsonObject:Object):CJRTElement
		{
			SObjectUtils.JsonObject2Object(JsonObject, this);
			return this;
		}
		
		/** setter */
		public function set spacex(value:int):void
		{
			this._spacex = value;
		}
		public function set spacey(value:int):void
		{
			this._spacey = value;
		}
		public function set text(value:String):void
		{
			this._text = value;
		}
		public function set clickable(value:Boolean):void
		{
			this._clickable = value;
		}
		public function set height(value:int):void
		{
			this._height = value;
		}
		
		/** getter */
		public function get type():String
		{
			return this._type;
		}
		public function get text():String
		{
			return this._text;
		}
		public function get spacex():int
		{
			return this._spacex;
		}
		public function get spacey():int
		{
			return this._spacey;
		}
		public function get clickable():Boolean
		{
			return this._clickable;
		}
		public function get height():int
		{
			return this._height;
		}
		public function get data():Dictionary
		{
			return _data;
		}
	}
}