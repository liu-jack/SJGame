package lib.engine.game.Impact
{
	import lib.engine.game.object.GameObject;
	import lib.engine.iface.game.IGameUpdate;
	
	/**
	 * 游戏对象影响器管理器 
	 * @author caihua
	 * 
	 */
	public class GameObjectImpactManager implements IGameUpdate
	{
		
		private var _impactlist:Vector.<GameObjectImpact> = new Vector.<GameObjectImpact>();
		/**
		 * 添加队列 
		 */
		private var _impactAddList:Vector.<GameObjectImpact> = new Vector.<GameObjectImpact>();
		/**
		 * 删除队列 
		 */
		private var _impactRemoveList:Vector.<GameObjectImpact> = new Vector.<GameObjectImpact>();
		
		protected var _GameObject:GameObject;
		
		public function GameObjectImpactManager(mGameObject:GameObject)
		{
			_GameObject = mGameObject;
		}
		
		public function update(currenttime:Number, escapetime:Number):void
		{
			_onRemoveImpact();
			_onAddImpact();
			for each(var impact:GameObjectImpact in _impactlist)
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
			var mimpact:GameObjectImpact = null;
			while(null != (mimpact =_impactAddList.shift()))
			{
				var idx:int = _getimpactIndex(mimpact);
				if(idx != -1)
					continue;
				mimpact.Init(_GameObject,this);
				_impactlist.push(mimpact);
			}
		}
		
		protected function _onRemoveImpact():void
		{
			var mimpact:GameObjectImpact = null;
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
		protected function _getimpactIndex(Impact:GameObjectImpact):int
		{
			return _impactlist.lastIndexOf(Impact);
		}
		
		/**
		 * 添加影响器 
		 * @param Impact
		 * 
		 */
		public function AddImpact(Impact:GameObjectImpact):void
		{
			_impactAddList.push(Impact);
		}
		
		/**
		 * 删除影响器 
		 * @param Impact
		 * 
		 */
		public function removeImpact(Impact:GameObjectImpact):void
		{
			
			_impactRemoveList.push(Impact);
		}
		
		public function removeAllImpact():void
		{
			for each(var impact:GameObjectImpact in _impactlist)
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
			var mimpact:GameObjectImpact;
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
		public function getImpactByName(Impactname:String):GameObjectImpact
		{
			for each(var impact:GameObjectImpact in _impactlist)
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