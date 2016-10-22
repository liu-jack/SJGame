package lib.engine.game.Canvas
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import lib.engine.game.Canvas.Indexs.GameCanvasIndex_Normal;
	import lib.engine.game.bitmap.GBitmap;
	import lib.engine.game.module.CModuleSubSystem;
	import lib.engine.game.object.GameObject;
	import lib.engine.game.object.GameObjectType;
	import lib.engine.iface.GameCanvas.IGameCanvasObjectsIndex;
	import lib.engine.iface.game.IGameRenderable;
	import lib.engine.platform.ConstVar;
	import lib.engine.utils.CObjectUtils;
	import lib.engine.utils.CTickUtils;
	import lib.engine.utils.CTimerUtils;
	import lib.engine.utils.functions.Assert;
	
	/**
	 * 游戏主窗口 
	 * @author caihua
	 * 
	 */
	public class GameCanvas extends CModuleSubSystem implements IGameRenderable
	{
		private var _backbuffer:GBitmap;
		private var _collsionbuffer:GBitmap;
		private var _renderable:Sprite;
		private var _width:Number;
		private var _height:Number;
		/**
		 * 子对象容器 
		 */
		private var _objectcontains:Vector.<GameObject>;
		private var _objectAddContains:Vector.<GameObject>;
		private var _objectRemoveContains:Vector.<GameObject>;
		/**
		 * 对象深度变化缓存类 
		 */
		private var _objectDepthChangeContains:Vector.<GameObject>;
		private var _lasttimetick:Number = 0;
		private var _viewport:Rectangle = new Rectangle();
		private var _bgColor:uint = 0xFFFFFFFF;
		private var _ContainIndex:IGameCanvasObjectsIndex;
		private var _name:String;
		
		
		/**
		 * 是否渲染中 
		 */
		private var _isRendering:Boolean = false;
		
		/**
		 * 构造函数 
		 * @param renderable 绘制主体
		 * @param mwidth 宽度
		 * @param mheight 高度
		 * 
		 */
		public function GameCanvas(renderable:Sprite,mwidth:Number = 0,mheight:Number = 0)
		{
			super("GameCanvas"+ CTimerUtils.getCurrentTime());
			registerRenderHander(renderable);
			this.setSize(mwidth,mheight);
			_onConstructor();
		}
		public function get renderable():Sprite
		{
			return _renderable;
		}
		
		/**
		 * 注册渲染接口 
		 * @param renderable
		 * 
		 */
		public function registerRenderHander(renderable:Sprite):void
		{
			_renderable = renderable;
		}
		
		/**
		 * 设置尺寸 
		 * @param width
		 * @param height
		 * 
		 */
		public function setSize(width:Number,height:Number):void
		{
			if(width == 0 || height == 0)
				return;
			_width = width;
			_height = height;
			_backbuffer = new GBitmap(_width,_height,true);
			this.setviewportSize(new Point(width,height));
			
		}
		
		/**
		 * 尺寸 
		 * @return 
		 * 
		 */
		public function get size():Point
		{
			return new Point(_width,_height);
		}
		private function _onConstructor():void
		{
			_objectcontains = new Vector.<GameObject>();
			_objectAddContains = new Vector.<GameObject>();
			_objectRemoveContains = new Vector.<GameObject>();
			_objectDepthChangeContains = new Vector.<GameObject>();
			
		}
		
		override protected function _onInit(params:Object = null):void
		{
			ContainIndex = new GameCanvasIndex_Normal();
			
		}
		/**
		 * Tick循环 
		 * @param e
		 * @param params
		 * 
		 */
		private function _onTick(e:TimerEvent,params:Object):void
		{
			
			_onEnterframe(null);
			
		}
		
		protected function _onEnterframe(e:Event):void
		{
			//删除游戏对象
			_onRemoveGameObject();
			//添加游戏对象
			_onaddGameObject();
			//更新深度
			_onChangeDepth();
			//更新时间
			advanceTime();
			//渲染
			render(_backbuffer,_backbuffer.rect);
			//绘制本身
			_renderself();
		}
		
		/**
		 * 绘制本身 
		 * 
		 */
		protected function _renderself():void
		{
			_renderable.graphics.clear();
			_renderable.graphics.beginBitmapFill(_backbuffer);
			_renderable.graphics.drawRect(0,0,_backbuffer.width,_backbuffer.height);
			_renderable.graphics.endFill();
		}
		/**
		 * 更新系统时间 
		 * 
		 */
		protected function advanceTime():void
		{
			var currentTime:Number = CTimerUtils.getCurrentTime();
			var escapetime:Number = currentTime - _lasttimetick;
			_lasttimetick = currentTime;
			
			update(currentTime,escapetime);
		}
		
		/**
		 * 绘制子对象 
		 * @param g
		 * 
		 */
		public function render(g:GBitmap, offset:Rectangle):void
		{
			g.fillRect(g.rect,_bgColor);
			
			//按照4叉树绘制
			
			var i:int = 0;
			var _objects:Vector.<GameObject> = new Vector.<GameObject>();
			
			_ContainIndex.getRenderObjects(_viewport,_objects);
			for( i = _objects.length -1; i>= 0;i--)
			{
				var obj:GameObject = _objects[i];
				
				obj.render(g,viewport);
			}
		}
		
		public function update(currenttime:Number, escapetime:Number):void
		{
			var _objects:Vector.<GameObject> = new Vector.<GameObject>();
			_ContainIndex.getUpdateObjects(_viewport,_objects,currenttime,escapetime);
			for each( var obj:GameObject in _objects)
			{
				//影响器更新
				obj.Impact.update(currenttime,currenttime - obj.lastUpdateTime);
				//跟新主循环
				obj.update(currenttime,currenttime - obj.lastUpdateTime);
				//标志更新位
				obj.lastUpdateTime = currenttime;
			}
		}
		
		/**
		 * 添加对象 
		 * @param gameobject
		 * 
		 */
		public function addGameObject(gameobject:GameObject):void
		{
			if(_objectAddContains.indexOf(gameobject) == -1)
			{
				_objectAddContains.push(gameobject);
				_modifyObjectDepth(gameobject);
			}
		}
		
		protected function _modifyObjectDepth(gameobject:GameObject):void
		{
			switch(gameobject.gameojectType)
			{
				case GameObjectType.Type_NormalObject:
				{
					if(gameobject.depth < ConstVar.FRONT_DEPTH_MAX || gameobject.depth >= ConstVar.BACK_DEPTH_MIN)
					{
						Assert(false,"GameObject 对象深度错误 Type[" + gameobject.gameojectType + "]" +
							"name[" +gameobject.name+ "] class["+ CObjectUtils.getClassName(gameobject)+"]");
					}
				}
			}
		}
		
		protected function _onaddGameObject():void
		{
			
			var gameobject:GameObject = null;
			while(null != (gameobject = _objectAddContains.shift()))
			{
				var idx:int = getGameObjectindex(gameobject);
				
				Assert(idx == -1,"对象已经存在,反复添加");
				if(idx != -1)
					continue;
				gameobject.lastUpdateTime = CTimerUtils.getCurrentTime();
				_objectcontains.push(gameobject);
				//添加到扩张索引中
				_ContainIndex.add(gameobject);
				//添加
				gameobject.onAddtoCanvas(this);
			}
			
			
		}
		
		/**
		 * 获取GameObject索引对象 
		 * @param gameobject
		 * @return 
		 * 
		 */
		protected function getGameObjectindex(gameobject:GameObject):int
		{
			
			return _objectcontains.lastIndexOf(gameobject);
		}
		
		protected function _onRemoveGameObject():void
		{
			var gameobject:GameObject = null;
			while(null != (gameobject = _objectRemoveContains.shift()))
			{
				var idx:int = getGameObjectindex(gameobject);
				
				Assert(idx != -1,"删除对象不存在");
				if(idx != -1)
				{
					
					_ContainIndex.remove(gameobject);
					_objectcontains.splice(idx,1);
					gameobject.onRemovefromCanvas();
				}
			}
		}
		
		public function removeGameObject(gameobject:GameObject):void
		{
			
			
			if(_objectRemoveContains.indexOf(gameobject) == -1)
			{
				_objectRemoveContains.push(gameobject);
			}
		}
		
		/**
		 * 删除所有游戏对象 
		 * 
		 */
		public function removeAllGameObjects():void
		{
			if(_isRendering)
			{
				for each(var gameobject:GameObject in _objectcontains)
				{
					removeGameObject(gameobject);
				}
			}
			else
			{
				removeAllGameObjectsforce();
			}
		}
		/**
		 * 强制删所有游戏对象
		 * 必须在系统停止的时候进行 
		 * 
		 */
		public function removeAllGameObjectsforce():void
		{
			Assert(!_isRendering,"强制删除对象时,Canvas必须处于停止状态");
			if(_isRendering)
				return;
			
			
			_objectAddContains.splice(0,_objectAddContains.length);
			_objectRemoveContains.splice(0,_objectRemoveContains.length);
			_objectDepthChangeContains.splice(0,_objectDepthChangeContains.length);
			
			var gameobject:GameObject;
			while(null != ( gameobject = _objectcontains.shift()))
			{
				_ContainIndex.remove(gameobject);
				gameobject.onRemovefromCanvas();
			}
		}
		/**
		 * 改变深度调用 
		 * @param gameobject
		 * 
		 */
		public function ChangeDepth(gameobject:GameObject):void
		{
			if(_objectDepthChangeContains.indexOf(gameobject) == -1)
			{
				_objectDepthChangeContains.push(gameobject);
			}
		}
		
		public function _onChangeDepth():void
		{
			var gameobject:GameObject = null;
			while(null != (gameobject = _objectDepthChangeContains.shift()))
			{
				var idx:int = getGameObjectindex(gameobject);
				
				Assert(idx != -1,"更新对象深度对象不存在");
				
				//删除原索引
				if(idx != -1)
				{
					_ContainIndex.modify(gameobject);
				}
			}
		}
		
		
		public function get width():Number
		{
			return _width;
		}
		
		
		public function get height():Number
		{
			return _height;
		}
		
		/**
		 * 视口坐标 
		 */
		public function get viewport():Rectangle
		{
			return _viewport;
		}
		
		/**
		 * @private
		 */
		public function setviewportPos(pos:Point):void
		{
			_viewport.x = pos.x;
			_viewport.y = pos.y;
		}
		
		public function setviewportSize(size:Point):void
		{
			_viewport.width = size.x;
			_viewport.height = size.y;
		}
		
		/**
		 * 背景颜色 
		 */
		public function get bgColor():uint
		{
			return _bgColor;
		}
		
		/**
		 * @private
		 */
		public function set bgColor(value:uint):void
		{
			_bgColor = value;
		}
		
		/**
		 * 场景对象数量 
		 * @return 
		 * 
		 */
		public function get ObjectCount():int
		{
			return _objectcontains.length;
		}
		
		
		/**
		 * 获得制定点的对象 
		 * x,y为绝对坐标
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */
		public function getObject(x:int,y:int):GameObject
		{
			var _objects:Vector.<GameObject> = new Vector.<GameObject>();
			_ContainIndex.getClickObjects(_viewport,_objects);
			for each(var g:GameObject in _objects)
			{
				if(g.Mouseable && g.hitTest(new Point(x,y)))
				{
					return g;
				}
			}
			return null;
		}
		
		
		/**
		 * 用于碰撞的背图 
		 * @return 
		 * 
		 */
		public function get collsionbuffer():GBitmap
		{
			if(_collsionbuffer == null)
				_collsionbuffer = new GBitmap(_width,_height);
			return _collsionbuffer;
		}
		
		/**
		 * 开始渲染 
		 * 
		 */
		protected function _beginRender(fps:int = 30):void
		{
			CTickUtils.o.addTick(_name,1000/fps,int.MAX_VALUE,_onTick);
			_lasttimetick = CTimerUtils.getCurrentTime();
			_isRendering = true;
		}
		
		/**
		 * 停止渲染 
		 * 
		 */
		protected function _stopRender():void
		{
			CTickUtils.o.removeTick(_name);
			_isRendering = false;
			
			//删除游戏对象
			_onRemoveGameObject();
			//添加游戏对象
			_onaddGameObject();
			//更新深度
			_onChangeDepth();
			
			
		}
		
		/**
		 * fps = 30; 
		 * @param params
		 * 
		 */
		override protected function _onEnter(params:Object=null):void
		{
			super._onEnter(params);
			var fps:int = (params == null?30:int(params.fps));
			_beginRender(fps);
		}
		
		override protected function _onExit(params:Object=null):void
		{
			super._onExit(params);
			_stopRender();
		}
		
		/**
		 * 对象索引方式 
		 */
		public function get ContainIndex():IGameCanvasObjectsIndex
		{
			return _ContainIndex;
		}
		
		/**
		 * @private
		 */
		public function set ContainIndex(value:IGameCanvasObjectsIndex):void
		{
			Assert(_objectcontains.length == 0,"切换索引的时候,Canvas中的对象应该为空");
			if(_objectcontains.length == 0)
			{
				_ContainIndex = value;
				
			}
		}
		
		
		
	}
}