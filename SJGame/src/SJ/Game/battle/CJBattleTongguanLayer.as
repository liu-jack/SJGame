package SJ.Game.battle
{
	
	import SJ.Game.battle.custom.CJBattleCommandBattleEnd;
	import SJ.Game.map.CJBattleMapManager;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SAtlasLabel;
	import engine_starling.display.SLayer;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	import engine_starling.utils.STween;
	
	import feathers.controls.ImageLoader;
	import feathers.core.FeathersControl;
	
	import starling.animation.Juggler;
	import starling.animation.Transitions;
	import starling.events.Event;
	import starling.utils.HAlign;

	/**
	 * 
	 * @author zhengzheng
	 * 通关层
	 */	
	public class CJBattleTongguanLayer extends SLayer
	{
		
		private var _juggler:Juggler;
		private var _tongguanParams:Object = null;
		
		public function CJBattleTongguanLayer()
		{
			super();
		}
		
		private var _textJingyan:SAtlasLabel;

		/**
		 * 通关经验数值
		 * 
		 */
		public function get textJingyan():SAtlasLabel
		{
			return _textJingyan;
		}

		/**
		 * @private
		 */
		public function set textJingyan(value:SAtlasLabel):void
		{
			_textJingyan = value;
		}

		private var _textYinliang:SAtlasLabel;

		/**
		 * 通关银两数值
		 * 
		 */
		public function get textYinliang():SAtlasLabel
		{
			return _textYinliang;
		}

		/**
		 * @private
		 */
		public function set textYinliang(value:SAtlasLabel):void
		{
			_textYinliang = value;
		}

		private var _textGanwu:SAtlasLabel;
		/**
		 * 通关感悟数值
		 * 
		 */
		public function get textGanwu():SAtlasLabel
		{
			return _textGanwu;
		}

		public function set textGanwu(value:SAtlasLabel):void
		{
			_textGanwu = value;
		}
		
		
		private var _imageOfZhuan:ImageLoader;

		/**
		 * 通关图片背景
		 */
		public function get imageOfZhuan():ImageLoader
		{
			return _imageOfZhuan;
		}

		/**
		 * @private
		 */
		public function set imageOfZhuan(value:ImageLoader):void
		{
			_imageOfZhuan = value;
		}
		
		private var _anim_tongguan_tongguan:SAnimate;

		/**
		 * 通关图片动画
		 */	
		public function get anim_tongguan_tongguan():SAnimate
		{
			return _anim_tongguan_tongguan;
		}

		public function set anim_tongguan_tongguan(value:SAnimate):void
		{
			_anim_tongguan_tongguan = value;
		}

		private var _anim_tongguan_guang:SAnimate;

		/**
		 * 通关评价背景图片动画
		 */
		public function get anim_tongguan_guang():SAnimate
		{
			return _anim_tongguan_guang;
		}

		/**
		 * @private
		 */
		public function set anim_tongguan_guang(value:SAnimate):void
		{
			_anim_tongguan_guang = value;
		}

		private var _anim_tongguan_pingjia:SAnimate;

		/**
		 * 通关评价图片动画
		 */
		public function get anim_tongguan_pingjia():SAnimate
		{
			return _anim_tongguan_pingjia;
		}

		/**
		 * @private
		 */
		public function set anim_tongguan_pingjia(value:SAnimate):void
		{
			_anim_tongguan_pingjia = value;
		}

		override protected function initialize():void
		{
			//通关评价级别声明
			var pingjiLevel:int = int(Math.random() * 5 + 1);
			
			//设置通关转动底图X、Y轴
			_imageOfZhuan.pivotX = 0.5 * _imageOfZhuan.width;
			_imageOfZhuan.pivotY = 0.5 * _imageOfZhuan.height;
		
			//通关动画声明
			var animTongguanObject:Object = AssetManagerUtil.o.getObject("anim_tongguan_tongguan");
			if(animTongguanObject == null)
				return;
			_anim_tongguan_tongguan = SAnimate.SAnimateFromAnimJsonObject(animTongguanObject);
			_anim_tongguan_tongguan.loop = false;
			
			//评价底图动画声明
			var animTongguanGuangObject:Object = AssetManagerUtil.o.getObject("anim_tongguan_guang" + pingjiLevel);
			if(animTongguanGuangObject == null)
				return;
			_anim_tongguan_guang = SAnimate.SAnimateFromAnimJsonObject(animTongguanGuangObject);
			_anim_tongguan_guang.loop = false;
			
			
			//评价动画声明
			var animTongguanPingjiaObject:Object = AssetManagerUtil.o.getObject("anim_tongguan_pingjia" + pingjiLevel);
			if(animTongguanPingjiaObject == null)
				return;
			_anim_tongguan_pingjia = SAnimate.SAnimateFromAnimJsonObject(animTongguanPingjiaObject);
			_anim_tongguan_pingjia.loop = false;
			
			super.initialize();
		}
		
		override protected function draw():void
		{
			
			//设置经验、银两、感悟文本
			_textJingyan.text = _tongguanParams["jingYan"].toString();
			_textYinliang.text = _tongguanParams["yinLiang"].toString();
			_textGanwu.text = _tongguanParams["ganWu"].toString();
			
			_textJingyan.hAlign = HAlign.CENTER;
			_textYinliang.hAlign = HAlign.CENTER;
			_textGanwu.hAlign = HAlign.CENTER;
			addChild(_textJingyan);
			addChild(_textYinliang);
			addChild(_textGanwu);
			
			//播放通关图背景动画
			var zhuanTween:STween = new STween(_imageOfZhuan,1,Transitions.LINEAR);
			//设置动画循环播放
			zhuanTween.loop = STween.XSTLoopTypeRepeat;
			zhuanTween.animate("rotation", Math.PI);
			addChild(_imageOfZhuan);
			_juggler.add(zhuanTween);
			
			
			//播放通关图背景动画后播放通关动画
			zhuanTween.onLoop = function ():void 
			{
				_anim_tongguan_tongguan.gotoAndPlay();
				addChild(_anim_tongguan_tongguan);
				_juggler.add(_anim_tongguan_tongguan);
				//停止onLoop循环函数，让onLoop函数只执行一次
				zhuanTween.onLoop = null;
			}
			
			
			//播放通关动画后播放评价底图动画
			_anim_tongguan_tongguan.addEventListener(Event.COMPLETE,function (e:*):void
			{
				_anim_tongguan_tongguan.removeEventListeners(Event.COMPLETE);
				_juggler.remove(_anim_tongguan_tongguan);
				_anim_tongguan_guang.gotoAndPlay();
				addChild(_anim_tongguan_guang);
				_juggler.add(_anim_tongguan_guang);
			});
			
			//播放评价底图动画后播放评价动画
			_anim_tongguan_guang.addEventListener(Event.COMPLETE,function (e:*):void
			{
				_anim_tongguan_guang.removeEventListeners(Event.COMPLETE);
				_juggler.remove(_anim_tongguan_guang);
				_anim_tongguan_pingjia.gotoAndPlay();
				addChild(_anim_tongguan_pingjia);
				_juggler.add(_anim_tongguan_pingjia);
			});
			super.draw();
		}
		/**
		 * 创建通关层
		 * @param parent:FeathersControl
		 * 
		 */
		public static function createTonggaunLayer(parent:FeathersControl):void
		{
			var battleTongguanLayout:XML = AssetManagerUtil.o.getObject("battleTongguanLayout.sxml") as XML;
			var tongguanLayer:FeathersControl = SFeatherControlUtils.o.genLayoutFromXML(battleTongguanLayout,CJBattleTongguanLayer);
			var battleResultlayer:CJBattleResultLayer = parent as CJBattleResultLayer;
			var battleTongguanLayer:CJBattleTongguanLayer = tongguanLayer as CJBattleTongguanLayer;
			battleTongguanLayer._juggler = battleResultlayer.juggler;
			battleTongguanLayer._tongguanParams = battleResultlayer.tongguanParams;
			
			//去除胜利动画，延迟启动通关动画
			battleTongguanLayer._juggler.delayCall(function (winLayer:CJBattleResultLayer):void
			{
				winLayer.removeFromParent();
				CJBattleMapManager.o.topLayer.addChild(tongguanLayer);
			},1, parent);
		}
	}
}