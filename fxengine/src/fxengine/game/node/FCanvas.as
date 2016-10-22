package fxengine.game.node
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import fxengine.game.action.FActionManager;
	import fxengine.game.iface.FUpdateInterface;
	import fxengine.game.manager.FScheduler;

	/**
	 * 绘制容器 
	 * @author caihua
	 * 
	 */
	public class FCanvas implements FUpdateInterface
	{
		private static var _o:FCanvas = null;
		private var _lasttimetick:Number = 0;
		private var _showState:Boolean = false;
		
		
		private var _FrontLayer:Sprite = null;
		private var _GameLayer:Sprite = null;
		private var _BackLayer:Sprite = null;
		
		private var _sceneStack:Vector.<FScene> = null;




		/**
		 * 是否显示系统状态 
		 */
		public function get showState():Boolean
		{
			return _showState;
		}

		/**
		 * @private
		 */
		public function set showState(value:Boolean):void
		{
			
			_showState = value;
			if(_showState == true && _fpsTxt == null)
			{
				_fpsTxt = new TextField();
				_FrontLayer.addChild(_fpsTxt);
				
			}
		}
		

		/**
		 * FCanvans实例 
		 * @return 
		 * 
		 */
		public static function get o():FCanvas
		{
			if(_o == null)
				_o = new FCanvas();
			return _o;
		}
		public static function get scheduler():FScheduler
		{
			return FScheduler.o;
		}
		

		
		public function FCanvas()
		{
			_initailze();
		}
		
		/**
		 * 初始化系统 
		 * 
		 */
		private function _initailze():void
		{
			_sceneStack = new Vector.<FScene>();
			//初始化时间管理器
			scheduler;
			//初始化动作管理器
			_actionManager = new FActionManager();
		}
		
		
		/**
		 * 延时初始化 
		 * 
		 */
		private function _initailze_lazy():void
		{
			if(_FrontLayer == null)
			{
				_FrontLayer = new Sprite();
				_GameLayer = new Sprite();
				_BackLayer = new Sprite();
			}
			_mainSprite.addChild(_BackLayer);
			_mainSprite.addChild(_GameLayer);
			_mainSprite.addChild(_FrontLayer);
			
			_mainSprite.addChild(scheduler.tickSprite);
			scheduler.scheduleForUpdate(this);
		}
		
		/**
		 * 运行场景 
		 */		
		private var _runningScene:FScene = null;
		
		/**
		 *  
		 * @param scene
		 * 
		 */
		public function pushScene(scene:FScene):void
		{
			_sceneStack.push(scene);
			nextscene = scene;
		}
		/**
		 * 弹出场景 
		 * 
		 */
		public function popScene():void
		{
			_sceneStack.pop();
			if(_sceneStack.length == 0)
			{
				
			}
			else
			{
				nextscene = _sceneStack[_sceneStack.length - 1];
			}
		}

		/**
		 * 
		 * 
		 */
		public function popToRootScene():void
		{
			if(_sceneStack.length == 1)
			{
				
			}
			else
			{
				while(_sceneStack.length > 1)
				{
					var currentScene:FScene =  _sceneStack.pop();
					if(currentScene.isRunning)
					{
						currentScene.onExit();
					}
					
				}
				nextscene = _sceneStack[1];
			}
		}
		
		/**
		 * 下一个场景 
		 */
		public function set nextscene(value:FScene):void
		{
			if(_runningScene != null)
			{
				_runningScene.onEnterTransitionDidFinish();
				_runningScene.onExit();
				
				_GameLayer.removeChild(_runningScene);
			}
//			_nextscene = value;
			
			_runningScene = value;
//			_nextscene = null;
			if(_runningScene != null)
			{
				_runningScene.onEnter();
				_runningScene.onEnterTransitionDidFinish();
				
				_GameLayer.addChild(_runningScene);
			}
		}
		/**
		 * 
		 * @param scene
		 * 
		 */
		public function replaceScene(scene:FScene):void
		{
			_sceneStack[_sceneStack.length - 1] = scene;
			nextscene = scene;
		}
		public function runWithScene(scene:FScene):void
		{
//			_runningScene = scene;
//			_GameLayer.addChild(scene);
			this.pushScene(scene);
		}
		private function _drawScene():void
		{
//			_runningScene.visit(_backbuffer);
			
			
			// 绘制到精灵
//			_mainSprite.graphics.clear();
//			_mainSprite.graphics.beginBitmapFill(_backbuffer);
//			_mainSprite.graphics.drawRect(0,0,_backbuffer.width,_backbuffer.height);
//			_mainSprite.graphics.endFill();
		}

		
		
		
		private var _winSize:Point = new Point();

		public function get winSize():Point
		{
			return _winSize;
		}

		/**
		 * 设置窗口大小 
		 * @param value
		 * 
		 */
		public function set winSize(value:Point):void
		{
			_winSize = value;
		}
		
		
		private var _mainSprite:Sprite = null;

		/**
		 * 主绘制体 
		 */
		public function get mainSprite():Sprite
		{
			return _mainSprite;
		}

		/**
		 * @private
		 */
		public function set mainSprite(value:Sprite):void
		{
			if(_mainSprite != value)
			{
				_mainSprite = value;
				_initailze_lazy();
				
			}
		}
		
		public static function get scene():Sprite
		{
			return o._runningScene;	
		}
		
		
		private var _actionManager:FActionManager;

		/**
		 * 运动管理器 
		 */
		public function get actionManager():FActionManager
		{
			return _actionManager;
		}
		
		

		public function update(currenttime:Number, escapetime:Number):void
		{
			_actionManager.update(currenttime,escapetime);
			
			_drawState();
			
		}
		
		
		
		private var _fpsTxt:TextField = null;
		
		private var _fps:int = 0;
		private var _fpslasttime:Number = 0;
		/**
		 * 绘制状态 
		 * 
		 */
		private function _drawState():void
		{
			if(!_showState)
				return;
			_fps ++;
			if((_lasttimetick -  _fpslasttime) > 1000)
			{
				_fpslasttime = _lasttimetick;
//				_runningScene.numChildren
				_fpsTxt.htmlText = "FPS:" + _fps + "Count:" + _runningScene.numChildren + "\n";
				_fps = 0;
				
			}
		}
	}
}