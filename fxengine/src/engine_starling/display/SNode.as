package engine_starling.display
{
	import engine_starling.Events.MouseEvent;
	
	import feathers.core.FeathersControl;
	
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * 所有元素基类,从  FeathersControl继承,主要使用他的 initialize
	 * @author caihua
	 * 
	 */	
	public class SNode extends FeathersControl
	{
		private var _isLocked:Boolean = false;
		
		public function SNode()
		{
			super();
		}
		
		
		/**
		 * 尝试加锁
		 * @return true : 未加锁  false: 已加锁
		 */ 
		public function Lock():Boolean
		{
			if(this._isLocked)
			{
				return false;
			}
			else
			{
				this._isLocked = true;
				return true;
			}
		}
		
		/**
		 * 解锁
		 */ 
		public function unLock():void
		{
			this._isLocked = false;
		}

		/**
		 * 拿到前景层 
		 * @param object
		 * 
		 */
		public function bringtofront(object:DisplayObject):void
		{
			var objectindex:int = this.getChildIndex(object);
			if(objectindex == -1)
				return;
			//最上层控件 不处理
			if(objectindex == this.numChildren - 1)
				return;
			removeChildAt(objectindex);
			addChild(object)
		}
		
		/**
		 * 把自己提高到前景层 
		 * 
		 */
		public function bringMetofrount():void
		{
			if(this.parent == null)
				return;
			if(this.parent is SNode)
				(this.parent as SNode).bringtofront(this);
		}
		
		
	
		private var _mouseQuickEventEnable:Boolean;
		
		/**
		 * 是否开启鼠标事件, 
		 */
		public function get mouseQuickEventEnable():Boolean
		{
			return _mouseQuickEventEnable;
		}
		
		/**
		 * @private
		 */
		public function set mouseQuickEventEnable(value:Boolean):void
		{
			if(_mouseQuickEventEnable == value)
				return;
			if(_mouseQuickEventEnable)
			{
				removeEventListener(TouchEvent.TOUCH,_onTouchMouseEvent);
			}
			_mouseQuickEventEnable = value;
			if(_mouseQuickEventEnable)
			{
				addEventListener(TouchEvent.TOUCH,_onTouchMouseEvent);
			}
		}
		
		/**
		 * 鼠标状态 
		 */
		private function _onTouchMouseEvent(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(touch && touch.phase == TouchPhase.ENDED)
			{
				dispatchEventWith(MouseEvent.Event_MouseClick,false,touch);
			}
		}
		
		
		private var _isDispose:Boolean = false;
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			_isDispose = true;
			super.dispose();
		}

		/**
		 * 是否已经被销毁 
		 */
		public function get isDispose():Boolean
		{
			return _isDispose;
		}
		
		
		
			
		
		
	}
}