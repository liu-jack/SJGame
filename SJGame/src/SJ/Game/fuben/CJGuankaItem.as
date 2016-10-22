package SJ.Game.fuben
{
	import SJ.Common.Constants.ConstFilter;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Label;
	
	import starling.textures.Texture;
	
	/**
	 *  关卡图标Item
	 * @author yongjun
	 * 
	 */
	public class CJGuankaItem extends SLayer
	{
		private var _id:int;
		private var _img:SImage
		private var _nameBg:SImage;
		private var _nameLabel:Label;
		private var _status:int;
		private var _reasonCode:int;
		private var _passImg:SImage;
		//未通关 ，不能进入
		public static var GUANKA_UNPASS:int = 0;
		//未通关，可进入
		public static var GUANKA_CANENTER:int = 1;
		//已通关
		public static var GUANKA_PASS:int = 2;

		public function CJGuankaItem(id:int)
		{
			super();
			this._id = id;
			init();
		}

		private function init():void
		{
			//名称底图
			var texture:Texture = SApplication.assets.getTexture("fuben_mingchengdi");
			_nameBg = new SImage(texture);
			this.addChild(_nameBg);
			
			this.setSize(texture.width,texture.height);
			//名字
			_nameLabel = new Label;
			_nameLabel.textRendererProperties.textFormat = ConstTextFormat.fubenitemtextformat;
			_nameLabel.x = 20;
			this.addChild(_nameLabel);
			//通关图标
			_passImg = new SImage(Texture.empty(61,37),true);
			this.addChild(_passImg)
		}
		
		public function get id():int
		{
			return this._id;
		}
		
		/**
		 * 设置ICON图标 
		 * @param path
		 * 
		 */
		public function set source(path:String):void
		{
			//ICON 图标
			_img = new SImage(SApplication.assets.getTexture(path));
			this.addChildAt(_img,0);
			
			_nameBg.y = _img.texture.height-8;
			_nameLabel.y = _nameBg.y+5;
		}
		
		override protected function draw():void
		{
			if(_status == CJGuankaItem.GUANKA_PASS)
			{
				//				_passImg.texture = SApplication.assets.getTexture("fuben_jibai");
				//				_passImg.readjustSize();
			}
			if(_status == CJGuankaItem.GUANKA_UNPASS)
			{
				_img.filter = ConstFilter.genBlackFilter()
			}
			if(_status == CJGuankaItem.GUANKA_CANENTER)
			{
//				_passImg.texture = SApplication.assets.getTexture("fuben_new");
//				_passImg.readjustSize();
			}
		}
		
		/**
		 * 设置状态 
		 * @param s
		 * 
		 */
		public function set status(s:int):void
		{
			_status = s;
			this.invalidate();
		}
		
		public function get status():int
		{
			return this._status	
		}
		/**
		 * 设置状态 
		 * @param s
		 * 
		 */
		public function set reasonCode(s:int):void
		{
			_reasonCode = s;
			this.invalidate();
		}
		
		public function get reasonCode():int
		{
			return this._reasonCode
		}
		/**
		 *  设置名称
		 * @param value
		 * 
		 */
		public function set gname(value:String):void
		{
			_nameLabel.text = CJLang(value);
			
		}
	}
}