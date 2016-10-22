package lib.engine.ui.data.controls
{
	import lib.engine.iface.IPackage;
	import lib.engine.utils.CObjectUtils;
	import lib.engine.utils.CPackUtils;

	public dynamic class XDG_UI_Data implements IPackage
	{
		public static const TYPE:String = "TYPE_XDG_UI_Data";
		protected var _name:String;

		/**
		 * 控件名称 
		 */
		public function get name():String
		{
			return _name;
		}

		/**
		 * @private
		 */
		public function set name(value:String):void
		{
			_name = value;
		}

		
		protected var _type:String;

		/**
		 * 控件类型
		 * @param value
		 * 
		 */
		public function set type(value:String):void
		{
			
			_type = value;
		}


		/**
		 * 控件类型，目前只有BUTTON 
		 */
		public function get type():String
		{
			return _type;
		}

		/**
		 * @private
		 */
		
		protected var _x:int;

		/**
		 * x 
		 */
		public function get x():int
		{
			return _x;
		}

		/**
		 * @private
		 */
		public function set x(value:int):void
		{
			_x = value;
		}

		protected var _y:int;

		/**
		 * y 
		 */
		public function get y():int
		{
			return _y;
		}

		/**
		 * @private
		 */
		public function set y(value:int):void
		{
			_y = value;
		}

		protected var _width:int;

		/**
		 * 宽 
		 */
		public function get width():int
		{
			return _width;
		}

		/**
		 * @private
		 */
		public function set width(value:int):void
		{
			_width = value;
		}

		protected var _height:int;

		/**
		 * 高 
		 */
		public function get height():int
		{
			return _height;
		}

		/**
		 * @private
		 */
		public function set height(value:int):void
		{
			_height = value;
		}

		
		public function XDG_UI_Data(mtype:String)
		{
			_type = mtype;
			//this["testProperty"] = "";
		}
		
		//相对深度，值越小，越靠下，越大越靠上
		protected var _depth:int = -1;

		/**
		 * 相对深度，值越小，越靠下，越大越靠上
		 * @return 
		 * 
		 */
		public function get depth():int
		{
			return _depth;
		}

		public function set depth(value:int):void
		{
			_depth = value;
		}
		
		
		protected var _tooltip:String;

		public function get tooltip():String
		{
			return _tooltip;
		}

		public function set tooltip(value:String):void
		{
			_tooltip = value;
		}
		
		

		

				
		
		public function Pack():Object
		{
			var obj:Object = new Object();
			CPackUtils.PacktoObject(this,obj,false);
			return obj;
		}
		
		public function UnPack(obj:Object):void
		{
			CPackUtils.UnPackettoObject(obj,this,true);

			
		}
		
		public function clone():XDG_UI_Data
		{
			return CObjectUtils.clone(this);
		}
		
	}
}