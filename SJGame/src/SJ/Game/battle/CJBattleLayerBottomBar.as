package SJ.Game.battle
{
	import SJ.Game.map.CJBattleMapManager;
	
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	import engine_starling.utils.SDisplayUtils;
	
	import feathers.controls.Button;
	
	import starling.display.Image;

	public class CJBattleLayerBottomBar extends SLayer
	{
		private var _bottomBarImage:Image;
		/**
		 * 技能按钮 
		 */
		private var _iconButtons:Vector.<Button>;
		public function CJBattleLayerBottomBar()
		{
			super();
			
			_initLayer();
			
		}
		
		private function _initLayer():void
		{
//			var bgImage:Image = new Image(SApplication.assets.getTexture("common_battle0"));
//			var bgImage:Image = new Image(starling.textures.Texture.fromColor(1,1));
//			bgImage.pivotX = bgImage.width/2;
//			bgImage.pivotY = bgImage.height/2;
			
//			SDisplayUtils.setAnchorPoint(bgImage);
//			bgImage.x =  bgImage.width/2;
//			bgImage.y = bgImage.height/2;
//			CJBattleMapManager.o.backgroundLayer.addChild(bgImage);
			
			return;
			
//			_bottomBarImage = new Image(SApplication.assets.getTexture("zhandou_ui"));
////			addChild(_bottomBarImage);
//			setSize(_bottomBarImage.width,_bottomBarImage.height);
//			
//			_iconButtons = new Vector.<Button>();
//			
//			
//			var length:int = 6;
//			var buttonOfSkill:Button = null;
//			var spaceOfWidth:int = 1;
//			var basex:int = 66/2;
//			var basey:int = 74/2;
//			for(var i:int = 0;i<length;i++)
//			{
//				
//				var skillData:Object = CJDataOfSkillSettting.o.getProperty(i%4);
//				
//				if(skillData == null)
//					continue;
//				buttonOfSkill = new Button();
//		
//				
//				var iconName:String = skillData['skillicon'];
//				
//				buttonOfSkill.defaultSkin = new Image(Texture.empty());
////				buttonOfSkill.defaultSkin = new Image(SApplication.assets.getTexture(iconName));
//				buttonOfSkill.x = basex + i * (buttonOfSkill.defaultSkin.width + spaceOfWidth);
//				buttonOfSkill.y = basey;
//				
//				buttonOfSkill.addEventListener(Event.TRIGGERED,_onClickSkillButton);
//				_iconButtons.push(buttonOfSkill);
//			}
//			addEventListener(Event.ADDED_TO_STAGE,_onAddToStage);
		}
		
//		private function _onAddToStage(e:*):void
//		{
//			var length:int = _iconButtons.length;
//			var buttonOfSkill:Button = null;
//			for(var i:int = 0;i<length;i++)
//			{
//				buttonOfSkill = _iconButtons[i];
//				addChild(buttonOfSkill);
//				buttonOfSkill.validate();
//			}
//			validate();
//			
//		}
//		
//		private function _onClickSkillButton(e:Event):void
//		{
//			if(_onfinish != null)
//			{
//				var length:int = 0 ;
//				var selfplayer:CJBattlePlayerData = CJBattleMananger.o.battleDataBySelfLocationIndex(ConstBattle.ConstMaxLocationNum);
//				selfplayer.selectedSkill = _iconButtons.indexOf(e.currentTarget);
//				
//				_onfinish();
//				_onfinish = null;
//			}
//		}
//		private var _onfinish:Function;
//		public function show(onfinish:Function):void
//		{
//			_onfinish = onfinish;
//		}
		
		
	}
}