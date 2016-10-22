package uiEditor.core
{
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.SDisplayUtils;
	
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.LineScaleMode;
	import flash.geom.Matrix;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Shape;
	import starling.display.Stage;
	import starling.textures.Texture;
	

	
	public class AUIECanvas extends SLayer
	{
		public  static const INVALIDATION_FLAG_ZOOM:String = "zoom";
		public function AUIECanvas()
		{
			super();
		}
		
		private var _bglineGridImage:DisplayObject;

		protected function get bglineGridImage():DisplayObject
		{
			if(_bglineGridImage == null)
			{
				_bglineGridImage = _bglineGridImageFactory();
			}
			return _bglineGridImage;
		}

		/**
		 * 背景格子的大小 
		 */
		private var _linegridSize:int = 10;
		
		
		/**
		 *  背景线图
		 * @return 
		 * 
		 */
		private function _bglineGridImageFactory():DisplayObject
		{
			var shp:Shape = new Shape();
			
			shp.graphics.beginFill(0x000000,0);
			shp.graphics.lineStyle(1,0x00FF00,1.0);
			
		
			//			bmpdata.draw(shp);
			
			for(var i:int=0;i<SApplicationConfig.o.stageWidth + 1;i=i+ _linegridSize)
			{
				for(var j:int=0;j<SApplicationConfig.o.stageHeight + 1; j=j+ _linegridSize)
				{
					shp.graphics.drawRect(i,j,_linegridSize,_linegridSize);
				}
			}
			shp.graphics.endFill();
			return shp;
		}
		
		override protected function initialize():void
		{
			// TODO Auto Generated method stub
			var bgimage:SImage = new SImage(Texture.fromColor(SApplicationConfig.o.stageWidth
				,SApplicationConfig.o.stageHeight,0x7F123456));
			addChild(bgimage);
			
			
			_editorLayer = new SLayer();
			addChild(_editorLayer);
			_rootUI = new SLayer();
			_rootUIMask = new SLayer();
			
			_editorLayer.width = SApplicationConfig.o.stageWidth;
			_editorLayer.height = SApplicationConfig.o.stageHeight;
			_editorLayer.addChild(bglineGridImage);
			_editorLayer.addChild(_rootUI);
			_editorLayer.addChild(_rootUIMask);
			
			
			
			
			_controlLayer = new AUIEControlLayer(this);
			addChild(_controlLayer);
			
			
			
			
	
		

			super.initialize();
		}
		
		override protected function draw():void
		{
			// TODO Auto Generated method stub
			if (isInvalid(INVALIDATION_FLAG_ZOOM))
			{
				_editorLayer.scaleX = _editorLayer.scaleY = _zoomLevel;
				_centerPos(_editorLayer);
			}
			super.draw();
		}
		/**
		 * 编辑面板 
		 */
		private var _editorLayer:SLayer = null;
		
		private var _zoomLevel:Number = 1;
		
		
		private var _controlLayer:AUIEControlLayer;

		/**
		 * 缩放等级 默认是1 
		 */
		public function get zoomLevel():Number
		{
			return _zoomLevel;
		}

		/**
		 * @private
		 */
		public function set zoomLevel(value:Number):void
		{
			_zoomLevel = value;
			this.invalidate(INVALIDATION_FLAG_ZOOM);
		}
		
		private function _centerPos(view:DisplayObject):void
		{
			const stage:Stage = Starling.current.stage;
			_editorLayer.x = (stage.stageWidth - _editorLayer.width  * _editorLayer.scaleX) / 2;
			_editorLayer.y = (stage.stageHeight - _editorLayer.height * _editorLayer.scaleY) / 2;
		}
		
		private var _rootUI:SLayer;

		/**
		 * UI根节点 
		 */
		public function get rootUI():SLayer
		{
			return _rootUI;
		}
		private var _rootUIMask:SLayer;

		public function get rootUIMask():SLayer
		{
			return _rootUIMask;
		}

		
	}
}