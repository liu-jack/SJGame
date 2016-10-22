package engine_starling
{
	
	
	import engine_starling.core.SJuggler;
	import engine_starling.display.SNode;
	import engine_starling.utils.Logger;
	
	import lib.engine.game.module.CModuleSubSystemManager;
	import lib.engine.game.state.GameStateManager;
	import lib.engine.utils.functions.Assert;
	
	import starling.core.Starling;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	/**
	 * 游戏代理主程序 
	 * @author caihua
	 * 
	 */
	public class SApplication extends SNode
	{
		private static var _Juggler:SJuggler;
		private var _logger:Logger = Logger.getInstance(SApplication);

		/**
		 * 动画控制器 
		 */
		public static function get juggler():SJuggler
		{
			if(_Juggler == null)
			{
				_Juggler = new SJuggler();
				Starling.juggler.add(_Juggler);
			}
			return _Juggler;
		}

		public function SApplication()
		{
			super();
			
			_rootNode = new SNode();
			addChild(_rootNode);
			
			_UIRootNode = new SNode();
			addChild(_UIRootNode);
			
		}
		
		private static var _assets:AssetManager;

		/**
		 * 全局资源管理器 
		 */
		public static function get assets():AssetManager
		{
			return _assets;
		}
		
		private static var _moduleManager:CModuleSubSystemManager = null;

		/**
		 * 全局模块管理器 
		 */
		public static function get moduleManager():CModuleSubSystemManager
		{
			return _moduleManager;
		}

		
		private static var _stateManager:GameStateManager = null;

		/**
		 * 状态管理器 
		 */
		public static function get stateManager():GameStateManager
		{
			return _stateManager;
		}


		private static var _rootNode:SNode = null;

		/**
		 * 场景根节点 ,初始化程序的时候被初始化
		 */
		public static function get rootNode():SNode
		{
			return _rootNode;
		}
		
		private static var _UIRootNode:SNode = null;
		
		/**
		 * UI根节点 
		 * @return 
		 * 
		 */
		public static function get UIRootNode():SNode
		{
			return _UIRootNode;
		}
		
		private static var _mStarlingInstance:Starling;

		/**
		 * starling实例 
		 */
		public static function get StarlingInstance():Starling
		{
			return _mStarlingInstance;
		}

		/**
		 * @private
		 */
		public static function set StarlingInstance(value:Starling):void
		{
			if(_mStarlingInstance == null)
			{
				_mStarlingInstance = value;
				
			}
		}
		/**
		 * qidong de huidiao 
		 */
		private var _lauchfunction:Function = null;
		private static var _appInstance:SApplication;

		/**
		 * 应用程序实例 
		 */
		public static function get appInstance():SApplication
		{
			return _appInstance;
		}


		/**
		 * 程序启动 
		 * @param assets
		 * @param lauched function():void
		 */
		internal final function appLauched(assets:AssetManager,lauched:Function = null):void
		{
			if(_appInstance == null)
				_appInstance = this;
			_assets = assets;
			_lauchfunction = lauched;
			_onInitBefore();
			_onInitSystem();
			
			_onInitResource(_assets);
			//后续需要手动调用 _loadResource
			_logger.info("wait to loadResource");
			
		}
		
		/**
		 * 初始化系统 
		 * 
		 */
		private function _onInitSystem():void
		{
			(_moduleManager = new CModuleSubSystemManager()).Init();
		}
		private function _onInitSystemAfterResourceLoaded():void
		{
			
			_moduleManager.registerAndInit(_stateManager = new GameStateManager());
			_stateManager = _moduleManager.getModule(_stateManager.name) as GameStateManager;
			_stateManager.Enter();
			_onInitGameState();
		}
		/**
		 * 通用初始化 前
		 * 
		 */
		protected function _onInitBefore():void
		{
			
		}
		/**
		 * 通用初始化 后 所有测资源都加载完后执行初始化
		 * 
		 */
		protected function _onInitAfter():void
		{
			
		}
		/**
		 * 初始化资源 
		 * @param assets
		 * 
		 */
		protected function _onInitResource(assets:AssetManager):void
		{
			
		}
		/**
		 * begin load resource 
		 * 
		 */
		protected function _loadResource():void
		{
			assets.loadQueue (function(ratio:Number):void{
				
				if(ratio == 1 || isNaN(ratio))
				{	
					
					assets.addTexture("no_tex",Texture.empty(2,2));
					_onInitSystemAfterResourceLoaded();
					_onInitAfter();
					Logger.log("Application","AppLauched");
					Starling.juggler.delayCall(_onAppLauched,0.10);
					if(_lauchfunction != null)
					{
						_lauchfunction();
					}
				}
				else
				{
					_onResourceLoad(ratio);
				}
			});
		}
		/**
		 * 资源加载进度 
		 * @param ratio
		 * 
		 */
		protected function _onResourceLoad(ratio:Number):void
		{
			
		}
		
		protected function _onInitGameState():void
		{
			
		}
		
	
		/**
		 * 重载此函数！ 程序启动 
		 * 
		 */
		protected function _onAppLauched():void
		{
			Assert(false,"override me!");	
		}
		
		
	}
}