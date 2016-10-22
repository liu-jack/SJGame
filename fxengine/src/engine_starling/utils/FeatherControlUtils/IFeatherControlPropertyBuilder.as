package engine_starling.utils.FeatherControlUtils
{
	import feathers.core.FeathersControl;

	public interface IFeatherControlPropertyBuilder
	{
		function get fullClassName():String;
		/**
		 * 开始编辑控件 
		 * @param control 控件本身
		 * @param ownerControl 控件拥有类
		 * 
		 */
		function beginEdit(control:FeathersControl,ownerControl:FeathersControl):void;
		/**
		 * 结束编辑 
		 * 
		 */
		function endEdit():void;
		function setProperty(key:String,value:*):void;
	}
}