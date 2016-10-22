package SJ.Game.heroPropertyUI
{
	import flash.geom.Rectangle;
	
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	import engine_starling.utils.SStringUtils;
	
	import feathers.controls.ImageLoader;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	/**
	 * 
	 * @author kaixin
	 */
	public class CJHeroUISkillItem extends SLayer
	{
		private const _CONST_WIDTH_:uint = 22;
		private const _CONST_HEIGHT_:uint = 22;
		
		private var _skillid:uint;
		/** 技能id **/
		public function get skillid():uint
		{
			return _skillid;
		}
		/**
		 * @private
		 */
		public function set skillid(value:uint):void
		{
			_skillid = value;
		}

		/** 底框 **/
		private var _imgBG:ImageLoader;
		/** 技能Icon **/
		private var _imgIcon:ImageLoader;
		/** 选中框 **/
		private var _pickImg:Scale9Image;
		
		public function CJHeroUISkillItem()
		{
			super();
			
			_tInit();
		}
		
		/**
		 * 初始化数据
		 */
		private function _tInit():void
		{
			_imgBG = new ImageLoader;
			_imgBG.source = SApplication.assets.getTexture("common_tubiaokuang1");
			_imgBG.width = _CONST_WIDTH_;
			_imgBG.height = _CONST_HEIGHT_;
			addChild(_imgBG);
			
			// 技能icon
			_imgIcon = new ImageLoader;
			_imgIcon.x = 2;
			_imgIcon.y = 2;
			_imgIcon.width = _CONST_WIDTH_ - 4;
			_imgIcon.height = _CONST_HEIGHT_ - 4;
			addChild(_imgIcon);
			// 选中框
			_pickImg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_daojutubiaomiaobian02") , new Rectangle(8,8,1,1)));
			_pickImg.width = _CONST_WIDTH_;
			_pickImg.height = _CONST_HEIGHT_;
			addChild(_pickImg);
		}
		
		/**
		 * 设置显示内容
		 * @param pSkillid		技能id
		 * @param value			纹理名称
		 * @param isShowRect	是否显示选中框
		 */
		public function setContain(value:String, tSkillid:int=0, isShowRect:Boolean=false):void
		{
			isSelected = isShowRect;
			skillid = tSkillid;
			
			if (SStringUtils.isEmpty(value))
			{
				_imgIcon.source = null
				return;
			}
			
			_imgIcon.source = SApplication.assets.getTexture(value);
		}
		
		/**
		 * 是否被选中
		 * @param value
		 */
		public function set isSelected(value:Boolean):void
		{
			_pickImg.visible = value;
		}
		/**
		 * @private
		 * */
		public function get isSelected():Boolean
		{
			return _pickImg.visible;
		}
	}
}