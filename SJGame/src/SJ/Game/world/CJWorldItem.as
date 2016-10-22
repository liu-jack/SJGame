package SJ.Game.world
{
	import SJ.Common.Constants.ConstFilter;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	
	import starling.textures.Texture;
	
	/**
	 *  城镇或副本item
	 * @author yongjun
	 * 
	 */
	public class CJWorldItem extends SLayer
	{
		private var _type:int;
		private var _id:int;
		private var _name:String;
		private var _button:Button;
		private var _nameImage:SImage;
		private var _nameLabel:Label;
		
		private var _status:int
		private var _reason:String;
		//主城
		public static var ITEM_TYPE_CITY:int = 0;
		//普通副本
		public static var ITEM_TYPE_FUBEN:int = 1;
		//精英副本
		public static var ITEM_TYPE_SUPERFB:int = 2;
		//副本不可进
		public static var ITEM_STATUS_UNABLE:int = 0
		//副本可进
		public static var ITEM_STATUS_ABLE:int = 1;
		
		public function CJWorldItem(type:int)
		{
			super();
			this.useHandCursor = true;
			this._type = type;
			_init();
			_initName();
		}
		
		private function _init():void
		{
			_button = new Button;
			this.addChild(_button);
		}
		
		private function _initName():void
		{
			var texture:Texture = SApplication.assets.getTexture("daditu_zikuang")
			_nameImage = new SImage(texture)
			this.addChild(_nameImage)
			_nameLabel = new Label
			_nameLabel.textRendererProperties.textFormat = ConstTextFormat.worldnametxt
			_nameLabel.width = texture.width
			this.addChild(_nameLabel)
		}
		/**
		 *  
		 * @param data
		 * 
		 */
		private var _iconImage:SImage
		public function set data(data:Object):void
		{
			_id = data.itemid;
			_name = data.name;
			
			var texture:Texture = SApplication.assets.getTexture(data.icon)
			_iconImage= new SImage(texture);
			_button.defaultIcon = _iconImage;

				
			_nameImage.x = (texture.width - _nameImage.texture.width)>>1
			_nameImage.y = texture.height;
			_nameLabel.x = _nameImage.x;
			_nameLabel.y = _nameImage.y;
			_nameLabel.text = CJLang(_name);
		}
		
		public function set fubendata(data:Object):void
		{
			if(data['ret'] == ITEM_STATUS_UNABLE)
			{
				_iconImage.filter = ConstFilter.genBlackFilter();
			}
			_status = data['ret'];
			_reason = data.reason;
		}
		public function clearFilter():void
		{
			_iconImage.filter = null;
		}
		public function get reason():String
		{
			return _reason;
		}
		public function get status():int
		{
			return _status;
		}
		public function get type():int
		{
			return this._type;
		}
		public function get id():int
		{
			return this._id;
		}
	}
}