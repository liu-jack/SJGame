package engine_starling.utils.FeatherControlUtils
{
	import engine_starling.SApplicationConfig;
	

	public class FeatherControlCocosXPropertyBuilderDefault extends FeatherControlPropertyBuilderDefault
	{
		protected var contentScaleFactor:int = 2;
		public function FeatherControlCocosXPropertyBuilderDefault()
		{

			super();
		}
		
		override protected function _onbeginEdit():void
		{
			// TODO Auto Generated method stub
			super._onbeginEdit();
			
			_capInsetsWidth = 0;
			_capInsetsHeight = 0;
			_capInsetsX = 0;
			_capInsetsY = 0;
			_scale9Enable = false;
			_anchorPointX = 0;
			_anchorPointY = 0;
			
		}
		
		
		override protected function _onEndEdit():void
		{
			_computeAnchorPoint();
		}
		
		
		public function set actiontag(value:int):void
		{
			//				actiontag	-1 [0xffffffff]	

		}
		private var _anchorPointX:Number = 0;
		private var _anchorPointY:Number = 0;
		protected function _computeAnchorPoint():void
		{
			_editControl.pivotX = _editControl.width * _anchorPointX;
			//翻转_anchorPointY
			_editControl.pivotY = (_editControl.height * (1 - _anchorPointY));
		}
		public function set anchorPointX(value:Number):void
		{
			//				anchorPointX	0
			_anchorPointX = value;
		}
		public function set anchorPointY(value:Number):void
		{
			//				anchorPointY	0	
			_anchorPointY = value;
		}
		protected var _color:int = 0xFFFFFF;
		protected var _capInsetsWidth:Number = 0;
		protected var _capInsetsHeight:Number = 0;
		protected var _capInsetsX:Number = 0;
		protected var _capInsetsY:Number = 0;
		protected var _scale9Enable:Boolean = false;
		
		public function set capInsetsWidth(value:Number):void
		{
			_capInsetsWidth  = value/contentScaleFactor;
			//				capInsetsWidth	0
		}
		public function set capInsetsHeight(value:Number):void
		{
			_capInsetsHeight = value/contentScaleFactor;
			//				capInsetsHeight	0
		}
		public function set capInsetsX(value:Number):void
		{
			_capInsetsX = value/contentScaleFactor;
			//				capInsetsX	0
		}
		public function set capInsetsY(value:Number):void
		{
			_capInsetsY = value/contentScaleFactor;
			//				capInsetsY	0
		}
		public function set scale9Enable(value:Boolean):void
		{
			_scale9Enable = value;
		}
		public function set colorR(value:Number):void
		{
			_color = ((_color & 0x00FFFF)|(value & 0xFF) <<16);
			//				colorR	255 [0xff]
		}
		public function set colorG(value:Number):void
		{
			_color = ((_color & 0xFF00FF)|(value & 0xFF) <<8);
			//				colorG	255 [0xff]	
		}
		public function set colorB(value:Number):void
		{
			_color = ((_color & 0xFFFF00)|(value & 0xFF));
			//				colorB	255 [0xff]	
		}
		public function set flipX(value:Boolean):void
		{
			//				flipX	false
		}
		public function set flipY(value:Boolean):void
		{
			//				flipY	false	
		}		
		public function set width(value:Number):void
		{
			
			_editControl.width = value/contentScaleFactor;
			//				width	960 [0x3c0]	
		}
		public function set height(value:Number):void
		{
			_editControl.height = value/contentScaleFactor;
			//				height	640 [0x280]
		}
		public function set ignoreSize(value:Boolean):void
		{
			//				ignoreSize	false	
		}
		public function set name(value:String):void
		{
			_editControl.name = value;
			//				name	"rootpanel"	
		}
		public function set opacity(value:Number):void
		{
			_editControl.alpha = value/255.0;
			//				opacity	255 [0xff]	
		}
		public function set rotation(value:Number):void
		{
			_editControl.rotation = value;
			//				rotation	0	
		}
		public function set scaleX(value:Number):void
		{
			_editControl.scaleX = value;
			//				scaleX	1	
		}		
		public function set scaleY(value:Number):void
		{
			_editControl.scaleY = value;
			//				scaleY	1	
		}
		public function set tag(value:Number):void
		{
			//				tag	1	
		}
		
		public function set touchAble(value:Boolean):void
		{
//			_editControl.touchable = value;
			//				touchAble	true	
		}
		public function set useMergedTexture(value:Boolean):void
		{
			//				useMergedTexture	false	
		}
		public function set visible(value:Boolean):void
		{
			_editControl.visible = value;
			//				visible	true	
		}
		public function set x(value:Number):void
		{
			_editControl.x = value/contentScaleFactor;
			//				x	0	
		}
		public function set y(value:Number):void
		{
			
			_editControl.y = (_editOwnerControl == null?SApplicationConfig.o.stageHeight:_editOwnerControl.height) - value/contentScaleFactor;
			//				y	0	
		}
		public function set xProportion(value:Number):void
		{
			//				xProportion	0	
		}
		public function set yProportion(value:Number):void
		{
			//				yProportion	0	
		}
		public function set ZOrder(value:int):void
		{
			//				ZOrder	0	
		}
		
		
	}
}