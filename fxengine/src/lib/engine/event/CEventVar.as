package lib.engine.event
{
	public class CEventVar
	{
		public function CEventVar()
		{
		}
		
		public static const CEventPrefix:String = "XDG_EVENT_";
		
		
		/**
		 * 数据改变 消息
		 * key:String
		 * value:*
		 */
		public static const E_DATACHANGE:String = CEventPrefix + "E_DATACHANGE";
		
		
		/**
		 * 资源加载完成
		 * null 
		 */
		public static const E_RESOURCELOADCOMPLETE:String = CEventPrefix + "E_RESOURCELOADCOMPLETE";
		
		
		
		/**
		 * 影响器开始运行 
		 * obj:Impact
		 */
		public static const E_UI_IMPACT_START:String = CEventPrefix + "E_UI_IMPACT_START";
		
		
		/**
		 * 影响器停止运行 
		 * obj:Impact
		 */
		public static const E_UI_IMPACT_END:String = CEventPrefix + "E_UI_IMPACT_END";
		
		
		/**
		 * 游戏对象影响器开始运行 
		 * obj:Impact
		 */
		public static const E_GAMEOBJECT_IMPACT_START:String = CEventPrefix + "E_GAMEOBJECT_IMPACT_START";
		
		
		/**
		 *  游戏对象影响器停止运行 
		 * obj:Impact
		 */
		public static const E_GAMEOBJECT_IMPACT_END:String = CEventPrefix + "E_GAMEOBJECT_IMPACT_END";
		
		
		/**
		 * 游戏对象注册 
		 */
		public static const E_GAMEOBJECT_REGISTE:String = CEventPrefix + "E_GAMEOBJECT_REGISTE";
		
		
		/**
		 * 游戏对象取消注册 
		 */
		public static const E_GAMEOBJECT_UNREGISTE:String = CEventPrefix + "E_GAMEOBJECT_UNREGISTE";
		
		
		/**
		 * 对话框关闭事件 
		 */
		public static const E_UI_ALERT_CLOSE:String = CEventPrefix + "E_UI_ALERT_CLOSE";
	}
}