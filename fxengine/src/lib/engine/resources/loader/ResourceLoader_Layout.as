package lib.engine.resources.loader
{
	import flash.utils.ByteArray;
	
	import lib.engine.resources.ResourceType;
	import lib.engine.ui.data.Layouts;

	/**
	 * 布局文件加载器 
	 * @author caihua
	 * 
	 */
	public class ResourceLoader_Layout extends ResourceLoader
	{
		public function ResourceLoader_Layout()
		{
			super("layout", ResourceType.TYPE_LAYOUTS);
		}
		
		override protected function onLoading(bytes:ByteArray):*
		{
			var layout:Layouts = new Layouts();
			layout.UnSerialization(bytes.toString());
			return layout;
		}
		
		
	}
}