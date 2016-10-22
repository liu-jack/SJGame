package SJ.Game.StageLevel
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.player.CJPlayerData;
	import SJ.Game.player.CJPlayerNpc;
	import SJ.Game.player.CJPlayerTitleLayer;
	
	import engine_starling.SApplication;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SLayer;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.STween;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	/**
	 * 武将形象从一个旧形象渐变为新形象
	 * @author longtao
	 */
	public class CJStageChangeImage extends SLayer
	{
		/** 渐隐时间 **/
		private static const _FADEOUT_TIME_:Number = 1;
		/** 渐隐之前等待时间 **/
		private static const _FADEOUT_DELAY_TIME_:Number = 1;
		
		/** 渐隐形象tid **/
		private var _oldtid:String;
		/** 渐现形象ted **/
		private var _newtid:String;
		
		private var _isExit:Boolean;
		
		/** 武将形象 **/
		private var _animate_hero:CJPlayerNpc;
		
		/** 渐隐 **/
		private var _fadeout:STween;
		
		private var _animate:SAnimate;
		
		private var _animateBG:SAnimate;
		
		/**
		 * 武将形象从一个旧形象渐变为新形象
		 * @param oldtid	旧形象
		 * @param newtid	新形象
		 * 
		 */
		public function CJStageChangeImage(oldtid:*, newtid:*)
		{
			super();
			
			_oldtid = String(oldtid);
			_newtid = String(newtid);
			
			touchable = false;
			// 初始化旧武将形象
			var playerData:CJPlayerData = new CJPlayerData();
			playerData.heroId = "0";
			playerData.templateId = uint(oldtid);
			_animate_hero = new CJPlayerNpc(playerData , null);
			_animate_hero.lodlevel = CJPlayerNpc.LEVEL_LOD_1;
			_animate_hero.hideTitle(CJPlayerTitleLayer.TITLETYPE_ALL);
			_animate_hero.x = 0;
			_animate_hero.y = 0;
			_animate_hero.hidebattleInfo();
			_animate_hero.touchable = false; // 使该控件不可触控
			addChild(_animate_hero);

			// 渐隐补间
			_fadeout = new STween(_animate_hero, _FADEOUT_TIME_);
			_fadeout.delay = _FADEOUT_DELAY_TIME_;
			_fadeout.animate("alpha", 0);
			_fadeout.onComplete = _onfadeoutComplete;
			Starling.juggler.add(_fadeout);
		}
		
		/** 渐隐完成 **/
		private function _onfadeoutComplete():void
		{
			// 移除
			_animate_hero.removeFromParent();
			Starling.juggler.remove(_fadeout);
			
			if (_isExit)
				return;
			
			// 添加新形象后的脚下光
			var animObject:Object = AssetManagerUtil.o.getObject("anim_stagelevel_change");
			if (animObject!=null)
			{
				_animateBG =SAnimate.SAnimateFromAnimJsonObject(animObject);
				_animateBG.gotoAndPlay();
				addChild(_animateBG);
				
				Starling.juggler.add(_animateBG);
			}

			// 新形象添加
			var playerData:CJPlayerData = new CJPlayerData();
			playerData.heroId = "0";
			playerData.templateId = uint(_newtid);
			_animate_hero = new CJPlayerNpc(playerData , null);
			_animate_hero.lodlevel = CJPlayerNpc.LEVEL_LOD_1;
			_animate_hero.hidebattleInfo();
			_animate_hero.hideTitle(CJPlayerTitleLayer.TITLETYPE_ALL);
			_animate_hero.x = 0;
			_animate_hero.y = 0;
			_animate_hero.touchable = false; // 使该控件不可触控
			addChild(_animate_hero);
			
			_animate = new SAnimate(SApplication.assets.getTextures(ConstResource.sResUplevelAnims));
			_animate.pivotY = 110;
			_animate.pivotX = 80;
			_animate.scaleX = _animate.scaleY = 1.5;
			Starling.juggler.add(_animate);
			_animate.gotoAndPlay();
			addChild(_animate);
			_animate.addEventListener(Event.COMPLETE , function(e:Event):void
			{
				if(e.target is SAnimate)
				{
					_animate.removeFromParent();
					_animate.removeFromJuggler();
					
					CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_STAGE_LEVEL_IMAGE_COMPLETE);
				}
			});
		}
		
		/**
		 * 退出
		 * */
		public function exit():void
		{
			_isExit = true;
			
			if(_animateBG)
				Starling.juggler.remove(_animateBG);
		}
		
		
	}
}