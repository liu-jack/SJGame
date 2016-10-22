package lib.engine.ui.uicontrols
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedSuperclassName;
	
	import lib.engine.game.bitmap.GBitmap;
	import lib.engine.game.bitmap.GBitmapData;
	import lib.engine.resources.Resource;
	import lib.engine.ui.data.ImageTileInfo;
	import lib.engine.ui.data.ImagesSet;
	import lib.engine.ui.data.utils.XDG_UI_DataUtils;
	
	public class XDG_UI_MC extends XDG_UI_Control
	{
		
		/**
		 * 循环次数 
		 */
		private var _loopcount:int = -1;
		private var _currentloopcount:int = 0;
		private var _framecount :int = 0;
		private var _callback:Function = null;
		private var _mc:MovieClip = null;
		
		public function XDG_UI_MC()
		{
			super();
		}
		
		
		override protected function _onInitBefore():void
		{
			this.mouseChildren = false;
			super._onInitBefore();
//			this.addEventListener(Event.REMOVED_FROM_STAGE,
//				function f(e:Event):void
//				{
//					_mc.removeEventListener(Event.ENTER_FRAME,_onMcRender);
//				});
		}
		
		
		override protected function _init_PropertySetter():void
		{
			// TODO Auto Generated method stub
			super._init_PropertySetter();
			_registerPropertyFunction("image",_onImageChange);
			
		}
		
		
		protected function _onImageChange(varname:String, oldvalue:*, newvalue:*):void
		{
			loadMC(newvalue);
		}
		protected function loadMC(name:String):void
		{
			
			if(name == null || name == "")
				return;
			
			var imagesetname:String = XDG_UI_DataUtils.GetImage_ImageSetName(name);
			var imageareaname:String = XDG_UI_DataUtils.GetImage_AreaName(name);
			var imageset:ImagesSet = _ResourceManager.getImageset(imagesetname).value;
			var areainfo:ImageTileInfo = imageset.getArea(imageareaname);
			
			var bitmapdata:GBitmapData = imageset.getAreaGBitmap(imageareaname);
			if(bitmapdata == null)
			{
				//获取Imageset的资源
				_ResourceManager.getResourceClass(imageset.resfilename,imageset.classname,_loadMCCallBack,{'imagename':name,'areainfo':areainfo
					,"imageset":imageset,"imageareaname":imageareaname});
			}
			else
			{
				this.graphics.clear();
				this.graphics.beginBitmapFill(bitmapdata.dataMix);
				this.graphics.drawRect(0,0,bitmapdata.dataMix.width,bitmapdata.dataMix.height);
				this.graphics.endFill();
				
				if(_mc != null)
				{
					if(this.getChildIndex(_mc) != -1)
					{
						this.removeChild(_mc);
						if(_loopcount != -1)
						{
							_mc.removeEventListener(Event.ENTER_FRAME,_onMcRender);
						}
						_mc = null;
					}
				}
			}
		}
		
		protected function _loadMCCallBack(cls:Class,params:Object):void
		{
			var imagename:String = params.imagename;
			if(imagename != property.image)
				return;
			var areainfo:ImageTileInfo = params.areainfo;
			var superclassname:String = getQualifiedSuperclassName(cls);
			var imageset:ImagesSet = params.imageset;
			var imageareaname:String =  params.imageareaname;
			
			if(_mc != null)
			{
				if(this.getChildIndex(_mc) != -1)
				{
					this.removeChild(_mc);
					if(_loopcount != -1)
					{
						_mc.removeEventListener(Event.ENTER_FRAME,_onMcRender);
					}
					_mc = null;
				}
			}
			this.graphics.clear();
			
			if(superclassname == null || superclassname == "flash.display::BitmapData")
			{
				var bitmapdata:GBitmapData = imageset.getAreaGBitmap(imageareaname);
				if(bitmapdata == null)
				{
					//直接加载外部图片,所以这个为空
					if(superclassname == null)
					{
						var mRes:Resource = _ResourceManager.getResByPath(imageset.resfilename);
						bitmapdata = new GBitmapData(mRes.value.content,areainfo.x,areainfo.y,areainfo.width,areainfo.height);
					}
					else
					{
						bitmapdata = new GBitmapData(new Bitmap(new cls(0,0)),areainfo.x,areainfo.y,areainfo.width,areainfo.height);
					}
					
					imageset.Cached(imageareaname,bitmapdata);
					
				}
				this.graphics.clear();
				this.graphics.beginBitmapFill(bitmapdata.dataMix);
				this.graphics.drawRect(0,0,bitmapdata.dataMix.width,bitmapdata.dataMix.height);
				this.graphics.endFill();
			}
				
			else
			{
				_mc = new cls();
				this.addChild(_mc);
				if(_loopcount != -1)
				{
					_mc.addEventListener(Event.ENTER_FRAME,_onMcRender);
					_ResetLoopInfo();
					
					_mc.currentFrame
				}
				
			}
			
			
		}
		
		private function _onMcRender(e:Event):void
		{
			if(_currentloopcount >= _loopcount)
				return;
			if(e.currentTarget.currentFrame == _framecount)
			{
				_currentloopcount ++;
				if(_currentloopcount >= _loopcount)
				{
					_mc.gotoAndStop(_framecount -1);
					if(_callback != null)
						_callback(this);
				}
				
			}
			
		}
		
		public function get Mc_Object():MovieClip
		{
			return _mc;
		}
		
		
		/**
		 * 设置循环次数 ,需要在一开始加载资源的时候设置,后续设置会无效
		 * @param count -1为无限循环,其它为具体次数
		 * @param callback function(control:XDG_UI_MC):void
		 * @return 
		 * 
		 */
		public function setLoopCount(count:int= -1,callback:Function = null):void
		{
			
			_loopcount = count;
			_callback = callback;
			
			_ResetLoopInfo();
		}
		
		private function _ResetLoopInfo():void
		{
			_currentloopcount = 0;
			if(_mc != null)
			{
				_mc.gotoAndPlay(0);
				_framecount = _mc.framesLoaded;
			}
			else
			{
				_framecount = 0;
			}
		}
		
		
	}
}