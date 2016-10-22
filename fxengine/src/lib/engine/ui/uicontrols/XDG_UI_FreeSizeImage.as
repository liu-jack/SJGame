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
	import lib.engine.ui.data.controls.XDG_UI_Data_FreeSizeImage;
	import lib.engine.ui.data.utils.XDG_UI_DataUtils;
	import lib.engine.utils.GBitmapUtils;
	
	public class XDG_UI_FreeSizeImage extends XDG_UI_Control
	{
		private var _imageList:Array = new Array();
		//		private var _bitmap:Bitmap = new Bitmap();
		
		private var _border_top_left:int = 0;
		private var _border_top_right:int = 0;
		private var _border_down_left:int = 0;
		private var _border_down_right:int = 0;
		
		private var _border_left_top:int = 0;
		private var _border_left_down:int = 0;
		
		private var _border_right_top:int = 0;
		private var _border_right_down:int = 0;
		
		public function XDG_UI_FreeSizeImage()
		{
			super();
		}
		
		
		
		override protected function _init_PropertySetter():void
		{
			// TODO Auto Generated method stub
			super._init_PropertySetter();
			
			_registerPropertyFunction("ImageCorner_left_top",_onImageChange);
			_registerPropertyFunction("ImageCorner_left_down",_onImageChange);
			_registerPropertyFunction("ImageCorner_right_top",_onImageChange);
			_registerPropertyFunction("ImageCorner_right_down",_onImageChange);
			_registerPropertyFunction("ImageBorder_top",_onImageChange);
			_registerPropertyFunction("ImageBorder_down",_onImageChange);
			_registerPropertyFunction("ImageBorder_left",_onImageChange);
			_registerPropertyFunction("ImageBorder_right",_onImageChange);
			_registerPropertyFunction("ImageBg",_onImageChange);
			
			_registerPropertyFunction("width",_onSizeChange);
			_registerPropertyFunction("height",_onSizeChange);
			
			_registerPropertyFunction("ImageBgScale",_onModeChange);
			_registerPropertyFunction("ImageBorderScale",_onModeChange);
			
			
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
			//var renderbitmap:BitmapData = new BitmapData(areainfo.width,areainfo.height);
			//renderbitmap.copyPixels(fillbitmap,new Rectangle(areainfo.x,areainfo.y,areainfo.width,areainfo.height),new Point(0,0));
			//			if(_imageList[location] != null)
			//			{
			//				_imageList[location].g.dispose();	
			//			}
			//			_imageList[location] = {'g':fillbitmap,'areainfo':areainfo};
			//
			//			_buildImage();
			
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
		protected function _onSizeChange(varname:String,oldvalue:*,newvalue:*):void
		{
			_buildImage();
		}
		protected function _onModeChange(varname:String,oldvalue:*,newvalue:*):void
		{
			_buildImage();
		}
		
		protected function _buildImage():void
		{
			var fillbitmap:BitmapData = new BitmapData(property.width,property.height);
			fillbitmap.fillRect(new Rectangle(0,0,property.width,property.height),0x00FFFFFF);
			var g:GBitmapData;
			var areainfo:ImageTileInfo;
			var obj:Object;
			var i:int,j:int;
			
			
			
			
			obj = _imageList["ImageCorner_left_top"];
			if(obj != null)
			{
				areainfo = obj.areainfo;
				_border_top_left = areainfo.width;
				_border_left_top = areainfo.height;
				
				_drawCorner(new Point(0,0),fillbitmap,obj);
			}
			
			obj = _imageList["ImageCorner_left_down"];
			if(obj != null)
			{
				areainfo = obj.areainfo;
				_border_down_left = areainfo.width
				_border_left_down = property.height - areainfo.height;
				_drawCorner(new Point(0,property.height - areainfo.height),fillbitmap,obj);
			}
			
			obj = _imageList["ImageCorner_right_top"];
			if(obj != null)
			{
				areainfo = obj.areainfo;
				_border_right_top = areainfo.height;
				_border_top_right = property.width - areainfo.width;
				_drawCorner(new Point(property.width - areainfo.width,0),fillbitmap,obj);
			}
			
			obj = _imageList["ImageCorner_right_down"];
			if(obj != null)
			{
				
				areainfo = obj.areainfo;
				_border_down_right = property.width - areainfo.width;
				_border_right_down = property.height - areainfo.height;
				_drawCorner(new Point(property.width - areainfo.width,property.height - areainfo.height),fillbitmap,obj);
			}
			
			
			
			obj = _imageList["ImageBorder_top"];
			if(obj != null)
			{
				
				areainfo = obj.areainfo;
				g = obj.g;
				_drawBorder(new Rectangle(_border_down_left,0,_border_top_right - _border_top_left,areainfo.height),
					fillbitmap,obj);
			}
			
			
			obj = _imageList["ImageBorder_down"];
			if(obj != null)
			{
				
				areainfo = obj.areainfo;
				g = obj.g;
				
				_drawBorder(new Rectangle(_border_down_left,property.height - areainfo.height,_border_down_right - _border_down_left,areainfo.height),
					fillbitmap,obj);
			}
			
			obj = _imageList["ImageBorder_left"];
			if(obj != null)
			{
				
				areainfo = obj.areainfo;
				g = obj.g;
				
				_drawBorder(new Rectangle(0,_border_left_top,areainfo.width,_border_left_down - _border_left_top),
					fillbitmap,obj);
			}
			
			obj = _imageList["ImageBorder_right"];
			if(obj != null)
			{
				
				areainfo = obj.areainfo;
				g = obj.g;
				_drawBorder(new Rectangle(_border_top_right,_border_left_top,areainfo.width,_border_right_down - _border_right_top),
					fillbitmap,obj);
			}
			
			obj = _imageList["ImageBg"];
			if(obj != null)
			{
				
				areainfo = obj.areainfo;
				g = obj.g;
				
				_drawBg(new Rectangle(_border_top_left,_border_right_top,_border_top_right - _border_top_left,_border_right_down -  _border_right_top),
					fillbitmap,obj);
				
			}
			
			this.graphics.clear();
			this.graphics.beginBitmapFill(fillbitmap);
			this.graphics.drawRect(0,0,fillbitmap.width,fillbitmap.height);
			this.graphics.endFill();
			
			if(g!= null)
			{
				//				g.dispose();
			}
			//			fillbitmap.dispose();
			//			_bitmap.bitmapData = fillbitmap;
		}
		
		protected function _drawCorner(pos:Point,b:BitmapData,params:Object):void
		{
			var g:GBitmapData = params.g;
			var areainfo:ImageTileInfo = params.areainfo;
			b.copyPixels(g.dataMix,g.dataMix.rect
				,pos,null,null,true);
		}
		
		protected function _drawBorder(Rect:Rectangle,b:BitmapData,params:Object):void
		{
			var g:GBitmapData = params.g;
			var areainfo:ImageTileInfo = params.areainfo;
			var data:XDG_UI_Data_FreeSizeImage = _property as XDG_UI_Data_FreeSizeImage;
			if(data.ImageBorderScale)
			{
				GBitmapUtils.StretchBitmap(g,g.dataMix.rect,
					Rect,
					b);
			}
			else
			{
				GBitmapUtils.TileBitmap(g,g.dataMix.rect,
					Rect,
					b);
			}
			
		}
		
		protected function _drawBg(Rect:Rectangle,b:BitmapData,params:Object):void
		{
			var g:GBitmapData = params.g;
			var areainfo:ImageTileInfo = params.areainfo;
			
			var data:XDG_UI_Data_FreeSizeImage = _property as XDG_UI_Data_FreeSizeImage;
			if(data.ImageBgScale)
			{
				GBitmapUtils.StretchBitmap(g,g.dataMix.rect,
					Rect,
					b);
			}
			else
			{
				GBitmapUtils.TileBitmap(g,g.dataMix.rect,
					Rect,
					b);
			}
		}
	}
}