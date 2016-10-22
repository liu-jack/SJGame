package engine_starling.data
{
	import engine_starling.Events.DataEvent;

	/**
	 * 远程数据基类,可以通过调用一些远程方法 
	 * @author caihua
	 * 
	 */
	public class SDataBaseRemoteData extends SDataBase
	{
		public function SDataBaseRemoteData(dataBasename:String)
		{
			super(dataBasename);
		}
		
		protected var _dataIsEmpty:Boolean = true;
		
		/**
		 * 正在从远程加载数据 
		 */
		private var _onloadingFromRemote:Boolean = false;

		
		
		/**
		 * 数据是否为空,在getdata的时候,如果这个属性为true
		 * 则会自动触发通过网络获取的方法 
		 * loadFromRemote
		 */
		public function get dataIsEmpty():Boolean
		{
			return _dataIsEmpty;
		}

		/**
		 * 同步到远程 
		 * 
		 */
		public final function synToRemote(params:Object = null):void
		{
			_onSynToRemote(params);
		}
		
		/**
		 * 保存本地数据到远程服务器 
		 * @param params
		 * 
		 */
		protected function _onSynToRemote(params:Object = null):void{}
		/**
		 * 从远程获取 
		 * 可以手动出发
		 * getData 在 _dataIsEmpty == true 也会
		 * 触发 DataLoadedFromRemote 事件
		 */
		public final function loadFromRemote(params:Object = null):void
		{
			
			//单次是可以运行一次载入远程数据
			if(_onloadingFromRemote)
				return;
			_onloadingFromRemote = true;
			
			_onloadFromRemote(params);
		}
		/**
		 * 请求远程数据 
		 * @param params
		 * 
		 */
		protected function _onloadFromRemote(params:Object = null):void{}
		
		/**
		 * 从远程加载完毕数据,
		 * 必须调用这个函数 
		 * 
		 */
		protected final function _onloadFromRemoteComplete():void
		{
			_onloadingFromRemote = false;
			//标志为已经有数据了
			if(_dataIsEmpty == true)
			{
				_dataIsEmpty = false;
				this.dispatchEventWith(DataEvent.DataLoadedFromRemote);
				
			}
			
		}
		
		
		override public function delData(key:String):void
		{
			if(_dataIsEmpty)
			{
				return;
			}
			super.delData(key);
		}
		
		override public function getData(key:String,D:* = null):*
		{
			if(_dataIsEmpty)
			{
				loadFromRemote();
				return D;
			}
			return super.getData(key,D);
		}
		
	}
}