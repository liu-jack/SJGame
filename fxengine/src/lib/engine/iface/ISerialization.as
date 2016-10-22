package lib.engine.iface
{
	/**
	 * 序列号接口 
	 * @author caihua
	 * 
	 */
	public interface ISerialization
	{
		function Serialization():String;
		function UnSerialization(object:String):void;
	}
}