package SJ.Game.formation
{
	import flash.geom.Point;
	
	import engine_starling.display.SLayer;
	
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 +------------------------------------------------------------------------------
	 * @comment 滚动item基类
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-5-22 下午5:12:41  
	 +------------------------------------------------------------------------------
	 */
	public class CJItemTurnPageBase extends SLayer implements IListItemRenderer
	{
		//是否被选中
		protected var _isSelected:Boolean;
		/*实际数据*/
		protected var _data:Object;
		/*默认属性*/
		protected var _index:int;
		protected var _owner:List;
		protected var _isScrolled:Boolean;
		/*是否可以多次响应选中*/
		protected var _multiSelection:Boolean;
		
		/**
		 * @param name : item的key
		 * @param multiSelection ： 是否可以多次选中该item
		 */		
		public function CJItemTurnPageBase(name:String , multiSelection:Boolean = false)
		{
			super();
			this.name = name;
			this._multiSelection = multiSelection;
			this.addEventListener(TouchEvent.TOUCH, this.touchHandler);
		}
		
		private function _updateSelected(e:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
	
		/**
		 * 是否可以选中
		 */
		protected function canSelectItem():Boolean
		{
			return true;
		}
		
		/**
		 * 更新选中 
		 * 
		 */
		protected function onSelected():void
		{
//			Assert(false , "子类需要实现被选中方法");
		}
		
		protected function touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(touch == null)
			{
				return;
			}
			var localpoint:Point = this.globalToLocal(new Point(touch.globalX,touch.globalY));
			if(touch.phase == TouchPhase.BEGAN)
			{
				_isScrolled = false;
			}
			else if(touch.phase == TouchPhase.ENDED && !_isScrolled)
			{
				if(this.hitTest(localpoint) != null)
				{
					//是否可以选中
					if(canSelectItem())
					{
						this.owner.selectedItem = _data;
					}
					onSelected();
				}
			}
		}
		
		public function get data():Object
		{
			return this._data;
		}
		
		public function set data(value:Object):void
		{
			if(this._data == value)
			{
				return;
			}
			this._data = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		public function get index():int
		{
			return this._index;
		}
		
		public function set index(value:int):void
		{
			this._index = value;
		}
		
		public function get owner():List
		{
			return this._owner;
		}
		
		public function set owner(value:List):void
		{
			if(this._owner == value)
			{
				return;
			}
			if(this._owner)
			{
				List(this._owner).removeEventListener(Event.SCROLL, _changeHandler);
				List(this._owner).removeEventListener(Event.CHANGE, _updateSelected);
			}
			this._owner = value;
			if(this._owner != null)
			{
				this._owner.addEventListener(Event.SCROLL , this._changeHandler);
				this._owner.addEventListener(Event.CHANGE,_updateSelected);
			}
		}
		
		private function _changeHandler(e:Event):void
		{
			_isScrolled = true;
		}
		
		public function get isSelected():Boolean
		{
			return this._isSelected;
		}
		
		public function set isSelected(value:Boolean):void
		{
			if(isSelected == value && !_multiSelection)
			{
				return;
			}
			this._isSelected = value;
		}
		
		override public function dispose():void
		{
			_data = null;
			_owner = null;
			super.dispose();
		}
	}
}