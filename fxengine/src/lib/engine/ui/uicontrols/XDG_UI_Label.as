package lib.engine.ui.uicontrols
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getQualifiedSuperclassName;
	
	import lib.engine.game.bitmap.GBitmapData;
	import lib.engine.resources.Resource;
	import lib.engine.ui.data.ImageTileInfo;
	import lib.engine.ui.data.ImagesSet;
	import lib.engine.ui.data.utils.XDG_UI_DataUtils;
	import lib.engine.utils.functions.Assert;
	
	import mx.core.mx_internal;
	
	public class XDG_UI_Label extends XDG_UI_Control
	{
		public function XDG_UI_Label()
		{
			super();
			
		}
		
		override protected function _init_PropertySetter():void
		{
			super._init_PropertySetter();
			_registerPropertyFunction("text",_loadText);
			_registerPropertyFunction("image",_loadImage);
			
			
			//			_registerPropertyFunction("font",_loadfont);
			//			_registerPropertyFunction("fontsize",_loadfont);
			
			//
			
			_registerPropertyFunction("textStyle",_loadStyle);
			_registerPropertyFunction("autoSize",_loadAutoSize);
			_registerPropertyFunction("width",_loadwidth);
			
			
			_registerExPropertyFilter(["height"]);
			_registerExPropertyFilterObject(_textfield);
			
		}
		
		override protected function _onExPropertyChange(varname:String, oldvalue:*, newvalue:*):void
		{
			
			_textfield[varname] = newvalue;
			
		}
		
		
		override protected function _onInit_ui():void
		{
			super._onInit_ui();
			
			_textfield = new TextField();
			_textfield.multiline = true;
			_textfield.wordWrap = false;
			_textfield.autoSize = TextFieldAutoSize.LEFT;
			_textfield.selectable = false;
			_textfield.mouseEnabled = false;
			this.addChild(_textfield);
			
			
		}
		
		protected var _textfield:TextField = null;
		
		private function _loadwidth(varname:String, oldvalue:*, newvalue:*):void
		{
			var mwidth:Number = newvalue;
			_textfield.x = 0;
			if(mwidth != 0)
			_textfield.width = mwidth;
//			_textfield.x  = mwidth - _textfield.width;
		}
		
		private function _loadfont(varname:String, oldvalue:*, newvalue:*):void
		{
			if(varname =="font")
			{
				
				_textfield.setTextFormat(new TextFormat(newvalue,_property.fontsize));
			}
			else
			{
				_textfield.setTextFormat(new TextFormat(_property.font,newvalue));
			}
			
		}
		
		private function _loadStyle(varname:String, oldvalue:*, newvalue:*):void
		{
			if(newvalue == null || newvalue == "")
				return;
			
			
			var imagesetname:String = XDG_UI_DataUtils.GetImage_ImageSetName(newvalue);
			var imageareaname:String = XDG_UI_DataUtils.GetImage_AreaName(newvalue);
			var imageset:ImagesSet = _ResourceManager.getImageset(imagesetname).value;
			var areainfo:ImageTileInfo = imageset.getArea(imageareaname);
			
			//获取Imageset的资源
			_ResourceManager.getResourceClass(imageset.resfilename,imageset.classname,_loadStyleCallBack,{'areainfo':areainfo});
			
		}
		
		protected function _loadStyleCallBack(cls:Class,params:Object):void
		{
			var areainfo:ImageTileInfo = params.areainfo;
			var superclassname:String = getQualifiedSuperclassName(cls);
			
			
			Assert(superclassname == "flash.display::MovieClip","字体样式控件类型错误,应该是MovieClip,现在是" + superclassname);
			if( superclassname != "flash.display::MovieClip")
			{
				return;
			}
			var fontObject:MovieClip = new cls();
			
			fontObject.gotoAndStop(0);
			var fontText:TextField = TextField(fontObject.getChildByName("text"));
			Assert(fontText != null,"字体样式设置错误,找不到对象text");
			if(fontText == null)
			{
				fontObject = null;
				return;
			}
			
			_textfield.styleSheet = fontText.styleSheet;
			_textfield.defaultTextFormat = fontText.defaultTextFormat;
			_textfield.filters = fontText.filters;
			
			_textfield.text = _textfield.text;
			
		}
		
		private function _loadAutoSize(varname:String, oldvalue:*, newvalue:*):void
		{
			var _autosize:String = newvalue;
			_autosize = _autosize.toLocaleLowerCase();
			
			switch(_autosize)
			{
				case "left":
				{
					_autosize = TextFieldAutoSize.LEFT;
					break;
				}
				case "center":
				{
					_autosize = TextFieldAutoSize.CENTER;
					break;
				}
				case "right":
				{
					_autosize = TextFieldAutoSize.RIGHT;
					break;
				}
				default:
				{
					_autosize = TextFieldAutoSize.LEFT;
				}
			}
			
			_textfield.autoSize = _autosize;
			_loadwidth("width",_textfield.width,property.width);
//			if(_autosize == TextFieldAutoSize.LEFT)_textfield.textWidth
		}
		
		
		private function _loadText(varname:String, oldvalue:*, newvalue:*):void
		{
			if(newvalue!= null)
			{
				_textfield.htmlText = newvalue;
			}
		}
		
		private function _loadImage(varname:String, oldvalue:*, newvalue:*):void
		{
			if(newvalue == null || newvalue == "")
				return;
			
			var imagesetname:String = XDG_UI_DataUtils.GetImage_ImageSetName(newvalue);
			var imageareaname:String = XDG_UI_DataUtils.GetImage_AreaName(newvalue);
			var imageset:ImagesSet = _ResourceManager.getImageset(imagesetname).value;
			var areainfo:ImageTileInfo = imageset.getArea(imageareaname);
			
			var fillbitmap:GBitmapData;// = new BitmapData(areainfo.width,areainfo.height);
			fillbitmap = imageset.getAreaGBitmap(imageareaname);
			if(fillbitmap == null)
			{
				//获取Imageset的资源
				_ResourceManager.getResourceClass(imageset.resfilename,imageset.classname,_loadImageCallBack,
					{'areainfo':areainfo,"imageset":imageset,"imageareaname":imageareaname});
			}
			else
			{
				this.graphics.clear();
				this.graphics.beginBitmapFill(fillbitmap.dataMix);
				this.graphics.drawRect(0,0,fillbitmap.dataMix.width,fillbitmap.dataMix.height);
				this.graphics.endFill();
			}
			
		}
		
		protected function _loadImageCallBack(cls:Class,params:Object):void
		{
			var areainfo:ImageTileInfo = params.areainfo;
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
			//var m:Matrix = new Matrix();
			//m.translate((-1) *areainfo.x,(-1) * areainfo.y);
			
			//			var bgbitmap:BitmapData = new BitmapData(areainfo.width,areainfo.height);
			//			bgbitmap.fillRect(bgbitmap.rect,0x00FFFFF);
			//			bgbitmap.copyPixels(fillbitmap,new Rectangle(areainfo.x,areainfo.y,areainfo.width,areainfo.height),new Point(0,0));
			//			fillbitmap.dispose();
			this.graphics.clear();
			this.graphics.beginBitmapFill(fillbitmap.dataMix);
			this.graphics.drawRect(0,0,fillbitmap.dataMix.width,fillbitmap.dataMix.height);
			this.graphics.endFill();
		}
		
		/**
		 * 控件中的输入实例,可以添加事件什么的,获取输入内容啥的 
		 * @return 
		 * 
		 */
		public function get textfield():TextField
		{
			return _textfield;
		}
		
		override public function get width():Number
		{
			// TODO Auto Generated method stub
			return _textfield.width + _textfield.x;
		}
		
		
		
		
		
	}
}