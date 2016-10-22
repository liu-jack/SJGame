package SJ.Game.map
{
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	
	import starling.textures.Texture;

	public class CJBattleMapLayerSkillLayer extends MapLayer
	{
		public function CJBattleMapLayerSkillLayer()
		{
			super();
		}
		private var _selfSkillLayer:MapLayer;
		private var _otherSkillLayer:MapLayer;
		
		/**
		 * 自身技能特效层 
		 * @return 
		 * 
		 */
		public function get selfSkillLayer():MapLayer
		{
			return _selfSkillLayer;
		}
		
		/**
		 * 敌方技能特效层 
		 * @return 
		 * 
		 */
		public function get otherSkillLayer():MapLayer
		{
			return _otherSkillLayer;
		}
		
		override protected function draw():void
		{
			// TODO Auto Generated method stub
			super.draw();
		}
		
		override protected function initialize():void
		{
			// TODO Auto Generated method stub
			_selfSkillLayer = new MapLayer();
			addChild(_selfSkillLayer);
			_otherSkillLayer = new MapLayer();
			addChild(_otherSkillLayer);
			
			_otherSkillLayer.width = SApplicationConfig.o.stageWidth;
			_otherSkillLayer.height = SApplicationConfig.o.stageHeight;
			_otherSkillLayer.pivotX = SApplicationConfig.o.stageWidth;
			
//			var posHelper:SImage = new SImage(Texture.fromColor(240,320,0xFFFF0000),true);
//			_otherSkillLayer.addChild(posHelper);
//			_otherSkillLayer.pivotY = 160;
//			_otherSkillLayer.x = 240;
//			_otherSkillLayer.y = 160;
			_otherSkillLayer.scaleX = -1;
//			_otherSkillLayer.x = SApplicationConfig.o.stageWidth / 2;
//			_otherSkillLayer.y = SApplicationConfig.o.stageHeight / 2;
//			_otherSkillLayer.pivotX = SApplicationConfig.o.stageWidth / 2;
//			_otherSkillLayer.pivotY = SApplicationConfig.o.stageHeight / 2;
			super.initialize();
		}
		
		
	}
}