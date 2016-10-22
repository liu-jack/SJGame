package SJ.Game.jewelCombine
{
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	
	public class CJJewelSelectLevelItem extends SLayer
	{
		/**选择的级别*/
		private var _level:int;
		/**选择的按钮*/
		private var _btnSelect:Button;
		public function CJJewelSelectLevelItem()
		{
			super();
			_init();
		}
		/**
		 * 设置默认数据
		 */		
		private function _init():void
		{
			_btnSelect = new Button();
			_btnSelect.defaultSkin = new SImage(SApplication.assets.getTexture("baoshi_danxuananniu02"));
			_btnSelect.defaultSelectedSkin = new SImage(SApplication.assets.getTexture("baoshi_danxuananniu01"));
			this.addChild(_btnSelect);
		}
		/**选择的级别*/
		public function get level():int
		{
			return _level;
		}

		/**
		 * @private
		 */
		public function set level(value:int):void
		{
			_level = value;
		}

		/**选择的按钮*/
		public function get btnSelect():Button
		{
			return _btnSelect;
		}

		/**
		 * @private
		 */
		public function set btnSelect(value:Button):void
		{
			_btnSelect = value;
		}

	}
}