package SJ.Game.layer
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.global.textRender;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SLayer;
	import engine_starling.utils.Logger;
	import engine_starling.utils.STween;
	
	import feathers.controls.Label;
	import feathers.controls.ProgressBar;
	import feathers.display.Scale3Image;
	import feathers.textures.Scale3Textures;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.textures.Texture;
	
	/**
	 * loading 场景界面层面（只有在登陆进入主界面和切换场景的时候用）
	 * @author zhengzheng
	 * 
	 */
	public class CJLoadingSceneLayer extends SLayer
	{
		//加载进度文本显示
		private var _labelDesc:Label;
		//进入场景的进度条
		private var _progressBarEnterScence:ProgressBar;
		//当前进度
		private var _curProgress:uint;
		//动画播放的x偏移量
		private const LOADING_OFFSET_X:int = 13;
		//动画
		private var _loadingAnim:SAnimate;
		
		/**
		 * 加载层的构造函数 
		 * @param progress uint 加载进度
		 * @param resourceName String 加载资源的名字
		 * 
		 */		
		public function CJLoadingSceneLayer()
		{
			super();
			
		}
		
		override protected function initialize():void
		{
			_init();
			super.initialize();
		}
		
		override public function dispose():void
		{
			_loadingAnim.removeFromJuggler();
			super.dispose();
		}
		
		
		override protected function draw():void
		{
			// TODO Auto Generated method stub
			super.draw();
		}
		
		
		
		
		private function _init():void
		{
			pivotX = 120;
			touchable = false;
			
			var imgBg:Scale3Image = ConstNPCDialog.genS3ImageWithTextureNameAndRegion("common_jindutiaokuang",54,1);
			imgBg.width = 240;
			imgBg.height = 32;
			addChild(imgBg);
			
			_labelDesc = new Label();
			_labelDesc.width = 250;
			_labelDesc.x = -5;
			_labelDesc.y = -7;
			
			//设置文本格式及内容
			var fontFormat:TextFormat = new TextFormat( "黑体", 12, 0xFFFFFF, null,null,null,null,null, TextFormatAlign.CENTER);
			_labelDesc.textRendererProperties.textFormat = fontFormat;
//			_labelDesc.textRendererProperties.wordWrap = true;
			_labelDesc.textRendererFactory = textRender.standardTextRender;
//			_labelDesc.textRendererFactory = textRender.htmlTextRender;
			_labelDesc.text = CJLang("LOAD_TIP_" + (int(Math.random() * 200) + 1));
			this.addChild(_labelDesc);
			
			//经验条
			_progressBarEnterScence = new ProgressBar;
			var scale3texture:Scale3Textures = new Scale3Textures(SApplication.assets.getTexture("common_jingyantiao1"),1,1);
			var fillSkin:Scale3Image = new Scale3Image(scale3texture);
			_progressBarEnterScence.fillSkin = fillSkin;
			_progressBarEnterScence.x = 40;
			_progressBarEnterScence.y = 13;
			_progressBarEnterScence.width = 159;
			_progressBarEnterScence.height = 7;
			_progressBarEnterScence.minimum = 0;
			_progressBarEnterScence.maximum = 100;
			this.addChild(_progressBarEnterScence);
			
			var imgLoadings:Vector.<Texture> = SApplication.assets.getTextures("common_jingyantiao_");
			
			_loadingAnim = new SAnimate(imgLoadings, 10);
			_loadingAnim.width = 83;
			_loadingAnim.height = 22;
			_loadingAnim.scaleX = 4;
			_loadingAnim.scaleY = 4;
			//设置加载动画的坐标
			_loadingAnim.x = _progressBarEnterScence.x - _loadingAnim.width + LOADING_OFFSET_X;
			_loadingAnim.y = 4;
			this.addChild(_loadingAnim);
			
			this._loadingAnim.play();
			Starling.juggler.add(this._loadingAnim);
		}
		
		/**
		 * 设置进度 
		 * @param progress Number
		 * 
		 */		
		public function set progress(progress:Number):void
		{
			_curProgress = uint(progress*100);
			_progressBarEnterScence.value = Number(_curProgress);
			//设置加载动画的坐标
			var _progressCurWidth:Number = (_progressBarEnterScence.value / _progressBarEnterScence.maximum) * _progressBarEnterScence.width;
			_loadingAnim.x = _progressBarEnterScence.x + _progressCurWidth - _loadingAnim.width + LOADING_OFFSET_X;

		}
		public function get progress():Number
		{
			return Number(_curProgress) /100;
		}
		
		
		/**
		 * 设置进度.实际上就是调用了 CJLoadingsScenceLayer 的 progress 
		 * @param value
		 * 
		 */
		public function set loadingprogress(value:Number):void
		{
			var t:Tween = new Tween(this,1);
			t.animate("progress",value);
			Starling.juggler.add(t);
//			this.progress = value;
		}
		private static var _loadinglayerlist:Vector.<CJLoadingSceneLayer> = new Vector.<CJLoadingSceneLayer>();
		private var _bOpen:Boolean = false;
		private var _bClose:Boolean = false;
		
		private function _closeOthersWithOutMe():void
		{
			var otherlayer:CJLoadingSceneLayer = null;
			while(null != (otherlayer = _loadinglayerlist.pop()))
			{
				otherlayer.close();
			}
			_loadinglayerlist.push(this);
		}
		private function _closeMe():void
		{
			var idx:int = _loadinglayerlist.indexOf(this);
			if(idx != -1)
			{
				_loadinglayerlist.splice(idx,1);
			}
		}
		/**
		 * 显示进度条 
		 * 
		 */
		public function show():void
		{
			if(_bOpen)
			{
				return;
			}
			_bOpen = true;
			_closeOthersWithOutMe();
			
			Logger.log("CJLoadingsScenceLayer","show");
			CJLayerManager.o.addToTop(this);
			this.y = 235;
		}
		/**
		 * 关闭进度条 
		 * 
		 */
		public function close():void
		{
			if(_bClose)
			{
				return;
			}
			_closeMe();
			_bClose = true;
			Logger.log("CJLoadingsScenceLayer","close");
			CJLayerManager.o.disposeFromModal(this,true);
		}
		
	}
}