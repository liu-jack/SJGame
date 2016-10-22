package SJ.Game.map
{
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.textures.Texture;

	public class CJBattleMapLayerSkillMask extends MapLayer
	{
		private var _count:int = 0;
		
		public function CJBattleMapLayerSkillMask()
		{
			super();
			
			
			touchable = false;
			this.addChild(new SImage(Texture.fromColor(SApplicationConfig.o.stageWidth,SApplicationConfig.o.stageHeight,0xFF000000),true));
			_adjust();
		}
		public function reset():void
		{
			_count = 0;
			_adjust();
		}
		public function pushActive():void
		{
			_count ++;
			_adjust();
		}
		public function popActive():void
		{
			_count --;
			_adjust();
		}
		
		private function _adjust():void
		{
			if(_count< 0 )
			{
				Assert(false,"攻击特效时序错误!");
				_count == 0;
			}
			if(_count == 0)
			{
				alpha = 0.001;
			}
			else
			{
				alpha = 0.7;
			}
			
		}
	}
}