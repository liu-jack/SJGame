package SJ.Game.controls
{
	import SJ.Game.data.CJDataOfSkillSettting;
	
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	
	import feathers.controls.ImageLoader;
	
	/**
	 * 技能图标显示控件
	 * @author longtao
	 */
	public class CJSkillIconLayer extends SLayer
	{
		private static const SKILL_ICON_WIDTH:int = 50;
		private static const SKILL_ICON_HEIGHT:int = 50;
		
		//技能图标
		private var _icon:ImageLoader;
		
		// 技能id
		private var _skillid:uint = 0;
		
		public function CJSkillIconLayer()
		{
			super();
			
			_init();
		}
		
		// 初始化
		public function _init():void
		{
			width = SKILL_ICON_WIDTH;
			height = SKILL_ICON_WIDTH;
			
			_icon = new ImageLoader();
			_icon.x = 0;
			_icon.y = 0;
			_icon.width = width;
			_icon.height = height;
			addChild(_icon);
		}
		
		// 绘制
		private function _draw():void
		{
			var skillConfig:Object = CJDataOfSkillSettting.o.getProperty(_skillid);
			if ( null == skillConfig )
				return;
			
			// 更新资源
			_icon.source = SApplication.assets.getTexture(skillConfig.skillicon);
		}
		
		/**
		 * 技能id
		 * @param value
		 * 
		 */
		public function set skillid(value:uint):void
		{
			if (_skillid == value)
				return;
			
			_skillid = value;
			_draw();
		}
		public function get skillid():uint
		{
			return _skillid;
		}
	}
}