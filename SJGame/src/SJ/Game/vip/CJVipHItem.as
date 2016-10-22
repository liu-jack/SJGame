package SJ.Game.vip
{
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	
	import feathers.controls.ImageLoader;
	import feathers.display.Scale3Image;
	import feathers.textures.Scale3Textures;
	
	/**
	 * VIP水平滑动面板子控件
	 * @author longtao
	 */
	public class CJVipHItem extends SLayer// extends CJItemTurnPageBase
	{
		private const ITEM_WIDTH:int = 480;
		private const ITEM_HEIGHT:int = 320;
		
		private var _index:int = 0;
		
		/** 特权标题BG **/
		private var _privilegeTitleBG:Scale3Image;
		/** vip特权特效字 **/
		private var _privilegeWord:ImageLoader;
		
		/** 特权明细面板 **/
		private var _vipVPanel:CJVipVPanel;
		
		public function CJVipHItem()
		{
			super();
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			width = ITEM_WIDTH;
			height = ITEM_HEIGHT;
			
			_privilegeTitleBG = new Scale3Image(new Scale3Textures(SApplication.assets.getTexture("vip_viplieditu"), 10 , 2));
			_privilegeTitleBG.x = 0;
			_privilegeTitleBG.y = 0;
			_privilegeTitleBG.width = width;
			addChild(_privilegeTitleBG);
			
			_privilegeWord = new ImageLoader;
			_privilegeWord.x = 3;
			_privilegeWord.y = 8;
			addChild(_privilegeWord);
			_privilegeWord.source = SApplication.assets.getTexture("vip_tequanwenzi");
			
			_refresh();
		}
		
		/** 刷新 **/
		private function _refresh():void
		{
			// 重新绘制
			// 特权明细面板 垂直滑动面板
			if (null == _vipVPanel)
			{
				_vipVPanel = new CJVipVPanel(index);
				addChild(_vipVPanel);
			}
			if (_vipVPanel.index != index)
			{
				_vipVPanel.removeFromParent(true);
				_vipVPanel = null;
				_vipVPanel = new CJVipVPanel(index);
				addChild(_vipVPanel);
			}
			_vipVPanel.x = 0;
			_vipVPanel.y = 45;
			_vipVPanel.updateLayer();
		}

		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
		}

	}
}