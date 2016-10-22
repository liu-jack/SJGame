package SJ.Game.enhanceequip
{
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * CheckBox
	 * @author sangxu
	 * 
	 */	
	public class CJEnhanceLayerCheckbox extends SLayer
	{
		/** 图片 - 框 */
		private static const IMG_NAME_BOX:String = "zhuangbei_fuxuankuang";
		/** 图片 - 钩 */
		private static const IMG_NAME_CHECK:String = "zhuangbei_duihao";
		/** 框图片与钩间隔 */
		private static const DEFAULT_SPACEX:int = 1;
		private static const DEFAULT_SPACEY:int = 2;
		
		/** 框图片 */
		private var _imgBox:SImage;
		/** 选中图片 */
		private var _imgCheck:SImage;
		/** 框图片 */
		private var _imgNameBox:String = IMG_NAME_BOX;
		/** 选中图片 */
		private var _imgNameCheck:String = IMG_NAME_CHECK;
		/** 选中与否 */
		private var _checked:Boolean = false;
		
		private var _spaceX:int = DEFAULT_SPACEX;
		private var _spaceY:int = DEFAULT_SPACEY;
		
		private var _boxWidth:int = 12;
		private var _boxHeight:int = 12;
		private var _checkWidth:int = 15;
		private var _checkHeight:int = 16;
		
		public function CJEnhanceLayerCheckbox()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
		}
		
		/**
		 * 初始layer，创建控件
		 * 
		 */		
		public function initLayer():void
		{
			// 框
			this._imgBox = new SImage(SApplication.assets.getTexture(_imgNameBox));
			this._imgBox.width = _boxWidth;
			this._imgBox.height = _boxHeight;
			this._imgBox.x = _spaceX;
			this._imgBox.y = _spaceY;
			this.addChild(this._imgBox);
			
			// 钩
			this._imgCheck = new SImage(SApplication.assets.getTexture(_imgNameCheck));
			this._imgCheck.width = _checkWidth;
			this._imgCheck.height = _checkHeight;
			this._imgCheck.x = 0;
			this._imgCheck.y = 0;
			if (true == _checked)
			{
				this._imgCheck.visible = true;
			}
			else
			{
				this._imgCheck.visible = false;
			}
			this.addChild(this._imgCheck);
		}
		
		
		/**
		 * 设置选中
		 * @param value
		 * @return 
		 * 
		 */		
		public function set checked(value : Boolean):void
		{
			this._checked = value;
			if (true == value)
			{
				// 选中
				this._imgCheck.visible = true;
			}
			else
			{
				// 未选中
				this._imgCheck.visible = false;
			}
		}
		
		/**
		 * 是否已选中
		 * @return 
		 * 
		 */		
		public function get isChecked():Boolean
		{
			return this._checked;
		}
		
		/**
		 * 切换当前选中与未选中状态
		 * 
		 */		
		public function toggle():void
		{
			this.checked = !this.isChecked;
		}
		
		/** setter */
		/**
		 * 设置框图片
		 * @param value
		 * 
		 */		
		public function set boxImage(value:String):void
		{
			this._imgNameBox = value;
		}
		/**
		 * 设置钩图片
		 * @param value
		 * 
		 */		
		public function set checkImage(value:String):void
		{
			this._imgNameCheck = value;
		}
		/**
		 * 设置框宽
		 * @param value
		 * 
		 */		
		public function set boxWidth(value:int):void
		{
			this._boxWidth = value;
		}
		/**
		 * 设置框高
		 * @param value
		 * 
		 */		
		public function set boxHeight(value:int):void
		{
			this._boxHeight = value;
		}
		/**
		 * 设置钩宽
		 * @param value
		 * 
		 */		
		public function set checkWidth(value:int):void
		{
			this._checkWidth = value;
		}
		/**
		 * 设置钩高
		 * @param value
		 * 
		 */		
		public function set checkHeight(value:int):void
		{
			this._checkHeight = value;
		}
		/**
		 * 设置框与钩的x方向间隔，以钩x为原点
		 * @param value
		 * 
		 */		
		public function set spaceX(value:int):void
		{
			this._spaceX = value;
		}
		/**
		 * 设置框与钩的y方向间隔，以钩y为原点
		 * @param value
		 * 
		 */		
		public function set spaceY(value:int):void
		{
			this._spaceY = value;
		}
	}
}