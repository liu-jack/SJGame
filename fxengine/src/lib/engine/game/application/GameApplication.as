package lib.engine.game.application
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import lib.engine.data.module.CDataModuleManager;
	import lib.engine.event.CEvent;
	import lib.engine.event.CEventSubject;
	import lib.engine.event.CEventVar;
	import lib.engine.game.Canvas.GameCanvas;
	import lib.engine.game.Canvas.Indexs.GameCanvasIndex_Fourforkstree;
	import lib.engine.game.module.CModuleSubSystemManager;
	import lib.engine.game.scene.SceneManager;
	import lib.engine.game.state.GameStateManager;
	import lib.engine.ui.layers.CUILayer;
	import lib.engine.resources.ResourceManager;
	import lib.engine.resources.loader.ResourceLoader_AnimGroup;
	import lib.engine.resources.loader.ResourceLoader_Group;
	import lib.engine.resources.loader.ResourceLoader_Images;
	import lib.engine.resources.loader.ResourceLoader_JSON;
	import lib.engine.resources.loader.ResourceLoader_Jpeg;
	import lib.engine.resources.loader.ResourceLoader_Jpg;
	import lib.engine.resources.loader.ResourceLoader_Layout;
	import lib.engine.resources.loader.ResourceLoader_Lua;
	import lib.engine.resources.loader.ResourceLoader_Png;
	import lib.engine.resources.loader.ResourceLoader_Sence;
	import lib.engine.resources.loader.ResourceLoader_Swf;
	import lib.engine.resources.loader.ResourceLoader_Zip;
	import lib.engine.resources.loader.ResourceLoader_gif;
	import lib.engine.ui.Manager.UIManager;
	import lib.engine.utils.CTickUtils;
	
	/**
	 * 游戏应用程序 
	 * @author caihua
	 * 
	 */
	public class GameApplication extends Sprite
	{
		
		protected var _gameCanvas:GameCanvas;
		protected var _gameState:GameStateManager;
		protected var _gameResourceManager:ResourceManager;
		protected var _UI_Layout:CUILayer;
		protected var _UI_Canvas:UIManager;
		protected var _sceneManager:SceneManager;
		protected var _eventBus:CEventSubject;
		protected var _cTickManager:CTickUtils;
		protected var _dataManager:CDataModuleManager;
		
		/**
		 * 消息总线 
		 */
		public function get eventBus():CEventSubject
		{
			return _eventBus;
		}
		
		
		/**
		 * 游戏模块管理器 
		 */
		protected var _ModuleManager:CModuleSubSystemManager;
		/**
		 * 游戏模块管理器 
		 */
		public function get ModuleManager():CModuleSubSystemManager
		{
			return _ModuleManager;
		}
		
		
		public function get UI_Canvas():UIManager
		{
			return _UI_Canvas;
		}
		
		public function get _Layout():CUILayer
		{
			return _UI_Layout;
		}
		/**
		 * 游戏场景状态机 
		 * @return 
		 * 
		 */
		public function get gameState():GameStateManager
		{
			return _gameState;
		}
		
		
		/**
		 * 游戏Canvas 
		 * @return 
		 * 
		 */
		public function get gameCanvas():GameCanvas
		{
			return _gameCanvas;
		}
		
		public function GameApplication()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,function(e:Event):void{_Init();});
		}
		/**
		 * 系统初始化 
		 * 
		 */
		private function _Init():void
		{
			
			
			_onInitBefore();
			_onInitSystem();
			_onInitGameCanvas();
			_onInitSceneManager();
			_onInitResource();
			_onInitUISystem();
			_onInitGameState();
			
		}
		/**
		 * 初始化系统 
		 * 
		 */
		private function _onInitSystem():void
		{
			_eventBus = new CEventSubject();
			_cTickManager = CTickUtils.o;
			_ModuleManager = new CModuleSubSystemManager();
			_ModuleManager.Init();
			
			//初始化数据模块
			_ModuleManager.registerAndInit(_dataManager = new CDataModuleManager());
			
			
		}
		/**
		 * 通用初始化 前
		 * 
		 */
		protected function _onInitBefore():void
		{
			
		}
		/**
		 * 通用初始化 后
		 * 
		 */
		protected function _onInitAfter():void
		{
			
		}
		/**
		 * 初始化游戏状态 
		 * 
		 */
		protected function _onInitGameState():void
		{
			_ModuleManager.registerAndInit(_gameState = new GameStateManager());
		}
		
		/**
		 * 初始化GameCanvas 
		 * 可以重写,用Custom的 
		 */
		protected function _onInitGameCanvas():void
		{
		
			_ModuleManager.registerAndInit(_gameCanvas = new GameCanvas(new Sprite()));
//			_ModuleManager.enterModule(_gameCanvas.name);
			_gameCanvas.setSize(800,600);
			_gameCanvas.ContainIndex = new GameCanvasIndex_Fourforkstree();
//			_gameCanvas.Init();
			this.addChild(_gameCanvas.renderable);
		}
		
		/**
		 * 初始化必要的数据模块 
		 * 
		 */
		protected function _onInitGameDataModule():void
		{
			
		}
		/**
		 * 初始化游戏模块 
		 * 
		 */
		protected function _onInitGameModule():void
		{
			
		}
		
		/**
		 * 初始化资源 
		 * 
		 */
		protected function _onInitResource():void
		{
			_gameResourceManager = ResourceManager.o;
			
			_gameResourceManager.RegisterResourceLoader(new ResourceLoader_Swf());
			_gameResourceManager.RegisterResourceLoader(new ResourceLoader_Group());
			_gameResourceManager.RegisterResourceLoader(new ResourceLoader_Zip());
			_gameResourceManager.RegisterResourceLoader(new ResourceLoader_Images());
			_gameResourceManager.RegisterResourceLoader(new ResourceLoader_JSON());
			_gameResourceManager.RegisterResourceLoader(new ResourceLoader_Layout());
			_gameResourceManager.RegisterResourceLoader(new ResourceLoader_AnimGroup());
			_gameResourceManager.RegisterResourceLoader(new ResourceLoader_Sence());
			_gameResourceManager.RegisterResourceLoader(new ResourceLoader_Lua());
			_gameResourceManager.RegisterResourceLoader(new ResourceLoader_gif());
			_gameResourceManager.RegisterResourceLoader(new ResourceLoader_Png());
			_gameResourceManager.RegisterResourceLoader(new ResourceLoader_Jpeg());
			_gameResourceManager.RegisterResourceLoader(new ResourceLoader_Jpg());
			_gameResourceManager.addEventListener(CEventVar.E_RESOURCELOADCOMPLETE,_onInitResourceLoaded);
			
		}
		
		/**
		 * 必要资源加载完成 
		 * 完成后续初始化
		 */
		protected function _onInitResourceLoaded(e:CEvent):void
		{
			_gameResourceManager.removeEventListener(CEventVar.E_RESOURCELOADCOMPLETE,_onInitResourceLoaded);
			
			_onInitGameDataModule();
			_onInitGameModule();
			_onInitAfter();
			
			
		}
		/**
		 * 初始化UI系统 
		 * 
		 */		
		protected function _onInitUISystem():void
		{
			_UI_Layout = new CUILayer();
			this.addChild(_UI_Layout);
		}
		
		
		protected function _onInitSceneManager():void
		{
			_ModuleManager.registerAndInit(_sceneManager = new SceneManager(_gameCanvas));
		}
		
		/**
		 * 场景管理器类 
		 * @return 
		 * 
		 */
		public function get sceneManager():SceneManager
		{
			return _sceneManager;
		}
		
		public function get dataManager():CDataModuleManager
		{
			return _dataManager;
		}
		
		
	}
}