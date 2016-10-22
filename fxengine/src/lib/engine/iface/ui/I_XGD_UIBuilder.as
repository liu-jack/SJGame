package lib.engine.iface.ui
{
	import lib.engine.ui.data.controls.XDG_UI_Data;
	
	
	/**
	 * 控件创建接口 
	 * @author caihua
	 * 
	 */
	public interface I_XGD_UIBuilder
	{
		/**
		 * 构造器有效
		 * @param type 类型
		 * @return 
		 * 
		 */		
		function Builder_valid(type:String):Boolean;

		/**
		 * 创建layout的控件 
		 * @param controlinfo 控件信息
		 * @param layout
		 * @return 添加进入 layoutview的控件 
		 * @param _callback 异步创建回调函数 function(ControlBaseinfo,DisplayObject);
		 * 主要是资源不能同步加载的问题导致，编辑器不存在这个问题，因为在一开始全部加载
		 * @return 
		 * 
		 */
		function CreateViewControl(controlinfo:XDG_UI_Data,_callback:Function):void;
		
		
		/**
		 * 创建控件信息 
		 * @param type 控件类型 
		 * @param name 控件名称，如果为null 则自动命名
		 * @return 
		 * 
		 */
		function CreateCtrlInfo(type:String,name:String = null):XDG_UI_Data;
	}
}