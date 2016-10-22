package lib.engine.ui.impact
{
	import lib.engine.iface.game.IGameUpdate;
	import lib.engine.ui.uicontrols.XDG_UI_Control;
	
	/**
	 * UI影响器管理器 
	 * @author caihua
	 * 
	 */
	public class UI_ImpactManager implements IGameUpdate
	{
		private var _impactlist:Vector.<UI_Impact> = new Vector.<UI_Impact>();
		/**
		 * 添加队列 
		 */
		private var _impactAddList:Vector.<UI_Impact> = new Vector.<UI_Impact>();
		/**
		 * 删除队列 
		 */
		private var _impactRemoveList:Vector.<UI_Impact> = new Vector.<UI_Impact>();
		
		protected var _mainControl:XDG_UI_Control;
		
		public function UI_ImpactManager(mainControl:XDG_UI_Control)
		{
			_mainControl = mainControl;
		}
		
		
		
		public function update(currenttime:Number, escapetime:Number):void
		{
			_onRemoveImpact();
			_onAddImpact();
			
			
			for each(var impact:UI_Impact in _impactlist)
			{
				if(impact.autodelete)
				{
					impact.lefttime -= escapetime;
					if(impact.lefttime <= 0)
					{
						impact.deleteself();
						continue;
					}
					
				}
				impact.update(currenttime,escapetime);
			}
		}
		
		protected function _onAddImpact():void
		{
			var mimpact:UI_Impact = null;
			while(null != (mimpact =_impactAddList.shift()))
			{
				var idx:int = _getimpactIndex(mimpact);
				if(idx != -1)
					continue;
				mimpact.Init(_mainControl,this);
				_impactlist.push(mimpact);
			}
		}
		
		protected function _onRemoveImpact():void
		{
			var mimpact:UI_Impact = null;
			while(null != (mimpact =_impactRemoveList.shift()))
			{
				var idx:int = _getimpactIndex(mimpact);
				if(idx == -1)
					continue;
				
				mimpact.NotifyDelete();
				_impactlist.splice(idx,1);
			}
		}
		/**
		 * 获得影响器索引, 
		 * @param Impact 影响器
		 * @return -1没有找到,其它值已经有了
		 * 
		 */
		protected function _getimpactIndex(Impact:UI_Impact):int
		{
			return _impactlist.lastIndexOf(Impact);
		}
		
		/**
		 * 添加影响器 
		 * @param Impact
		 * 
		 */
		public function AddImpact(Impact:UI_Impact):void
		{
			_impactAddList.push(Impact);
		}
		
		/**
		 * 删除影响器 
		 * @param Impact
		 * 
		 */
		public function removeImpact(Impact:UI_Impact):void
		{
			
			_impactRemoveList.push(Impact);
		}
		
		public function removeAllImpact():void
		{
			for each(var impact:UI_Impact in _impactlist)
			{
				removeImpact(impact);
			}
		}
		/**
		 * 强制删除所有影响器 
		 * 
		 */
		public function removeAllImpaceforce():void
		{
			var mimpact:UI_Impact
			while(null != (mimpact = _impactAddList.pop())){
				//通知删除
				mimpact.NotifyDelete();
			};
			while(null != (mimpact = _impactRemoveList.pop())){
				//通知删除
				mimpact.NotifyDelete();
			};
			
			while(null != (mimpact = _impactlist.pop())){
				//通知删除
				mimpact.NotifyDelete();
			};
		}
		
		/**
		 * 通过名称获取影响器 
		 * @param Impactname
		 * @return 
		 * 
		 */
		public function getImpactByName(Impactname:String):UI_Impact
		{
			for each(var impact:UI_Impact in _impactlist)
			{
				if(Impactname == impact.name)
				{
					return impact;
				}
			}
			return null;
		}
	}
}