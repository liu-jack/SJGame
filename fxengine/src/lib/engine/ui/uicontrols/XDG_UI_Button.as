package lib.engine.ui.uicontrols
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedSuperclassName;
	
	import lib.engine.game.bitmap.GBitmap;
	import lib.engine.game.bitmap.GBitmapData;
	import lib.engine.resources.Resource;
	import lib.engine.ui.data.ImageTileInfo;
	import lib.engine.ui.data.ImagesSet;
	import lib.engine.ui.data.controls.XDG_UI_Data;
	import lib.engine.ui.data.utils.XDG_UI_DataUtils;
	
	public class XDG_UI_Button extends XDG_UI_Control
	{
		
		public static const STATE_NORMAL:String = "STATE_NORMAL";
		public static const STATE_DOWN:String = "STATE_DOWN";
		public static const STATE_OVER:String = "STATE_OVER";
		public static const STATE_DISABLE:String = "STATE_DISABLE";
		public static const STATE_SELETE:String = "STATE_SELETE";
		
		public function XDG_UI_Button()
		{
			super();	
		}
		
		private var bitmaps:Dictionary = new Dictionary();
		private var _buttonstate:String = STATE_NORMAL;
		
		override protected function _onInit_ui():void
		{
			super._onInit_ui();
			buttonstate = STATE_NORMAL;
		}
		
		override protected function _onAdded_tostage():void
		{
			this.addEventListener(MouseEvent.MOUSE_OVER,_mouseOver);
			this.addEventListener(MouseEvent.MOUSE_DOWN,_mouseDown);
			this.addEventListener(MouseEvent.MOUSE_OUT,_mouseOut);
			this.addEventListener(MouseEvent.MOUSE_UP,_mouseUp);
		}
		
		override protected function _onRemove_from_State():void
		{
			super._onRemove_from_State();
			
			this.addEventListener(MouseEvent.MOUSE_OVER,_mouseOver);
			this.addEventListener(MouseEvent.MOUSE_DOWN,_mouseDown);
			this.addEventListener(MouseEvent.MOUSE_OUT,_mouseOut);
			this.addEventListener(MouseEvent.MOUSE_UP,_mouseUp);
		}
		
		
		
		
		
		override protected function onPropertyValueChange(property:XDG_UI_Data, varname:String, oldvalue:*, newvalue:*):void
		{
			super.onPropertyValueChange(property, varname, oldvalue, newvalue);
			switch(varname)
			{
				case "normal":
				{
					_loadBitmap( STATE_NORMAL,newvalue);
					break;
				}
				case "down":
				{
					_loadBitmap(STATE_DOWN,newvalue);
					break;
				}
				case "disabled":
				{
					_loadBitmap(STATE_DISABLE,newvalue);
					break;
				}
				case "over":
				{
					_loadBitmap(STATE_OVER,newvalue);
					break;
				}
				case "select":
				{
					_loadBitmap(STATE_SELETE,newvalue);
					break;
				}
			}
		}
		
		
		protected function _loadBitmap(state:String,btnstatename:String):void
		{
			if(btnstatename == null || btnstatename == "")
				return;
			
			var imagesetname:String = XDG_UI_DataUtils.GetImage_ImageSetName(btnstatename);
			var imageareaname:String = XDG_UI_DataUtils.GetImage_AreaName(btnstatename);
			var imageset:ImagesSet = _ResourceManager.getImageset(imagesetname).value;
			var areainfo:ImageTileInfo = imageset.getArea(imageareaname);
			
			var fillbitmap:GBitmapData;
			fillbitmap = imageset.getAreaGBitmap(imageareaname);
			if(fillbitmap == null)
			{
				_ResourceManager.getResourceClass(imageset.resfilename,imageset.classname,_loadBitmapCallBack,
					{'state':state,'areainfo':areainfo,"imageset":imageset,"imageareaname":imageareaname});
			}
			else
			{
				_setStateGBitmap(state,fillbitmap);
			}
		}
		
		protected function _loadBitmapCallBack(cls:Class,params:Object):void
		{
			var areainfo:ImageTileInfo = params.areainfo;
			var state:String = params.state;
			var superclassname:String = getQualifiedSuperclassName(cls);
			var imageset:ImagesSet = params.imageset;
			var imageareaname:String =  params.imageareaname;
			
			var fillbitmap:GBitmapData;// = new BitmapData(areainfo.width,areainfo.height);
			fillbitmap = imageset.getAreaGBitmap(imageareaname);
			if(fillbitmap == null)
			{
				if(superclassname == null || superclassname == "flash.display::BitmapData")
				{
					if(superclassname == null)
					{
						var mRes:Resource = _ResourceManager.getResByPath(imageset.resfilename);
						fillbitmap = new GBitmapData(mRes.value.content,areainfo.x,areainfo.y,areainfo.width,areainfo.height);
					}
					else
					{
						fillbitmap = new GBitmapData(new Bitmap(new cls(0,0)),areainfo.x,areainfo.y,areainfo.width,areainfo.height);
					}
				}
				else
				{
					fillbitmap = new GBitmapData(new cls(),areainfo.x,areainfo.y,areainfo.width,areainfo.height);
				}
				imageset.Cached(imageareaname,fillbitmap);
			}
			
			_setStateGBitmap(state,fillbitmap);
			
		}
		
		/**
		 * 设置状态图片 
		 * @param state
		 * @param fillbitmap
		 * 
		 */
		protected function _setStateGBitmap(state:String,fillbitmap:GBitmapData):void
		{
			bitmaps[state] = fillbitmap;
			if(state == _buttonstate)
				_changeState();
		}
		
		
		protected function _changeState():void
		{
			if(buttonstate == STATE_DISABLE)
			{
				this.mouseEnabled = false;
			}
			else
			{
				this.mouseEnabled = true;
			}
			var mbitmap:GBitmapData = bitmaps[_buttonstate];
			if(mbitmap != null)
			{
				this.graphics.clear();
				this.graphics.beginBitmapFill(mbitmap.dataMix);
				this.graphics.drawRect(0,0,mbitmap.dataMix.width,mbitmap.dataMix.height);
				this.graphics.endFill();
			}
		}
		protected function _mouseOver(e:MouseEvent):void
		{
			
			if(buttonstate != STATE_DISABLE && buttonstate != STATE_SELETE)
				buttonstate = STATE_OVER;
		}
		protected function _mouseOut(e:MouseEvent):void
		{
			if(buttonstate != STATE_DISABLE && buttonstate != STATE_SELETE)
				buttonstate = STATE_NORMAL;
		}
		protected function _mouseDown(e:MouseEvent):void
		{
			if(buttonstate != STATE_DISABLE && buttonstate != STATE_SELETE)
				buttonstate = STATE_DOWN;
		}
		protected function _mouseUp(e:MouseEvent):void
		{
			if(buttonstate != STATE_DISABLE && buttonstate != STATE_SELETE)
				buttonstate = STATE_NORMAL;
		}
		
		public function get buttonstate():String
		{
			return _buttonstate;
		}
		
		public function set buttonstate(value:String):void
		{
			if(_buttonstate != value)
			{
				_buttonstate = value;
				_changeState();
			}
			
		}
		
	}
}