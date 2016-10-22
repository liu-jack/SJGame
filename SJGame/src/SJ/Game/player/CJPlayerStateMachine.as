package SJ.Game.player
{
	import SJ.Common.Constants.ConstPlayerState;
	
	import engine_starling.stateMachine.StateMachine;
	
	public class CJPlayerStateMachine extends StateMachine
	{
		private var _owner:CJPlayerBase;
		public function CJPlayerStateMachine(owner:CJPlayerBase)
		{
			super();
			id = "CJPlayerStateMachine";
			_owner = owner;
			_initMap();
		}
		
		public override function dispose():void
		{
			_owner = null;
			super.dispose();
		}
		
		private function _initMap():void
		{
			addState(ConstPlayerState.SConstPlayerStateNone,{from:"*"})
			
			addState(ConstPlayerState.SConstPlayerStateSceneIdle,
				{ enter:_owner._onstate_sceneidle,  from:"*" });
			
			addState(ConstPlayerState.SConstPlayerStateIdle,
				{ enter:_owner._onstate_idle,  from:"*" });
			
			addState(ConstPlayerState.SConstPlayerStateRun,
				{ enter: _owner._onstate_run,  from: [ConstPlayerState.SConstPlayerStateIdle,
					ConstPlayerState.SConstPlayerStateSceneIdle]});
			
			//起手状态
			addState(ConstPlayerState.SConstPlayerStateAttackBegin,
				{ enter: _owner._onstate_attackbegin,  from: [ConstPlayerState.SConstPlayerStateIdle,
					ConstPlayerState.SConstPlayerStateUnderAttack]});
			
			addState(ConstPlayerState.SConstPlayerStateShanIn,
				{ enter: _owner._onstate_shanin,  from: [ConstPlayerState.SConstPlayerStateIdle,ConstPlayerState.SConstPlayerStateAttack,ConstPlayerState.SConstPlayerStateAttackBegin]});
			
			addState(ConstPlayerState.SConstPlayerStateShanOut,
				{ enter: _owner._onstate_shanout,  from: ConstPlayerState.SConstPlayerStateShanIn});
			
			
			addState(ConstPlayerState.SConstPlayerStateUnderAttack,
				{enter:_owner._onstate_underAttack,from:ConstPlayerState.SConstPlayerStateIdle});
			
			addState(ConstPlayerState.SConstPlayerStateAttack,
				{ enter: _owner._onstate_attack, from:[ConstPlayerState.SConstPlayerStateAttackBegin,ConstPlayerState.SConstPlayerStateIdle,ConstPlayerState.SConstPlayerStateRun,
					ConstPlayerState.SConstPlayerStateShanOut] });
			
			addState(ConstPlayerState.SConstPlayerStateSkill1,
				{ enter: _owner._onstate_skill1, from:ConstPlayerState.SConstPlayerStateSkillBegin });
			
			addState(ConstPlayerState.SConstPlayerStateSkill2,
				{ enter: _owner._onstate_skill2, from:ConstPlayerState.SConstPlayerStateSkillBegin });
			
			addState(ConstPlayerState.SConstPlayerStateSkillBegin,
				{ enter: _owner._onstate_skillbegin, from:[ConstPlayerState.SConstPlayerStateUnderAttack,
					ConstPlayerState.SConstPlayerStateIdle,ConstPlayerState.SConstPlayerStateRun] });
			

			
			addState(ConstPlayerState.SConstPlayerStateWin,
				{ enter: _owner._onstate_win, from:[ConstPlayerState.SConstPlayerStateIdle,ConstPlayerState.SConstPlayerStateRun] });
			
			addState(ConstPlayerState.SConstPlayerStateLose,
				{ enter: _owner._onstate_win, from:[ConstPlayerState.SConstPlayerStateIdle,ConstPlayerState.SConstPlayerStateRun] });
			
			addState(ConstPlayerState.SConstPlayerStateJump,
				{ enter: _owner._onstate_jump, from:[ConstPlayerState.SConstPlayerStateIdle] });
			
			addState(ConstPlayerState.SConstPlayerStatexuanyun,
				{ enter: _owner._onstate_xuanyun, from:[ConstPlayerState.SConstPlayerStateUnderAttack] });
			
			addState(ConstPlayerState.SConstPlayerStateDead,
				{ enter:_owner._onstate_dead,from:[ConstPlayerState.SConstPlayerStateUnderAttack,ConstPlayerState.SConstPlayerStateIdle]});
			
			
			addState(ConstPlayerState.SConstPlayerStateRideIdle,
				{ enter:_owner._onstate_rideidle,from:[ConstPlayerState.SConstPlayerStateIdle,
					ConstPlayerState.SConstPlayerStateRideRun,
					ConstPlayerState.SConstPlayerStateSceneIdle]});
			
			addState(ConstPlayerState.SConstPlayerStateRideRun,
				{ enter:_owner._onstate_riderun,from:[ConstPlayerState.SConstPlayerStateRideIdle]});
			
			
		
		}
		
		
	}
}