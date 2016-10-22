package lib.engine.ui.Manager
{
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	
	import lib.engine.iface.IRegister;
	import lib.engine.layer.Clayer;
	import lib.engine.ui.Manager.Mouse.MouseManager;
	import lib.engine.ui.layers.CModelLayer;
	import lib.engine.ui.layers.CMouseLayer;
	import lib.engine.ui.layers.CToolTipLayer;
	import lib.engine.ui.layers.CUIContorlsLayer;
	import lib.engine.ui.layers.CUILayer;
	import lib.engine.ui.uicontrols.XDG_UI_Layout;
	import lib.engine.utils.functions.Assert;

	/**
	 * UI控件,图层管理类 
	 * @author caihua
	 * 
	 */
	public class UIManagerControls extends UIManagerPropertys  implements IRegister
	{
		private var _controlslayer:Clayer;
		private var _tooltiplayer:Clayer;
		private var _mouselayer:Clayer;
		
		private var _mousemanager:MouseManager;
		/**
		 * 模态窗口 
		 */
		private var _modelLayer:Clayer;
		/**
		 * 模态弹出后,底层效果 
		 */
		private var _modelfilters:Array;
		
		public function UIManagerControls()
		{
		}
		
		
		/**
		 * 添加Layout 
		 * @param layout
		 * 
		 */
		public function addLayout(layout:XDG_UI_Layout):void
		{
			Assert(_ui_Factory != null,"_ui_Factory != null 添加layout先初始化 XDG_UIManager");
			for(var i:int = 0;i<_controlslayer.numChildren;i++)
			{
				var mlayout:XDG_UI_Layout = XDG_UI_Layout(_controlslayer.getChildAt(i));
				if(mlayout.property.depth > layout.property.depth)
				{
					break;
				}
			}
			_controlslayer.addChildAt(layout,i);
			
		}
		
		/**
		 * 移除Layout 
		 * @param layout
		 * 
		 */
		public function removeLayout(layout:XDG_UI_Layout):void
		{
			if(_controlslayer.contains(layout))
			{
				_controlslayer.removeChild(layout);
			}
		}
		
		/**
		 * 删除所有的Layouts 
		 * 
		 */
		public function removeAll():void
		{
			while(_controlslayer.numChildren != 0)
			{
				_controlslayer.removeChildAt(0);
			}
		}
		
		/**
		 * 提升到最前面 
		 * @param layout
		 * 
		 */
		public function bringtofront(layout:XDG_UI_Layout):void
		{
			
			var idx:int = _controlslayer.getChildIndex(layout);
			//已经值最上层控件了,则不处理了
			if(idx == _controlslayer.numChildren - 1)
				return;
			
			var d:XDG_UI_Layout = _controlslayer.getChildAt(_controlslayer.numChildren - 1) as XDG_UI_Layout;
			d._onLostFoucs();
			
			
			layout.property.depth = d.property.depth + 1;
			removeLayout(layout);
			addLayout(layout)
			layout._onFoucs();
		}
		
		/**
		 * 注册函数
		 * @param sp 父控件 必须为 CUILayer
		 * 
		 */
		public function register(sp:*):Boolean
		{
			Assert(sp is CUILayer,"UI系统父控件错误,类型必须为 CUILayer");
			Assert(_ui_layer == null,"UI系统已经被注册!,如果需要反复注册,请先调用UnRegister!");
			
			_ui_layer = sp;
			
			
			_controlslayer = new CUIContorlsLayer();
			_ui_layer.addChild(_controlslayer);
			

			_modelLayer = new CModelLayer(worldsize.x, worldsize.y);
			_ui_layer.addChild(_modelLayer);
			
			_modelfilters = new Array();
			_modelfilters.push(new BlurFilter(5, 5, 3));
			
			_mouselayer = new CMouseLayer();
			_ui_layer.addChild(_mouselayer);
			_mousemanager = MouseManager.o;
			_mousemanager.Register(_mouselayer);
			//			}
			
			
			_tooltiplayer = new CToolTipLayer();
			_ui_layer.addChild(_tooltiplayer);
			TooltipManager.o.register(_tooltiplayer);
			
			
			
			return true;
		}
		/**
		 * 取消注册 
		 * @param reg 不穿值
		 */
		public function unregister(reg:*):Boolean
		{
			Assert(_ui_layer != null,"取消注册失败!.父控件为空");
			if(_ui_layer == null)
				return false;
			_ui_layer.removeChild(_modelLayer);
			_ui_layer.removeChild(_tooltiplayer);
			_ui_layer.removeChild(_controlslayer);
			_ui_layer.removeChild(_mouselayer);
			_ui_layer = null;
			
			return true;
		}
		
		
		
		
		
		/**
		 * 鼠标管理器 
		 */
		public function get mousemanager():MouseManager
		{
			return _mousemanager;
		}
		
		
		/**
		 * layout显示 
		 * @param layout
		 * 
		 */
		public function onLayoutShow(layout:XDG_UI_Layout):void
		{
			if(layout.Modal)
			{
				_ShowModelLayout(layout);
			}			
		}
		
		
		private var _ModelWindowsStack:Vector.<XDG_UI_Layout> = new Vector.<XDG_UI_Layout>();
		protected function _ShowModelLayout(layout:XDG_UI_Layout):void
		{
			while(_modelLayer.numChildren != 0)
			{
				var d:XDG_UI_Layout = XDG_UI_Layout(_modelLayer.removeChildAt(0));
				
				//添加到模态窗口堆栈中
				_ModelWindowsStack.push(d);
				//暂时添加到普通控件列表中
				addLayout(d);
			}
			_modelLayer.addChild(layout);
			_modelLayer.visible = true;
			
			_controlslayer.filters = _modelfilters; 
			_controlslayer.mouseEnabled = false;
			_controlslayer.mouseChildren = false;
		}
		
		protected function _CloseModelLayout(layout:XDG_UI_Layout):void
		{
			while(_modelLayer.numChildren != 0)
			{
				_modelLayer.removeChildAt(0);
			}
			addLayout(layout);
			
			if(_ModelWindowsStack.length != 0)//继续弹出模态窗口
			{
				var d:XDG_UI_Layout = _ModelWindowsStack.pop();
				_ShowModelLayout(d);
			}
			else
			{
				_modelLayer.visible = false;
				_controlslayer.filters = new Array(); 
				_controlslayer.mouseEnabled = true;
				_controlslayer.mouseChildren = true;
			}
			
			
			
			
		}
		
		/**
		 * layout关闭 
		 * @param layout
		 * 
		 */
		public function onLayoutClose(layout:XDG_UI_Layout):void
		{
			//			XDG_TooltipManager.o.closeTip(1);
			if(layout.Modal)
			{
				_CloseModelLayout(layout);
				
			}
		}
		
		override public function set worldsize(value:Point):void
		{
			super.worldsize = value;
			if(_modelLayer != null)
			{
				CModelLayer(_modelLayer).changesize(worldsize.x, worldsize.y);
			}
		}
	}
}