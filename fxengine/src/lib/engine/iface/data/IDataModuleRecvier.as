package lib.engine.iface.data
{
	import lib.engine.event.CEvent;

	public interface IDataModuleRecvier
	{
		/**
		 * 数据收到,或者数据变化时触发 
		 * @param e.ext.data
		 * 
		 * 
		 */
		function onDataRecv(e:CEvent):void;
	}
}