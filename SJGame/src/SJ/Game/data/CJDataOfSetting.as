package SJ.Game.data
{
	import engine_starling.data.SDataBase;
	
	/**
	 * 系统设置信息
	 * 仅保存至本地
	 * @author longtao
	 * 
	 */
	public class CJDataOfSetting extends SDataBase
	{
		public function CJDataOfSetting()
		{
			super("CJDataOfSetting");
			loadFromCache();
		}
		
		/**
		 * 声音
		 * @param value
		 */
		public function set isMusicPlay(value:Boolean):void
		{
			setData("isMusicPlay", value);
		}
		/**
		 * @private
		 * */
		public function get isMusicPlay():Boolean
		{
			return getData("isMusicPlay", true);
		}
		
		/**
		 * 是否推送信息
		 */
		public function get isPushInfo():Boolean
		{
			return getData("isPushInfo", true);
		}
		
		/**
		 * @private
		 */
		public function set isPushInfo(value:Boolean):void
		{
			setData("isPushInfo", value);
		}
		
		
		/**
		 * 是否省流量
		 */
		public function get isSaveFlow():Boolean
		{
			return getData("isSaveFlow", true);
		}
		
		/**
		 * @private
		 */
		public function set isSaveFlow(value:Boolean):void
		{
			setData("isSaveFlow", value);
		}
		
		
		/**
		 * 是否显示其他人
		 */
		public function get isShowOthers():Boolean
		{
			return getData("isShowOthers", true);
		}
		
		/**
		 * @private
		 */
		public function set isShowOthers(value:Boolean):void
		{
			setData("isShowOthers", value);
		}
		
		
		/**
		 * 是否调用了 广告请求 
		 * @return 
		 * 
		 */
		public function get isSendAdCallback():Boolean
		{
			return getData("isSendAdCallback",false);
		}
		/**
		 * 成功调用 
		 * 
		 */
		public function CallSendAdCallbackSucc():void
		{
			setData("isSendAdCallback",true);
		}

		
	}
}