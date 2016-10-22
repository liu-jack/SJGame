package lib.engine.ui.impact
{
	import lib.engine.event.CEvent;
	import lib.engine.event.CEventSubject;
	import lib.engine.event.CEventVar;
	import lib.engine.iface.game.IGameUpdate;
	import lib.engine.ui.uicontrols.XDG_UI_Control;
	import lib.engine.utils.CTimerUtils;

	public class UI_Impact extends CEventSubject implements IGameUpdate
	{
		protected var _mainControl:XDG_UI_Control;
		protected var _ImpactMgr:UI_ImpactManager;
		protected var _bInit:Boolean = false;
		private var _name:String = "";
		private var _lefttime:Number = 0;
		private var _autodelete:Boolean = false;
		public function UI_Impact()
		{
			_name = "UI_Impact_" + CTimerUtils.getCurrentTime() + "_"+Math.random();
		}
		
		/**
		 * 初始化影响器 
		 * @param mainControl
		 * 
		 */
		public final function Init(mainControl:XDG_UI_Control,ImpactMgr:UI_ImpactManager):void
		{
			if(_bInit)
				return;
			_bInit = true;
			
			_mainControl = mainControl;
			_ImpactMgr = ImpactMgr;
			
			_onInit();
			this.dispatchEvent(new CEvent(CEventVar.E_UI_IMPACT_START,{'obj':this}));
		
		}
		
		/**
		 * 初始化 
		 * 
		 */
		protected function _onInit():void
		{
			
		}
		
		public function update(currenttime:Number, escapetime:Number):void
		{
			// TODO Auto Generated method stub
			
		}
		
		/**
		 * 删除自身 
		 * 
		 */
		public final function deleteself():void
		{
			_ImpactMgr.removeImpact(this);
		}
		public final function NotifyDelete():void
		{
			onDelete();
			this.dispatchEvent(new CEvent(CEventVar.E_UI_IMPACT_END,{'obj':this,'manager':_ImpactMgr}));
			
		}
		protected function onDelete():void
		{
			
			
		}

		/**
		 *是否在_lefttime为0 或者小于0的时候自动删除 
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

		public function get lefttime():Number
		{
			return _lefttime;
		}

		public function set lefttime(value:Number):void
		{
			_lefttime = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		
	}
}