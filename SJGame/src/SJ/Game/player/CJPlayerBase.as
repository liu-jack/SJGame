package SJ.Game.player
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstPlayerState;
	import SJ.Game.event.CJEvent;
	import SJ.Game.map.CJPlayerSceneLayer;
	
	import engine_starling.SApplication;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SNode;
	import engine_starling.stateMachine.StateMachineEvent;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.animation.Juggler;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.events.Event;
	
	/**
	 * 玩家基础类 
	 * @author caihua
	 * 
	 */
	public class CJPlayerBase extends SNode
	{
		/**
		 * 是否被释放 
		 */
		private var _movieclips:Dictionary;
		private var _currentMovieclip:SAnimate = null;
		protected var _smc:CJPlayerStateMachine = null;
		protected var _params:Object = null;
		
		
		private var _fps:int = 30;

		/**
		 * fps 
		 */
		public function get fps():int
		{
			return _fps;
		}

		/**
		 * @private
		 */
		public function set fps(value:int):void
		{
			_fps = value;
			for each(var movie:MovieClip in _movieclips);
			{
				movie.fps = _fps;
			}
		}

		
		/**
		 * 背景层 1
		 */
		protected var _bgNode:SNode;
		/**
		 * 人物动画层 2
		 */
		protected var _animsNode:SNode;
		
		/**
		 * 坐骑层 
		 */
		protected var _rideNode:SNode;
		/**
		 * 前景层 
		 */
		protected var _frontNode:SNode;
		
		/**
		 * 加载节点 
		 */
		protected var _loadingNode:SNode;
		
		/**
		 * 用户UI层 3
		 */
		protected var _PlayerBattleUINode:SNode;
		
		/**
		 * 玩家头部层 
		 */
		protected var _PlayerTitleLayer:CJPlayerTitleLayer;
		/**
		 * 碰撞层 4
		 */
		protected var _touchNode:SNode;
		
		/**
		 * 调试层 5
		 */
		protected var _debugNode:SNode;
		
		protected var _resourceLoaded:Boolean = false;
		
		protected var _jugger:Juggler;

		/**
		 * 当前播放的动画 
		 */
		protected function get currentMovieclip():SAnimate
		{
			return _currentMovieclip;
		}

		
		public function CJPlayerBase()
		{
			super();
			
			_movieclips = new Dictionary();
			this.addChild(_bgNode = new SNode());
			this.addChild(_rideNode = new SNode());
			this.addChild(_animsNode = new SNode());
			this.addChild(_frontNode = new SNode());
			this.addChild(_loadingNode = new SNode());
			this.addChild(_PlayerBattleUINode = new SNode());
			this.addChild(_PlayerTitleLayer = new CJPlayerTitleLayer());
			
			
			this.addChild(_touchNode = new SNode());
			this.addChild(_debugNode = new SNode());
			
			
			
			_bgNode.touchable = false;
			_rideNode.touchable = false;
			_loadingNode.touchable = false;
			_PlayerBattleUINode.touchable = false;
			_animsNode.touchable = false;
			_PlayerTitleLayer.touchable = false;
			_frontNode.touchable = false;
			//@caihua 初始npc没有加载完成前，不能点击
			_touchNode.touchable = false;
			mouseQuickEventEnable = true;
			_initPlayer();
			
		}
		
		override public function set scaleX(value:Number):void
		{
			// TODO Auto Generated method stub
			if(value < 0)
				_PlayerTitleLayer.scaleX = -1;
			else
				_PlayerTitleLayer.scaleX = 1;
			super.scaleX = value;
		}
		

		/**
		 * 显示标题啥的 
		 * @param flag CJPlayerTitleLayer.TITLETYPE
		 * 
		 */
		public function showTitle(flag:uint):void
		{
			_PlayerTitleLayer.showtitle(flag);
		}
		public function hideTitle(flag:uint):void
		{
			_PlayerTitleLayer.hidetitle(flag);
		}
		
		/**
		 * 清除所有的标题
		 */		
		public function hideAllTitle():void
		{
			_PlayerTitleLayer.hidetitle();
		}
		
		/**
		 * 隐藏战斗信息 
		 * 血条,冒字啥的
		 */
		public function hidebattleInfo():void
		{
			_PlayerBattleUINode.visible = false;
		}
		/**
		 * 显示战斗信息 
		 * 
		 */
		public function showbattleInfo():void
		{
			_PlayerBattleUINode.visible = true;
		}
		
		override protected function initialize():void
		{
			_loadResource();
			super.initialize();
		}
		
		protected function _initPlayer():void
		{
			_smc = new CJPlayerStateMachine(this);
			_smc.initialState = ConstPlayerState.SConstPlayerStateNone;
			
			var loadingImage:Image = new Image(SApplication.assets.getTexture("heroloading"));
			loadingImage.pivotY = loadingImage.height;
			loadingImage.pivotX = loadingImage.width / 2;
			_loadingNode.addChild(loadingImage);
			
			_PlayerTitleLayer.y = -loadingImage.height;
			
		}
		/**
		 * 开始加载资源 
		 * 
		 */
		protected function _loadResource():void
		{
			
		}
		private var _onloadResourceCompleted:Function;

		/**
		 * 资源加载完成 
		 */
		public function get onloadResourceCompleted():Function
		{
			return _onloadResourceCompleted;
		}

		/**
		 * @private
		 */
		public function set onloadResourceCompleted(value:Function):void
		{
			_onloadResourceCompleted = value;
		}

		/**
		 * 资源加载完成 
		 * 
		 */
		protected function _loadResourceCompleted():void
		{
			
			_resourceLoaded = true;
			_loadingNode.visible = false;
			_touchNode.touchable = true;
			
			//加载完成
			if (_onloadResourceCompleted != null)
			{
				if(_onloadResourceCompleted.length == 0)
				{
					_onloadResourceCompleted()
				}
				else if(_onloadResourceCompleted.length == 1)
				{
					_onloadResourceCompleted(this)
				}
			}
			
			if(_smc.state == ConstPlayerState.SConstPlayerStateNone)
			{
				idle()
			}
		}
		
		/**
		 * 设置影片片段 
		 * @param movieKey
		 * @param movie
		 * 
		 */
		protected final function _setMovie(movieKey:String,movie:SAnimate):void
		{
			_movieclips[movieKey] = movie;
		}
		protected final function _getMoive(movieKey:String):SAnimate
		{
			if(_movieclips && !_movieclips.hasOwnProperty(movieKey))
			{
				_loadAnim(movieKey);
			}
			return _movieclips[movieKey];
		}
		
		/**
		 * 加载动画，子类需要重载 
		 * @param animName
		 * 
		 */
		protected function _loadAnim(animName:String):void
		{
			
		}
		/**
		 * 播放影片
		 * @param movieIndex
		 * 
		 */
		protected final function _playMovie(moviekey:String,isLoop:Boolean = true):void
		{
			Assert(_resourceLoaded == true,"资源正在加载中!!")
			if(!_resourceLoaded || _movieclips == null)
				return;

			
			
			if(_currentMovieclip != null)
			{
				_currentMovieclip.removeFromJuggler();
				_currentMovieclip.removeFromParent();
				_currentMovieclip.removeEventListeners();
				_currentMovieclip = null;
				
			}
			
			_currentMovieclip = _getMoive(moviekey);
			if(_currentMovieclip!=null)
			{
				_animsNode.addChild(_currentMovieclip);
				_currentMovieclip.loop = isLoop;
				
				_jugger.add(_currentMovieclip);
				_currentMovieclip.gotoAndPlay();
			}
			//通知动画开始播放
			dispatchEventWith(CJEvent.Event_PlayerAnimStart,false,moviekey);
			
		}
		
		override public function set x(value:Number):void
		{
			// TODO Auto Generated method stub
			super.x = value;
		}
		private var _needAutoSort:Boolean = true;

		/**
		 * 是否需要自动按照Y排序 
		 */
		public function get needAutoSort():Boolean
		{
			return _needAutoSort;
		}

		/**
		 * @private
		 */
		public function set needAutoSort(value:Boolean):void
		{
			_needAutoSort = value;
		}

		override public function set y(value:Number):void
		{
			// TODO Auto Generated method stub
			if(super.y == value)
				return;
			var _bSort:Boolean = false;
			if(int (value) / 10 != int(y)/10)
			{
				if(_needAutoSort){
					_bSort = true;
				}
			}
			super.y = value;
			if(_bSort)
				sort();
		}
		
		public function sort():void
		{
			if(parent != null && parent is CJPlayerSceneLayer)
			{
				(parent as CJPlayerSceneLayer).sortPlayer();
			}
//			若返回值为负，则表示 A 在排序后的序列中出现在 B 之前。
//			若返回值为 0，则表示 A 和 B 具有相同的排序顺序。
//			若返回值为正，则表示 A 在排序后的序列中出现在 B 之后。

//			if(this.parent != null)
//			{
//				this.parent.sortChildren(function(a:DisplayObject,b:DisplayObject):int
//				{
//					
//						if(a.y< b.y)
//						{
//							return -1;
//						}
//						else if(a.y == b.y)
//						{
//							return 0;
//						}
//						else
//						{
//							return 1;
//						}
//					
//				});
//			}
		}
		
		
		override public function dispose():void
		{
			if(_currentMovieclip != null)
				_currentMovieclip.removeFromJuggler();
			
			_movieclips = null;
			_currentMovieclip = null;
			if(_smc) _smc.dispose();
			_smc = null;
			_onloadResourceCompleted = null;
			super.dispose();
		}
		
		
		public final function attack():void
		{
			_smc.changeState(ConstPlayerState.SConstPlayerStateAttack);
		}
		
		public function underAttack(params:Object = null):void
		{
			_params = params;
			_smc.changeState(ConstPlayerState.SConstPlayerStateUnderAttack);
			
		}
		public function sceneidle():void
		{
			_smc.changeState(ConstPlayerState.SConstPlayerStateSceneIdle);
		}
		public function idle():void
		{
			_smc.changeState(ConstPlayerState.SConstPlayerStateIdle);
		}
		
		public function run():void
		{
			_smc.changeState(ConstPlayerState.SConstPlayerStateRun);
		}
		
		public final function skill1(skillData:Object):void
		{
			_params = skillData;
			_smc.changeState(ConstPlayerState.SConstPlayerStateSkill1);
		}
		
		public final function skill2(skillData:Object):void
		{
			_params = skillData;
			_smc.changeState(ConstPlayerState.SConstPlayerStateSkill2);
		}
		
		/**
		 * 闪烁到指定位置 
		 * @param pos 闪烁到的位置
		 * @param _onFinish 完成函数回调
		 * @param arg 函数参数
		 * 
		 */
		public final function shan(pos:Point,_onFinish:Function,arg:Object = null):void
		{
			_params = {"dest":pos,"onFinish":_onFinish,"FinishArg":arg};
			_smc.changeState(ConstPlayerState.SConstPlayerStateShanIn);
		}
		
		
		
		public final function win():void
		{
			_smc.changeState(ConstPlayerState.SConstPlayerStateWin);
		}
		public final function lose():void
		{
			_smc.changeState(ConstPlayerState.SConstPlayerStateLose);
		}
		
		/**
		 * 死亡 
		 * 
		 */
		public final function dead():void{_smc.changeState(ConstPlayerState.SConstPlayerStateDead);}
		
		
		public final function jump():void
		{
			_smc.changeState(ConstPlayerState.SConstPlayerStateJump);
		}
		internal function _onstate_sceneidle(e:StateMachineEvent):void
		{
			_playMovie(_smc.state);
		}
		
		internal function _onstate_idle(e:StateMachineEvent):void
		{
			_playMovie(_smc.state);
		}
		internal function _onstate_run(e:StateMachineEvent):void
		{
			_playMovie(_smc.state);
		}
		internal function _onstate_shanin(e:StateMachineEvent):void
		{
			_playMovie(_smc.state);
			currentMovieclip.addEventListener(starling.events.Event.COMPLETE,function():void
			{
				var pos:Point = _params['dest'];
				x = pos.x;
				y = pos.y;
				
				_smc.changeState(ConstPlayerState.SConstPlayerStateShanOut);
			});
		}
		internal function _onstate_shanout(e:StateMachineEvent):void
		{
			_playMovie(_smc.state);
			currentMovieclip.addEventListener(starling.events.Event.COMPLETE,function():void
			{

				var _onFinish:Function = _params['onFinish'];
				var _onFinishArg:Object = _params['FinishArg'];
				_onFinish(_onFinishArg);
				
//				_smc.changeState(ConstPlayerState.SConstPlayerStateShanOut);
			});
		}
		internal function _onstate_attackbegin(e:StateMachineEvent):void
		{
			_playMovie(_smc.state,false);
		}
		internal function _onstate_attack(e:StateMachineEvent):void
		{
			_playMovie(_smc.state,false);
		}
		internal function _onstate_underAttack(e:StateMachineEvent):void
		{
			_playMovie(ConstPlayerState.SConstPlayerStateUnderAttack,false);
		}
		internal function _onstate_skillbegin(e:StateMachineEvent):void
		{
			_playMovie(_smc.state,false);
		}
		internal function _onstate_skill1(e:StateMachineEvent):void
		{
			_playMovie(_smc.state,false);
		}
		internal function _onstate_skill2(e:StateMachineEvent):void
		{
			_playMovie(_smc.state,false);
		}
		internal function _onstate_win(e:StateMachineEvent):void
		{
			_playMovie(_smc.state,false);
		}
		internal function _onstate_lose(e:StateMachineEvent):void
		{
			_playMovie(_smc.state,false);
		}
		internal function _onstate_jump(e:StateMachineEvent):void
		{
			_playMovie(_smc.state,false);
		}
		internal function _onstate_xuanyun(e:StateMachineEvent):void
		{
			_playMovie(_smc.state);
		}
		internal function _onstate_dead(e:StateMachineEvent):void
		{
			_playMovie(_smc.state,false);	
		}
		internal function _onstate_rideidle(e:StateMachineEvent):void
		{
			_playMovie(_smc.state,true);	
		}
		internal function _onstate_riderun(e:StateMachineEvent):void
		{
			_playMovie(_smc.state,true);	
		}
		
		
	}
}