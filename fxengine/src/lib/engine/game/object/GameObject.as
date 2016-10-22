package lib.engine.game.object
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import lib.engine.event.CEvent;
	import lib.engine.event.CEventSubject;
	import lib.engine.event.CEventVar;
	import lib.engine.game.Canvas.GameCanvas;
	import lib.engine.game.Impact.GameObjectImpactManager;
	import lib.engine.iface.IEventSubject;
	import lib.engine.platform.ConstVar;

	/**
	 * 对象基类
	 * @author caihua
	 * 
	 */
	public class GameObject extends GameObjectPropertys implements IEventSubject
	{
		protected var _canvas:GameCanvas;
		protected var _registered:Boolean = false;
		private var _eventsubject:CEventSubject;
		
		public function GameObject()
		{
			super();
			_Impact = new GameObjectImpactManager(this);
			_eventsubject = new CEventSubject();
		}
		
		/**
		 * 注册对象 
		 * 
		 */
		public function register(canvas:GameCanvas):void
		{
			if(!_registered)
			{
				_canvas = canvas;
				_canvas.addGameObject(this);
				_registered = true;
				
				this.dispatchEvent(new CEvent(CEventVar.E_GAMEOBJECT_REGISTE));
			}
		}
		
		/**
		 * 注销对象 
		 * 
		 */
		public function unregister():void
		{
			if(_registered)
			{
				canvas.removeGameObject(this);
				_registered = false;
				this.dispatchEvent(new CEvent(CEventVar.E_GAMEOBJECT_UNREGISTE));
			}
		}
		
		public function Destroy():void
		{
			unregister();
		}

		public function get canvas():GameCanvas
		{
			return _canvas;
		}

		public function set canvas(value:GameCanvas):void
		{
			_canvas = value;
		}

		/**
		 * 是否已经注册 
		 */
		public function get registered():Boolean
		{
			return _registered;
		}

		/**
		 * @private
		 */
		public function set registered(value:Boolean):void
		{
			_registered = value;
		}


		public final function onAddtoCanvas(canvas:GameCanvas):void
		{
			_canvas = canvas;
			this.Init();
			this._registered = true;
		}
		
		/**
		 * 从Canvas中删除 
		 * 
		 */
		public final function onRemovefromCanvas():void
		{
			this._registered = false;	
			this.Impact.removeAllImpaceforce();
			onDestory();
		}
		
		/**
		 * 对象销毁 
		 * 
		 */
		protected function onDestory():void
		{
			
		}
		public function hitTest(pos:Point):Boolean
		{
			
			return new Rectangle(this.pos.x,this.pos.y,width,height).contains(pos.x,pos.y);
		}
		
		override public function set depth(value:Number):void
		{

			if(this.gameojectType == GameObjectType.Type_NormalObject)
			{
				if(value < ConstVar.FRONT_DEPTH_MAX || value > ConstVar.BACK_DEPTH_MIN)
				{
					value = (value + ConstVar.FRONT_DEPTH_MAX)  % ConstVar.BACK_DEPTH_MIN;
				}
				
			}
			super.depth = value;
			if(_registered)
				_canvas.ChangeDepth(this);
		}
		
		
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			_eventsubject.addEventListener(type,listener,useCapture,priority,useWeakReference);
			
		}
		
		public function dispatchEvent(event:CEvent):Boolean
		{
			return _eventsubject.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return _eventsubject.hasEventListener(type)
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			_eventsubject.removeEventListener(type,listener,useCapture);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return _eventsubject.willTrigger(type);
		}
		
	}
}