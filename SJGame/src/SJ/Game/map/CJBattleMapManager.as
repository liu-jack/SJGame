package SJ.Game.map
{
	import engine_starling.SApplication;
	import engine_starling.commandSys.core.SCommandBase;
	import engine_starling.display.SMuiscNode;
	import engine_starling.display.SNode;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.SMuiscChannel;
	
	import flash.media.Sound;

	public class CJBattleMapManager
	{
		public function CJBattleMapManager()
		{
			_onInit();
		}
		
		private static var _ins:CJBattleMapManager = null;
		public static function get o():CJBattleMapManager
		{
			if(_ins == null)
				_ins = new CJBattleMapManager();
			return _ins;
		}
		
		private var _rootMapLayer:CJBattleRootLayer = null;

		/**
		 * 地图根节点 
		 */
		public function get rootMapLayer():CJBattleRootLayer
		{
			return _rootMapLayer;
		}

		private var _debugLayer:MapLayer = null;

		/**
		 * 调试控制节点 
		 */
		public function get debugLayer():MapLayer
		{
			return _debugLayer;
		}

		/**
		 * @private
		 */
		public function set debugLayer(value:MapLayer):void
		{
			_debugLayer = value;
		}

		
		private var _topLayer:MapLayer = null;

		/**
		 * 最上层节点 
		 */
		public function get topLayer():MapLayer
		{
			return _topLayer;
		}

		private var _playerLayer:CJPlayerSceneLayer = null;

		/**
		 * 玩家层 
		 */
		public function get playerLayer():MapLayer
		{
			return _playerLayer;
		}

		private var _backgroundLayer:MapLayer = null;

		/**
		 * 背景层 
		 */
		public function get backgroundLayer():MapLayer
		{
			return _backgroundLayer;
		}
		
		private var _qteLayer:MapLayer = null;

		/**
		 * qte图层 
		 */
		public function get qteLayer():MapLayer
		{
			return _qteLayer;
		}
		private var _skillmaskLayer:CJBattleMapLayerSkillMask;

		/**
		 * 技能释放遮罩层 就是变黑那一层
		 */
		public function get skillmaskLayer():CJBattleMapLayerSkillMask
		{
			return _skillmaskLayer;
		}

		/**
		 * @private
		 */
		public function set skillmaskLayer(value:CJBattleMapLayerSkillMask):void
		{
			_skillmaskLayer = value;
		}

		private var _playerInfoLayer:MapLayer = null;

		/**
		 *  玩家信息层 
		 */
		public function get playerInfoLayer():MapLayer
		{
			return _playerInfoLayer;
		}

		/**
		 * @private
		 */
		public function set playerInfoLayer(value:MapLayer):void
		{
			_playerInfoLayer = value;
		}

		
		private var _scoreLayer:MapLayer = null;

		/**
		 * 分数层 
		 */
		public function get scoreLayer():MapLayer
		{
			return _scoreLayer;
		}

		/**
		 * @private
		 */
		public function set scoreLayer(value:MapLayer):void
		{
			_scoreLayer = value;
		}
		
		private var _skillLayer:CJBattleMapLayerSkillLayer = null;

		/**
		 * 技能图层 
		 */
		public function get skillLayer():CJBattleMapLayerSkillLayer
		{
			return _skillLayer;
		}

		/**
		 * @private
		 */
		public function set skillLayer(value:CJBattleMapLayerSkillLayer):void
		{
			_skillLayer = value;
		}
		
		private var _skillBackLayer:CJBattleMapLayerSkillLayer = null;

		/**
		 * 技能人物背后层 
		 */
		public function get skillBackLayer():CJBattleMapLayerSkillLayer
		{
			return _skillBackLayer;
		}

		/**
		 * @private
		 */
		public function set skillBackLayer(value:CJBattleMapLayerSkillLayer):void
		{
			_skillBackLayer = value;
		}

		
		private function _onInit():void
		{
			_rootMapLayer = new CJBattleRootLayer();
			
			_backgroundLayer = new MapLayer();
			_rootMapLayer.addChild(_backgroundLayer);
			
//			var sound:Sound = AssetManagerUtil.o.getObject("battlestarttest.mp3") as Sound;
//			var c:SMuiscChannel = new SMuiscChannel(sound,"battlestarttest.mp3");
//			c.fadeIn(true,3);
		
//			var soundNode:SMuiscNode = new SMuiscNode(SMuiscChannel.SMuiscChannelCreateByName("battlestarttest.mp3"));
//			soundNode.loop = true;
//			_backgroundLayer.addChild(soundNode);
			
			_skillmaskLayer = new CJBattleMapLayerSkillMask;
			_rootMapLayer.addChild(_skillmaskLayer);
			
			_skillBackLayer = new CJBattleMapLayerSkillLayer();
			_rootMapLayer.addChild(_skillBackLayer);
			
			_playerLayer = new CJPlayerSceneLayer();
			_rootMapLayer.addChild(_playerLayer);
			
			_skillLayer = new CJBattleMapLayerSkillLayer();
			_rootMapLayer.addChild(_skillLayer);
			
			_playerInfoLayer = new MapLayer();
			_rootMapLayer.addChild(_playerInfoLayer);
			
			
			
			_qteLayer = new MapLayer();
			_rootMapLayer.addChild(_qteLayer);
			
			_scoreLayer = new MapLayer();
			_rootMapLayer.addChild(_scoreLayer);
			
			_topLayer = new MapLayer();
			_rootMapLayer.addChild(_topLayer);
			
			
			_debugLayer = new MapLayer();
			_rootMapLayer.addChild(_debugLayer);
			
//			SApplication.rootNode.addChild(_rootMapLayer);

		}
		
		public static function purgeInstance():void
		{
			_ins._rootMapLayer.removeFromParent(true);
			_ins = null;
		}
		
		public function removeAllChildren():void
		{
//			_backgroundLayer.removeChildren(0,-1,true);
	
			_skillBackLayer.selfSkillLayer.removeChildren(0,-1,true);
			_skillBackLayer.otherSkillLayer.removeChildren(0,-1,true);
			_skillLayer.selfSkillLayer.removeChildren(0,-1,true);
			_skillLayer.otherSkillLayer.removeChildren(0,-1,true);
			_playerLayer.removeChildren(0,-1,true);
			_qteLayer.removeChildren(0,-1,true);
			_topLayer.removeChildren(0,-1,true);
			_scoreLayer.removeChildren(0,-1,true);
			_playerInfoLayer.removeChildren(0,-1,true);
			_debugLayer.removeChildren(0,-1,true);
			_skillmaskLayer.reset();
			
		}
		
	}
}