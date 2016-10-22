package SJ.Game.data
{
	import SJ.Game.Platform.ISPlatfrom;
	import SJ.Game.Platform.SPlatformEvents;
	import SJ.MainApplication;
	
	import engine_starling.SApplication;
	import engine_starling.data.SDataBaseRemoteData;
	
	import starling.events.Event;
	
	/**
	 * 充值数据
	 * @author sangxu
	 * 
	 */
	public class CJDataOfPlatformProducts extends SDataBaseRemoteData
	{
		public function CJDataOfPlatformProducts()
		{
			super("CJDataOfPlatformProducts");
			_dataArray = new Array();
			_init();
		}
		private var _dataArray:Array;
		private var iPlatform:ISPlatfrom;
		
		private function _init():void
		{
//			HelloAne.o.addEventListener(AppPurchaseEvent.PRODUCTS_RECEIVED, _onEventProductsReceived);
			iPlatform = (SApplication.appInstance as MainApplication).platform;
			
			iPlatform.addEventListener(SPlatformEvents.EventGetProducts, _onEventProductsReceived);
		}
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			var iPlatform:ISPlatfrom = (SApplication.appInstance as MainApplication).platform;
			iPlatform.getproducts();
			
			super._onloadFromRemote(params);
		}
		
		private function _onEventProductsReceived(e:Event):void
		{
			// AppPurchaseEvent
			var arrayData:Array = e.data as Array;
			if (null == arrayData)
			{
				return;
			}
			_dataArray = arrayData;
			this._onloadFromRemoteComplete();
		}
		
		/**
		 * 获取数据
		 * @return 
		 * 
		 */		
		public function getProductsData():Array
		{
			return _dataArray;
		}
	}
}