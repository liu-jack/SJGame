package lib.engine.game.Impact
{
	import lib.engine.event.CEvent;
	import lib.engine.event.CEventSubject;
	import lib.engine.event.CEventVar;
	import lib.engine.game.object.GameObject;
	import lib.engine.iface.game.IGameUpdate;
	import lib.engine.utils.CTimerUtils;

	public class GameObjectImpact extends CEventSubject implements IGameUpdate
	{
		
		protected var _mGameObject:GameObject;
		protected var _ImpactMgr:GameObjectImpactManager;
		protected var _bInit:Boolean = false;
		private var _name:String = "";
		private var _lefttime:Number = 0;
		private var _autodelete:Boolean = false;
		
		public function GameObjectImpact()
		{
			_name = "GameObjectImpact_" + CTimerUtils.getCurrentTime() + "_"+Math.random();
		}
		
		public function update(currenttime:Number, escapetime:Number):void
		{
			
		}
		
		/**
		 * 初始化 
		 * 
		 */
		protected function _onInit():void
		{
			
		}
		
		/**
		 * 删除自身 
		 * 
		 */
		public final function deleteself():void
		{
			_ImpactMgr.removeImpact(this);
		}
		
		/**
		 * 通知删除,
		 * 如果删除,调用 deleteself
		 * 
		 */
		public final function NotifyDelete():void
		{
			onDelete();
			this.dispatchEvent(new CEvent(CEventVar.E_GAMEOBJECT_IMPACT_END,{'obj':this,'manager':_ImpactMgr}));
		}
		
		protected function onDelete():void
		{
			
		}
		/**
		 * 初始化影响器 
		 * @param mainControl
		 * 
		 */
		public final function Init(mGameObject:GameObject,ImpactMgr:GameObjectImpactManager):void
		{
			if(_bInit)
				return;
			_bInit = true;
			
			_mGameObject = mGameObject;
			_ImpactMgr = ImpactMgr;
			_onInit();
			
			this.dispatchEvent(new CEvent(CEventVar.E_GAMEOBJECT_IMPACT_START,{'obj':this}));
			
			
		}

		/**
		 * 宿主对象 
		 */
		public function get mGameObject():GameObject
		{
			return _mGameObject;
		}

		/**
		 * 影响器名称 
		 */
		public function get name():String
		{
			return _name;
		}

		/**
		 * @private
		 */
		public function set name(value:String):void
		{
			_name = value;
		}

		/**
		 * 生命时间 
		 */
		public function get lefttime():Number
		{
			return _lefttime;
		}

		/**
		 * @private
		 */
		public function set lefttime(value:Number):void
		{
			_lefttime = value;
		}

		/**
		 * 是否在_lefttime为0 或者小于0的时候自动删除 
		 */
		public function get autodelete():Boolean
		{
			return _autodelete;
		}

		/**
		 * @private
		 */
		public function set autodelete(value:Boolean):void
		{
			_autodelete = value;
		}

		
	}
}