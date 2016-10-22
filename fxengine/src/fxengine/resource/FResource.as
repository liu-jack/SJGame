package fxengine.resource
{
	import lib.engine.utils.functions.Assert;
	
	import mx.collections.ArrayList;

	/**
	 * 资源基类 
	 * @author caihua
	 * 
	 */
	public class FResource
	{
		public static var FResTypeMin:int = 0;
		/**
		 * 位图类型 
		 */
		public static var FResType_Bitmap:int  = FResTypeMin++;
		/**
		 * PJson类型 
		 */
		public static var FResType_PJson:int =  FResTypeMin++;
		/**
		 * 初始化资源 
		 * @param resource
		 * 
		 */
		public function FResource()
		{
//			this.resource = resource;
		}
		
		
		
		private var _resType:int = FResTypeMin;

		/**
		 * 资源类型 
		 */
		public function get resType():int
		{
			return _resType;
		}
		
		protected var _resource:* = null;

		/**
		 * 资源引用 
		 */
		public function get resource():*
		{
			return _resource;
		}
		
		
		private var _loadInfo:FResourceLoaderInfo = null;

		/**
		 * 加载信息 
		 */
		protected function get loadInfo():FResourceLoaderInfo
		{
			return _loadInfo;
		}
		
		/**
		 * 加载完成回调 
		 */
		private var _loadCompleteFunction:Function = null;

		/**
		 * 资源构造器
		 * 
		 * 
		 */
		protected function _build():void
		{
			Assert(false,"override me!");
		}
		
		/**
		 * 加载完成回调 
		 * 
		 */
		protected function _buildComplete():void
		{
			//通知外部加载完成
			if(_loadCompleteFunction != null)
			{
				_loadCompleteFunction(_loadInfo,this);
				
			}
			//清除对象
			_loadCompleteFunction = null;
			_loadInfo = null;
		}
		
		protected function _canBuild():Boolean
		{
			Assert(false,"override me!");
			return false;
		}
		
		
		/**
		 *
		 * 资源构造器 
		 * @param loadInfo 加载信息
		 * @param loadComplete 加载完成(loadInfo:FResourceLoaderInfo,resource:FResource):void
		 * @return 
		 * 
		 */
		public static function builder(loadInfo:FResourceLoaderInfo,loadComplete:Function):void
		{
			var arrOfBuilder:ArrayList = new ArrayList();
			
			//增加注册
			arrOfBuilder.addItem(new FResourceBitmapData());
			arrOfBuilder.addItem(new FResourcePJson());
			
			
			
			
			for(var i:int ;i< arrOfBuilder.length;i++)
			{

				var mbuilder:FResource = arrOfBuilder.getItemAt(i) as FResource;
				mbuilder._loadInfo = loadInfo;
				mbuilder._loadCompleteFunction = loadComplete;
				
				if(mbuilder._canBuild())
				{
					mbuilder._build();
					break;
				}
			}
		
		}
		
		
	}
}