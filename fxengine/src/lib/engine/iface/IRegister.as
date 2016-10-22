package lib.engine.iface
{
	/**
	 * 注册接口 
	 * @author caihua
	 * 
	 */
	public interface IRegister
	{
		/**
		 * 注册 
		 * @param reg key
		 * @return 注册是否成功
		 * 
		 */
		function register(reg:*):Boolean;
		/**
		 * 取消注册 
		 * @param reg key
		 * @return 删除是否成功
		 * 
		 */
		function unregister(reg:*):Boolean;
	}
}