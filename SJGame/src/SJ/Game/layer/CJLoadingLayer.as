package SJ.Game.layer
{
	import flash.text.TextFormat;
	
	import SJ.Common.Constants.ConstLoading;
	
	import engine_starling.SApplication;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SLayer;
	import engine_starling.utils.Logger;
	
	import feathers.controls.Label;
	
	import starling.core.Starling;
	import starling.textures.Texture;
	
	/**
	 * loading 层面
	 * @author yongjun
	 * 
	 */
	public class CJLoadingLayer extends SLayer
	{
		//加载进度文本显示
		private var _labelProgress:Label;
		//加载资源的名字文本显示
		private var _labelResourceName:Label;
		//进度条的水平偏移量
		private const OFFSET_X:int = 9;
		
		/**
		 * 加载层的构造函数 
		 * @param progress uint 加载进度
		 * @param resourceName String 加载资源的名字
		 * 
		 */		
		public function CJLoadingLayer()
		{
			super();
			_init();
		}
		
		private static var _ins:CJLoadingLayer = null;
		private var _loadingAnim:SAnimate;

		private static function get o():CJLoadingLayer
		{
			if(_ins == null)
				_ins = new CJLoadingLayer();
			return _ins;
		}
		
		private function _init():void
		{
			_labelProgress = new Label();
			_labelResourceName = new Label();
			//设置文本格式及内容
			var fontFormat:TextFormat = new TextFormat( "Arial", ConstLoading.ConstLoadingFontSize, 0x000000,"bold");
			_labelProgress.textRendererProperties.textFormat = fontFormat;
			_labelResourceName.textRendererProperties.textFormat = fontFormat;
			_showLoading();
			
		}
		/**
		 * 设置进度 
		 * @param progress Number
		 * 
		 */		
		public function set progress(progress:Number):void
		{
			_labelProgress.text = uint(progress*100) + "%";
			var _labelProgressWidth:int = (_labelProgress.text.length + 2) * ConstLoading.ConstLoadingFontSize / 2;
			_labelProgress.x = _loadingAnim.x + (ConstLoading.ConstLoadingImgWidth - _labelProgressWidth) / 2 + OFFSET_X;
			_labelProgress.y = _loadingAnim.y + ConstLoading.ConstLoadingImgHeight;
		}
		
		/**
		 * 设置资源名称
		 * @param resourceName String
		 * 
		 */		
		public function set resourceName(resourceName:String):void
		{
			_labelResourceName.text = resourceName;
			var _labelResourceNameWidth:int = _labelResourceName.text.length * ConstLoading.ConstLoadingFontSize;
			_labelResourceName.x = _loadingAnim.x + (ConstLoading.ConstLoadingImgWidth - _labelResourceNameWidth) / 2;
			_labelResourceName.y = _loadingAnim.y + ConstLoading.ConstLoadingImgHeight;
		}
		
		private function _showLoading():void
		{
			var imgLoadings:Vector.<Texture> = SApplication.assets.getTextures("ma_dutiaorun_");
			
			_loadingAnim = new SAnimate(imgLoadings, ConstLoading.ConstLoadingFPS);
			//设置加载动画的坐标
			_loadingAnim.x = (- ConstLoading.ConstLoadingImgWidth) / 2;
			_loadingAnim.y = ( - ConstLoading.ConstLoadingImgHeight) / 2;
			_loadingAnim.scaleX = 2;
			_loadingAnim.scaleY = 2;
			_loadingAnim.touchable = false;
			this.addChild(_labelProgress);
			this.addChild(_labelResourceName);
			this.addChild(_loadingAnim);
		}
		
		
		/**
		 * 设置进度.实际上就是调用了 CJLoadingLayer 的 progress 
		 * @param value
		 * 
		 */
		public static function set loadingprogress(value:Number):void
		{
			o.progress = value;
		}
		/**
		 * 是否显示马 
		 */
		public static var  isShowHorse:Boolean = true;
		/**
		 * 显示进度条 
		 * 
		 */
		public static function show():void
		{
			if(o.parent == null)
			{
				Logger.log("CJLoadingLayer","show");
				Starling.juggler.add(o._loadingAnim);
				o._loadingAnim.play();
				o.visible = isShowHorse;
				CJLayerManager.o.addToModal(o);
			}
		}
		/**
		 * 关闭进度条 
		 * 
		 */
		public static function close():void
		{
			if(o.parent != null)
			{
				Logger.log("CJLoadingLayer","close");
				CJLayerManager.o.disposeFromModal(o,false);
				o._loadingAnim.removeFromJuggler();
			}
//			o.removeFromParent();
			
		}
		
	}
}