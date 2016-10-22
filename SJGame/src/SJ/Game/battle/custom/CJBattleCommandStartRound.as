package SJ.Game.battle.custom
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstBattle;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.battle.CJBattlePlayerData;
	import SJ.Game.battle.CJBattleReplayManager;
	import SJ.Game.lang.CJLang;
	import SJ.Game.map.CJBattleMapManager;
	
	import engine_starling.SApplicationConfig;
	import engine_starling.commandSys.core.SCommandBase;
	import engine_starling.commandSys.core.SCommandBaseData;
	
	import feathers.controls.Label;
	
	/**
	 * 回合开始 
	 * @author caihua
	 * 
	 */
	public class CJBattleCommandStartRound extends SCommandBase
	{
		public function CJBattleCommandStartRound()
		{
			super(ConstBattle["CommandStartRound"], CJBattleCommandStartRoundData);
		}
		
		override protected function execute(battleData:SCommandBaseData):void
		{
			executeEndImmediately();
			var roundNum:Label = CJBattleMapManager.o.topLayer.getChildByName("roundNum") as Label;
			if(roundNum == null)
			{
				roundNum = new Label();
				roundNum.name = "roundNum";
				roundNum.width = SApplicationConfig.o.stageWidth;
				roundNum.y = 2;
				var tf:TextFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 8, 0xFFFFFF, null,null,null,null,null, TextFormatAlign.CENTER);
				roundNum.textRendererProperties.textFormat = tf;
				roundNum.textRendererFactory = textRender.glowTextRender;
				CJBattleMapManager.o.topLayer.addChild(roundNum);
			}
			var round:String = battleData.params.params.toString();
			roundNum.text = CJLang("BATTLE_WHICH") + (parseInt(round) + 1) + CJLang("BATTLE_ROUND");
			
			//如果当前回合释放技能, 则加入光圈	
			var mgr:CJBattleReplayManager = battleData.params.mgr;
			var count:int = mgr.battleJsonObject.battle.length;
			var startSet:Boolean = false;
			for(var i:int = 0; i < count; i++)
			{
				var battle:Object = mgr.battleJsonObject.battle[i];
				if((battle.cmd == "CommandStartRound") && (battle.info == round) && (round == "0"))
				{
					startSet = true;
					continue;
				}
				else if(battle.cmd == "CommandEndRound" && startSet)
				{
					break;
				}
				else if(battle.cmd == "CommandNpcBattle" && startSet)
				{
					var _moveHero:CJBattlePlayerData = mgr.getPlayer(battle.info.heroid);
					var bSkillAttack:Boolean = Boolean(parseInt(battle.info.bSkillAttack));
					_moveHero.playerSprite.setGuangquan(bSkillAttack);
				}
			}
			
			super.execute(battleData);
		}
		
		
	}
}