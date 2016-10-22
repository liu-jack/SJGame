package lib.engine.ui.uicontrols
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import lib.engine.iface.ui.I_XGD_UIBuilder;
	import lib.engine.ui.Manager.UIManager;
	import lib.engine.ui.data.Layouts;
	import lib.engine.ui.data.controls.XDG_UI_Data;
	import lib.engine.ui.impact.UI_Impact_fade_In;
	import lib.engine.utils.CObjectUtils;
	
	/**
	 * layout控件,界面基类
	 * 本身类似于Canvas了
	 * @author caihua
	 * 
	 */
	public class XDG_UI_Layout extends XDG_UI_Control
	{
		
		/**
		 * UI构建工厂类 
		 */
		protected var _UI_Factory:I_XGD_UIBuilder;
		private var _Controls:Array = new Array();
		private var _ControlLoaded:int = 0;
		/**
		 * 需要Load加载的控件 
		 */
		private var _NeedLoadControl:int = 0;
		/**
		 * 移动相对位置 
		 */
		private var _offsetpos:Point = new Point();;
		/**
		 * 是否在移动中 
		 */
		private var _moving:Boolean = false;
		
		private var _CanMove:Boolean = true;
		
		private var _foucsEffect:Boolean = true;
		
		private var _CanActive:Boolean = false;
		private var _CompleteCallBack:Function = null;
		private var _Modal:Boolean = false;
		
		
		
		/**
		 * 设置是否可以移动 
		 * 默认为true
		 */
		public function get CanMove():Boolean
		{
			
			return _CanMove;
		}
		
		/**
		 * @private
		 */
		public function set CanMove(value:Boolean):void
		{
			_CanMove = value;
		}
		
		
		public function XDG_UI_Layout()
		{
			_UI_Factory = UIManager.o.ui_Factory;
			_ResourceManager = UIManager.o.ResourceManager;
			
			
		}
		
		override protected function _onAdded_tostage():void
		{
			
		}
		
		override protected function _onInitAfter():void
		{
			// TODO Auto Generated method stub
			super._onInitAfter();
			LoadProperty(new Layouts());
			this.Close();
		}
		
		override protected function _onRemove_from_State():void
		{
			// TODO Auto Generated method stub
			super._onRemove_from_State();
			
		}
		
		/**
		 * 加载layout数据 
		 * @param layout
		 * @LoadComplete 加载完成回调 function(layout:XDG_UI_Layout):void;
		 */
		public function Load(layout:Layouts,LoadComplete:Function = null):void
		{
			_clear();
			_CompleteCallBack = LoadComplete;
			LoadProperty(CObjectUtils.clone(layout));		
			var controls:Array = layout.getControls();
			_NeedLoadControl = controls.length;
			for each(var control:XDG_UI_Data in controls)
			{
				_CreateChild(CObjectUtils.clone(control));
			}
			
		}
		
		/**
		 * 移动到最上层 
		 * 
		 */
		public function BringTofront():void
		{
			UIManager.o.bringtofront(this);
		}
		
		override protected function _onClose():void
		{
			this.removeEventListener(MouseEvent.MOUSE_DOWN,_onMouseDown);
			this.removeEventListener(MouseEvent.MOUSE_UP,_onMouseUp);
			this.removeEventListener(MouseEvent.CLICK,_onMouseClick);
			if(this.stage != null)
				this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,_onMouseMove);
			UIManager.o.onLayoutClose(this);
			
		}
		
		override protected function _onShow():void
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN,_onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP,_onMouseUp);
			this.addEventListener(MouseEvent.CLICK,_onMouseClick);
			if(this.stage != null)
				this.stage.addEventListener(MouseEvent.MOUSE_MOVE,_onMouseMove);
			UIManager.o.onLayoutShow(this);
		}
		
		/**
		 * 删除自己 
		 * 
		 */
		override public function removeself():void
		{
			this.Close();
			UIManager.o.removeLayout(this);
		}
		
		/**
		 * 加载完成单个控件执行 
		 * @param ctrlinfo
		 * @param d
		 * 
		 */
		private function _LoadLayoutsCallback(ctrlinfo:XDG_UI_Data, d:XDG_UI_Control):void
		{
			
			var mdepth:int = this.numChildren;
			for(var i:int = 0;i<this.numChildren;i++)
			{
				var mControl:XDG_UI_Control = this.getChildAt(i) as XDG_UI_Control;
				if(mControl.property.depth > d.property.depth)
				{
					mdepth = i;
					break;
				}
			}
			
			this.addChildAt(d,mdepth);	
			
			if(_CompleteCallBack != null)
			{
				if(_NeedLoadControl == this.numChildren)
				{
					_CompleteCallBack(this);
					_CompleteCallBack = null;
				}
			}
		}
		
		
		
		private function _clear():void
		{
			var d:DisplayObject = null;
			while (null != (d = _Controls.shift()))
			{
				this.removeChild(d);
			}
			_ControlLoaded = 0;
		}
		
		
		
		public function removeChildByName(name:String):void
		{
			var d:DisplayObject = getChildByName(name);
			if(d!= null)
			{
				this.removeChild(d);
			}
		}
		/**
		 * 创建子控件 
		 * @param data
		 * 
		 */
		private function _CreateChild(data:XDG_UI_Data):void
		{
			_UI_Factory.CreateViewControl(data,_LoadLayoutsCallback);
		}
		
		/**
		 * 通过数据添加控件 
		 * @param data
		 * @return 
		 * 
		 */
		public function AddChildByData(data:XDG_UI_Data):void	
		{
			//添加到最上层
			data.depth = this.numChildren;
			_CreateChild(data);
		}
		
		/**
		 * 添加控件 
		 * @param control
		 * 
		 */
		public function AddChild(control:XDG_UI_Control):void
		{
			control.property.depth = this.numChildren;
			_LoadLayoutsCallback(control.property,control);
		}
		
		/**
		 * 查找子控件 
		 * @param name 控件名称
		 * @return 
		 * 
		 */
		public function findChild(name:String):*
		{
			return this.getChildByName(name);
		}
		
		public function MoveTo(pos:Point):void
		{
			this.x = pos.x;
			this.y = pos.y;
		}
		
		private function _onMouseDown(e:MouseEvent):void
		{
			
			if(e.target is XDG_UI_Control && !_moving && _CanMove)
			{
				_offsetpos = e.target.localToGlobal(new Point(e.localX,e.localY));
				_offsetpos = _offsetpos.subtract(this.localToGlobal(new Point(0,0)));
				
				
				_moving = true;
			}
		}
		
		private function _onMouseUp(e:MouseEvent):void
		{
			_moving = false;
		}
		
		private function _onMouseMove(e:MouseEvent):void
		{
			if(_moving)
			{
				var pos:Point = e.target.localToGlobal(new Point(e.localX,e.localY));
				
				//要移动到的全局坐标点
				pos = pos.subtract(_offsetpos);
				
				MoveTo(this.parent.globalToLocal(pos));
			}
		}
		
		private function _onMouseClick(e:MouseEvent):void
		{
			if(_CanActive)
			{
				this.BringTofront();
			}
		}
		
		public function _onLostFoucs():void
		{
			if(_foucsEffect)
				this.impact.AddImpact(new UI_Impact_fade_In(500,1,0.2));
		}
		
		public function _onFoucs():void
		{
			if(_foucsEffect)
				this.impact.AddImpact(new UI_Impact_fade_In(500,this.alpha,1));
		}
		
		/**
		 * 激活特效 
		 */
		public function get foucsEffect():Boolean
		{
			return _foucsEffect;
		}
		
		/**
		 * @private
		 */
		public function set foucsEffect(value:Boolean):void
		{
			_foucsEffect = value;
		}
		
		/**
		 * 是否可以激活,也就是点击的时候,至于顶层 
		 */
		public function get CanActive():Boolean
		{
			return _CanActive;
		}
		
		/**
		 * @private
		 */
		public function set CanActive(value:Boolean):void
		{
			_CanActive = value;
		}

		/**
		 * 是否为模态 
		 */
		public function get Modal():Boolean
		{
			return _Modal;
		}

		/**
		 * @private
		 */
		public function set Modal(value:Boolean):void
		{
			_Modal = value;
		}
		
		
	}
}