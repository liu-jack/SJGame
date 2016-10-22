package lib.engine.ui.uicontrols
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import lib.engine.iface.IResource;
	import lib.engine.ui.Manager.TooltipManager;
	import lib.engine.ui.Manager.UIManager;
	import lib.engine.ui.data.controls.XDG_UI_Data;
	import lib.engine.ui.impact.UI_ImpactManager;
	import lib.engine.utils.CTimerUtils;
	
	import mx.utils.ObjectUtil;
	
	public class XDG_UI_Control extends Sprite
	{
		protected var _property:XDG_UI_Data;
		
		/**
		 * 配置信息
		 */
		public function get property():XDG_UI_Data
		{
			return _property;
		}
		
		/**
		 * 资源生成器 
		 */
		protected var _ResourceManager:IResource;
		
		/**
		 * 主属性设置列表 
		 */
		private var _PropertySetFunction:Dictionary;
		/**
		 * 扩展属性设置列表 
		 */
		private var _PropertyExSetFunction:Dictionary;
		
		
		/**
		 * 最后一次更新时间 
		 */
		private var _lastUpdateTime:Number;
		
		
		/**
		 * 影响器管理器 
		 */
		private var _impact:UI_ImpactManager;
		
		/**
		 * 是否显示Tip 
		 */
		private var _isshowtip:Boolean = false;
		
		/**
		 * 修改器 
		 * @return 影响器
		 * 
		 */
		public function get impact():UI_ImpactManager
		{
			return _impact;
		}
		
		
		public function XDG_UI_Control()
		{
			super();
			
			_onInit();
		}
		
		
		private function _onInit():void
		{
			_ResourceManager = UIManager.o.ResourceManager;
			_PropertySetFunction = new Dictionary();
			_PropertyExSetFunction = new Dictionary();
			
			
			_impact = new UI_ImpactManager(this);
			_onInitBefore();
			_onInit_ui();
			_init_PropertySetter();
			
			
			this.addEventListener(Event.ADDED_TO_STAGE,_ADDED_TO_STAGE);
			this.addEventListener(Event.REMOVED_FROM_STAGE,_REMOVED_FROM_STAGE);
			
			
			
			
			
			_onInitAfter();
		}
		/**
		 * 添加到场景 
		 * @param e
		 * 
		 */
		private  function _ADDED_TO_STAGE(e:Event):void
		{
			_lastUpdateTime = CTimerUtils.getCurrentTime();
			this.addEventListener(Event.ENTER_FRAME,_render);
//			_lastUpdateTime = CTimerUtils.getCurrentTime();
			if(!UIManager.o.editorMode)
			{
				this.addEventListener(MouseEvent.MOUSE_OVER,_onMouseOver);
				this.addEventListener(MouseEvent.MOUSE_OUT,_onMouseOut);
			}
			_onAdded_tostage();
		}
		/**
		 * 所有初始化执行之前执行 
		 * 
		 */
		protected function _onInitBefore():void{}
		
		/**
		 * 所有初始化完成后执行 
		 * 
		 */
		protected function _onInitAfter():void{}
		/**
		 * 初始化属性访问器 
		 * 
		 */
		protected function _init_PropertySetter():void
		{
			_registerPropertyFunction("x",_onPosChange);
			_registerPropertyFunction("y",_onPosChange);
			_registerPropertyFunction("name",_onNameChange);
		}
		/**
		 * 初始化 UI 布局
		 * 
		 */
		protected function _onInit_ui():void
		{
			
		}
		
		/**
		 * 添加到场景中 
		 * 
		 */
		protected function _onAdded_tostage():void
		{
			
		}
		
		private function _REMOVED_FROM_STAGE(e:Event):void
		{
			if(e.currentTarget == e.target)
			{
				if(!UIManager.o.editorMode)
				{
					this.removeEventListener(MouseEvent.MOUSE_OVER,_onMouseOver);
					this.removeEventListener(MouseEvent.MOUSE_OUT,_onMouseOut);
				}
				_onRemove_from_State();
			}
		}
		
		protected function _onRemove_from_State():void
		{
			
		}
		
		/**
		 * 显示 
		 * 
		 */
		public final function Show():void
		{
			if(this.visible)
			{
				return;
			}
			this.visible = true;
			
			
			
			_onShow();
		}
		/**
		 * 关闭 
		 * 
		 */
		public final function Close():void
		{
			if(!this.visible)
			{
				return;
			}
			this.visible = false;
			_closetip();
			_onClose();
		}
		
		protected function _onShow():void{};
		protected function _onClose():void{};
		
		private function _render(e:Event):void
		{
			//通过_cfg的值改变修改控件位置
			var mCurrentTime:Number = CTimerUtils.getCurrentTime();
			//			update(mCurrentTime,mCurrentTime - _lastUpdateTime);
			_impact.update(mCurrentTime,mCurrentTime - _lastUpdateTime);
			_lastUpdateTime = mCurrentTime;
			
			//			render(null,null);
		}
		/**
		 * 加载配置 
		 * @param cfg
		 * 
		 */
		public function LoadProperty(property:XDG_UI_Data):void
		{
			_property = property;
			
			//初始化所有属性值
			var classproperties:Array = ObjectUtil.getClassInfo(property,null,{'includeReadOnly':false}).properties as Array;
			for each(var q:QName in classproperties)
			{
				if(property[q.localName] != null)
					onPropertyValueChange(_property,q.localName,property[q.localName],property[q.localName])
			}
		}
		
		override public function set x(value:Number):void
		{
			if(_property!= null)
			{
				SetProperty("x",value);
			}
		}
		
		override public function set y(value:Number):void
		{
			if(_property!= null)
			{
				SetProperty("y",value);
			}
		}
		
		/**
		 * 属性设置接口 
		 * 可以连续设置属性
		 * @param varname 属性名称,例如x
		 * @param newvalue 属性值
		 * 
		 */
		public function SetProperty(varname:String,newvalue:*):Function
		{
			var oldValue:* = _property[varname];
			_property[varname] = newvalue;
			onPropertyValueChange(_property,varname,oldValue,newvalue);
			return this.SetProperty;
		}
		
		/**
		 * 注册赋值函数 
		 * @param varname
		 * @param func void(varname:string,oldvalue:*,newvalue:*)
		 * 
		 */
		protected function _registerPropertyFunction(varname:String,func:Function):void
		{
			_PropertySetFunction[varname] = func;
		}
		/**
		 * 注册可访问的扩展属性名称 
		 * 擴展函数为自动注册属性,一般使用属性注册就可以了
		 * @param varnames 扩展列表
		 * 
		 */
		protected function _registerExPropertyFilter(varnames:Array):void
		{
			for each(var name:String in varnames)
			{
				_PropertyExSetFunction[name] = _onExPropertyChange;
			}
			
		}
		/**
		 * 按照对象注册扩展属性访问器,简易方法
		 * 如果此注册与一般访问器重名的话,则执行一般访问器的方法 
		 * @param obj
		 * 
		 */
		protected function _registerExPropertyFilterObject(obj:Object):void
		{
			var options:Object = new Object();
			options.includeReadOnly = false;
			var classproperties:Array = ObjectUtil.getClassInfo(obj,null,options).properties as Array;
			
			for each(var n:QName in classproperties)
			{
				if(n.localName != "type")
					_PropertyExSetFunction[n.localName] = _onExPropertyChange;
			}
			
			
		}
		/**
		 * 位置改变 
		 * @param varname
		 * @param oldvalue
		 * @param newvalue
		 * 
		 */
		protected function _onPosChange(varname:String,oldvalue:*,newvalue:*):void
		{
			super[varname] = newvalue;
		}
		protected function _onNameChange(varname:String,oldvalue:*,newvalue:*):void
		{
			name = newvalue;
		}
		
		/**
		 * 扩展属性访问器 
		 * @param varname
		 * @param oldvalue
		 * @param newvalue
		 * 
		 */
		protected function _onExPropertyChange(varname:String,oldvalue:*,newvalue:*):void
		{
			
		}
		protected function onPropertyValueChange(property:XDG_UI_Data,varname:String,oldvalue:*,newvalue:*):void
		{
			
			//需要特殊处理的属性访问器
			var func:Function = _PropertySetFunction[varname];
			if(func != null)
			{
				func(varname,oldvalue,newvalue);
				return;
			}
			
			
			//扩展属性访问器
			func = _PropertyExSetFunction[varname];
			if(func != null)
			{
				func(varname,oldvalue,newvalue);
				return;
			}
		}
		protected function _onMouseOver(e:MouseEvent):void
		{
			_showtip();
		}
		
		protected function _onMouseOut(e:MouseEvent):void
		{

			_closetip();
		}
		
		
		/**
		 * 删除自己 
		 * 
		 */
		public function removeself():void
		{
			if(this.parent != null)
			{
				this.parent.removeChild(this);
			}
		}
		
		
		protected function _showtip():void
		{
			if(_property.tooltip == null ||_property.tooltip == "" || _isshowtip)
			{
				return;	
			}
			_isshowtip = true;
			
			var pos:Point = this.localToGlobal(new Point(this.width + 0,0));
			
			TooltipManager.o.showTip(_property.tooltip,pos.x,pos.y,1000);
		}
		
		protected function _closetip():void
		{
			if(_property.tooltip == null ||_property.tooltip == "")
			{
				return;	
			}
			
			TooltipManager.o.closeTip(200);
			_isshowtip = false;
		}
	}
}