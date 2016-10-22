package fxengine.game.iface
{
	/**
	 * 更新接口 
	 * @author caihua
	 * 
	 */
	public interface FUpdateInterface
	{
		/**
		 * 更新接口 
		 * @param currenttime 当前时间
		 * @param escapetime 流逝时间
		 * 
		 */
		function update(currenttime:Number,escapetime:Number):void;
	}
}