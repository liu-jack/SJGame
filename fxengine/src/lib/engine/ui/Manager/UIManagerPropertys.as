package lib.engine.ui.Manager
{
	import flash.geom.Point;
	
	import lib.engine.iface.IResource;
	import lib.engine.iface.ui.I_XGD_UIBuilder;
	import lib.engine.ui.layers.CUILayer;
	import lib.engine.utils.functions.Assert;

	public class UIManagerPropertys
	{
		private var _worldsize:Point = new Point(0,0);
		public function UIManagerPropertys()
		{
		}
		
		/**
		 * 世界大小 
		 */
		public function get worldsize():Point
		{
			return _worldsize;
		}
		
		/**
		 * @private
		 */
		public function set worldsize(value:Point):void
		{
			_worldsize = value;
			
		}
		
		private var _editorMode:Boolean = false;
		
		/**
		 * 是否是编辑器模式 
		 */
		public function get editorMode():Boolean
		{
			return _editorMode;
		}
		
		/**
		 * @private
		 */
		public function set editorMode(value:Boolean):void
		{
			_editorMode = value;
		}
		
		
		protected var _ResourceManager:IResource;
		
		public function get ResourceManager():IResource
		{
			return _ResourceManager;
		}
		
		
		/**
		 * UI构建工程 
		 */
		protected var _ui_Factory:I_XGD_UIBuilder;
		
		public function get ui_Factory():I_XGD_UIBuilder
		{
			Assert(_ui_Factory != null,"_ui_Factory == null,没有调用 Initialize");
			return _ui_Factory;
		}
		
		
		
		/**
		 * UI层整体父控件,通过Register获得 
		 */
		protected var _ui_layer:CUILayer;
	}
}