package lib.engine.ui.uicontrols
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedSuperclassName;
	
	import lib.engine.game.bitmap.GBitmapData;
	import lib.engine.resources.Resource;
	import lib.engine.ui.data.ImageTileInfo;
	import lib.engine.ui.data.ImagesSet;
	import lib.engine.ui.data.utils.XDG_UI_DataUtils;
	import lib.engine.utils.GBitmapUtils;
	
	public class XDG_UI_ProgressBar extends XDG_UI_Control
	{
		private var _imageList:Array = new Array();
		//		private var _bitmap:Bitmap = new Bitmap();
		private var _border_left:int = 0;
		private var _border_right:int = 0;
		public function XDG_UI_ProgressBar()
		{
			super();
		}
		
		override protected function _init_PropertySetter():void
		{
			super._init_PropertySetter();
			
			_registerPropertyFunction("bgImageMid",_onImageChange);
			_registerPropertyFunction("bgImageleft",_onImageChange);
			_registerPropertyFunction("bgImageright",_onImageChange);
			_registerPropertyFunction("valueImage",_onImageChange);
			
			
			
			
			_registerPropertyFunction("width",_valuechange);
			_registerPropertyFunction("height",_valuechange);
			_registerPropertyFunction("bgImageScale",_valuechange);
			_registerPropertyFunction("value",_valuechange);
			_registerPropertyFunction("maxvalue",_valuechange);
			_registerPropertyFunction("minvalue",_valuechange);
			_registerPropertyFunction("valueImageScale",_valuechange);
			
			_registerPropertyFunction("reverseValue",_valuechange);
			
		}
		
		override protected function _onInit_ui():void
		{
			// TODO Auto Generated method stub
			super._onInit_ui();
			//			_bitmap.x = 0;
			//			_bitmap.y = 0;
			//			this.addChild(_bitmap);
		}
		
		
		protected function _onImageChange(varname:String,oldvalue:*,newvalue:*):void
		{
			_loadBitmap(varname,newvalue);
		}
		
		protected function _loadBitmap(location:String,ImageName:String):void
		{
			if(ImageName == null || ImageName == "")
				return;
			
			var imagesetname:String = XDG_UI_DataUtils.GetImage_ImageSetName(ImageName);
			var imageareaname:String = XDG_UI_DataUtils.GetImage_AreaName(ImageName);
			var imageset:ImagesSet = _ResourceManager.getImageset(imagesetname).value;
			var areainfo:ImageTileInfo = imageset.getArea(imageareaname);
			var fillbitmap:GBitmapData;// = new BitmapData(areainfo.width,areainfo.height);
			fillbitmap = imageset.getAreaGBitmap(imageareaname);
			if(fillbitmap == null)
			{
				_ResourceManager.getResourceClass(imageset.resfilename,imageset.classname,_loadBitmapCallBack,
					{'location':location,'areainfo':areainfo,"imageset":imageset,"imageareaname":imageareaname});
			}
			else
			{
				_setImage(location,fillbitmap,areainfo);
			}
			
		}
		
		protected function _loadBitmapCallBack(cls:Class,params:Object):void
		{
			var areainfo:ImageTileInfo = params.areainfo;
			var location:String = params.location;
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
			
			_setImage(location,fillbitmap,areainfo);
			
		}
		
		protected function _setImage(location:String,g:GBitmapData,areainfo:ImageTileInfo):void
		{
			if(_imageList[location] != null)
			{
				_imageList[location].g.dispose();	
			}
			_imageList[location] = {'g':g,'areainfo':areainfo};
			_buildImage();
		}
		protected function _valuechange(varname:String,oldvalue:*,newvalue:*):void
		{
			_buildImage();
		}
		protected function _buildImage():void
		{
			var fillbitmap:BitmapData = new BitmapData(property.width,property.height);
			_border_right = property.width;
			fillbitmap.fillRect(new Rectangle(0,0,property.width,property.height),0x00FFFFFF);
			var g:GBitmapData;
			var areainfo:ImageTileInfo;
			var obj:Object;
			var i:int,j:int;
			
			var _reverseValue:Boolean = property.reverseValue;
			
			obj = _imageList["bgImageleft"];
			if(obj != null)
			{
				g = obj.g;
				areainfo = obj.areainfo;
				_border_left = areainfo.width;
				//				new Rectangle(areainfo.x,areainfo.y,areainfo.width,areainfo.height)
				
				fillbitmap.copyPixels(g.dataMix,g.dataMix.rect,
					new Point(0,0),null,null,true);
				
			}
			
			
			obj = _imageList["bgImageright"];
			if(obj != null)
			{
				g = obj.g;
				areainfo = obj.areainfo;
				_border_right = property.width - areainfo.width;
				fillbitmap.copyPixels(g.dataMix,g.dataMix.rect,
					new Point(property.width - areainfo.width,0),null,null,true);
				
			}
			
			obj = _imageList["bgImageMid"];
			if(obj != null)
			{
				g = obj.g;
				areainfo = obj.areainfo;
				GBitmapUtils.fillBitmap(g,g.dataMix.rect,
					new Rectangle(_border_left,0,_border_right - _border_left,property.height),fillbitmap,_property["bgImageScale"]);
				
			}
			
			obj = _imageList["valueImage"];
			if(obj != null)
			{
				g = obj.g;
				areainfo = obj.areainfo;
				
				var valuewidth:Number = _property["value"] / (_property["maxvalue"] - _property["minvalue"]);
				
				if(!_reverseValue)
				{
					GBitmapUtils.fillBitmap(g,g.dataMix.rect,
						new Rectangle(_border_left,0,(_border_right - _border_left) * valuewidth,property.height),fillbitmap,_property["valueImageScale"]);
				}
				else //反转贴图
				{
					GBitmapUtils.fillBitmap(g,new Rectangle(g.dataMix.rect.width * (1 - valuewidth),0,g.dataMix.rect.width * valuewidth,g.dataMix.rect.height),
						new Rectangle(_border_left + (_border_right - _border_left) * (1 - valuewidth),0,(_border_right - _border_left) * valuewidth,property.height),fillbitmap,_property["valueImageScale"]);
				}
			}
			
			this.graphics.clear();
			this.graphics.beginBitmapFill(fillbitmap);
			this.graphics.drawRect(0,0,fillbitmap.width,fillbitmap.height);
			this.graphics.endFill();
			
			
			
		}
	}
}