package SJ.Game.onlineReward
{
	import SJ.Common.Constants.ConstOnlineReward;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfOLReward;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	
	
	public class CJOLRewardMenu extends SLayer
	{
		/** 时间间隔 **/
		private const TIME_GAP:uint = 1;
		// 时间 每个一秒调用一次逻辑
		private var _oldTime:Number = 0;
		private var _newTime:Number = 0;
		
		private var _btn:Button;
		// 显示文字
		private var _label:Label;
		private var _filter:ColorMatrixFilter;
		
		public function CJOLRewardMenu()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this._genDownSimulateFilter();
			_doInit();
		}
		
		private function _genDownSimulateFilter():void
		{
			_filter = new ColorMatrixFilter();
			_filter.matrix = Vector.<Number>([
				1,0,0,0,0,
				0,1,0,0,0,
				0,0,1,0,0,
				0,0,0,1,0
			]);
			_filter.adjustBrightness(-0.1); //亮度
		}
		
		// 释放
		override public function dispose():void
		{
			// 监听事件
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_OLREWARD_TICK, _tick);
			super.dispose();
			_filter.dispose();
		}
		
		private function _doInit():void
		{
			_btn = new Button;
			_btn.defaultSkin = new SImage( SApplication.assets.getTexture("gongnengzhenghe_zaixianlibao") );
			var img:Image = new SImage( SApplication.assets.getTexture("gongnengzhenghe_zaixianlibao") );
			img.filter = _filter;
			_btn.downSkin = img;
			_btn.addEventListener(Event.TRIGGERED, function (e:*):void{
				SApplication.moduleManager.enterModule("CJOLRewardModul", {"menu":this});
			});
			addChild(_btn);
			
			_label = new Label;
			_label.x = 7;
			_label.y = 9;
			_label.textRendererProperties.textFormat = ConstTextFormat.textformatwhitecenter;
			_label.textRendererFactory = textRender.standardTextRender;
			addChild(_label);
			_label.text = CJLang("ONLINE_REWARD_RECEIVE");
			_label.touchable = false;
			_label.visible = false;
			
			// 监听事件
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_OLREWARD_TICK, _tick);
		}
		
		/**
		 * 每隔一段时间添加一次
		 * @param time
		 */
		private function _tick():void
		{
			var dataofOLReward:CJDataOfOLReward = CJDataManager.o.DataOfOLReward;
			if (dataofOLReward.dataIsEmpty)
				return;
			
			// 是否已领取所有奖励
			_label.visible = false;
			var isReceiveAll:Boolean = true;
			if (dataofOLReward.receiverewardlist.length < int(dataofOLReward.rewardid))
			{
				isReceiveAll = false;
				_label.visible = true;
			}
			
			if (int(dataofOLReward.rewardid) == ConstOnlineReward.ConstMaxOnlineRewardCount && isReceiveAll)
			{
				Starling.juggler.remove(CJDataManager.o.DataOfOLReward);
				CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_OLREWARD_TICK, _tick);
				return;
			}
			
		}
	}
}