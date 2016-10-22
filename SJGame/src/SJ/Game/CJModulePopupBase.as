package SJ.Game
{
	import SJ.Game.core.CJModuleSubSystem;
	
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * 所有弹出类型Module的基类
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-28 下午7:23:35  
	 +------------------------------------------------------------------------------
	 */
	public class CJModulePopupBase extends CJModuleSubSystem
	{
		public function CJModulePopupBase(name:String)
		{
//			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_INDICATE_ENTER , this._onEnterIndicate);
		}
		
		/**
		 * BUG。武将升阶，两个页面是两个模块 ， 三个同样的模块。
		 */ 
		private function _onEnterIndicate(e:Event):void
		{
			//没进入过的模块直接返回
//			if(!this.onEntered)
//			{
//				return;
//			}
//			//如果指引的模块 ！= CJHeroTrainModule ，关闭CJHeroTrainModule
//			if(this.name == "CJHeroTrainModule" && CJDataManager.o.DataOfFuncList.currentIndicatingModule.indexOf("CJHeroTrainModule") == -1)
//			{
//				this.Exit();
//			}
		}
		
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
//			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_INDICATE_ENTER , this._onEnterIndicate);
		}
	}
}