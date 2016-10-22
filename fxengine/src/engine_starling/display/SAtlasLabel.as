package engine_starling.display
{
	import engine_starling.SApplication;
	
	import flash.utils.Dictionary;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	import starling.utils.HAlign;

	/**
	 * 纹理Label 
	 * @author caihua
	 * 
	 */
	public class SAtlasLabel extends SLayer
	{
		private var _texture:Texture;
		private var _mapChar:Dictionary;
		private var _text:String = "";
		private var _charVec:Vector.<Image>;
		private var _hAlign:String = HAlign.LEFT;
		
		private var _space_x:int = 0;
		private static const INVALIDATION_FLAG_TEXT_DATA:String = "INVALIDATION_FLAG_TEXT_DATA";
		private static const INVALIDATION_FLAG_ADJUSTH:String = "INVALIDATION_FLAG_ADJUSTH";

		/**
		 * 横向缩进 
		 */
		public function get space_x():int
		{
			return _space_x;
		}

		/**
		 * @private
		 */
		public function set space_x(value:int):void
		{
			_space_x = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_DATA);
		}


		/**
		 * 横对其方式 
		 */
		public function get hAlign():String
		{
			return _hAlign;
		}

		/**
		 * @private
		 */
		public function set hAlign(value:String):void
		{
			_hAlign = value;
			this.invalidate(INVALIDATION_FLAG_ADJUSTH);
		}


		/**
		 * 要显示的文字 
		 */
		public function get text():String
		{
			return _text;
		}

		/**
		 * @private
		 */
		public function set text(value:String):void
		{
			_text = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_DATA);
			
		}

		public function SAtlasLabel()
		{
			super();
			_init();
		}
		
		private function _init():void
		{
			_mapChar = new Dictionary();
			_charVec = new Vector.<Image>();
		}
		
		public function registerChar(charId:int,texture:Texture):void
		{
			_mapChar[charId] =  texture;
		}
		/**
		 * 注册一堆字符 
		 * @param charString 字符集
		 * @param charTexturePrefix 字符前缀 合成为charTexturePrefix+charString(i)
		 * @param Assets 资源管理器 如果为空 则为 SApplication.Asset
		 * 
		 */
		public function registerChars(charString:String,charTexturePrefix:String,Assets:AssetManager = null):void
		{
			
			Assets = Assets == null?SApplication.assets:Assets;
			var length:int;
			var charid:int;
			var i:int;
			var charAt:String;
			
			length = charString.length;
			for(i=0;i<charString.length;i++)
			{
				charid = charString.charCodeAt(i);
				charAt = charString.charAt(i);
				registerChar(charid,Assets.getTexture(charTexturePrefix + charAt));
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		override protected function initialize():void
		{
//			var helpQuad:Quad = new Quad(2,2,0xFF0000);
//			addChild(helpQuad);
			super.initialize();
		}
		
		
		override protected function draw():void
		{
			_renderText();
			super.draw();
		}
		
	
		
		
		private function _renderText():void
		{
			if(isInvalid(INVALIDATION_FLAG_TEXT_DATA))
			{
				//删除之前的图片
				var charimage:Image;
				var charTexture:Texture;
				var length:int;
				var i:int;
				var charid:int;
				var offsetx:int = 0;
				while(null != (charimage = _charVec.pop()))
				{
					charimage.removeFromParent();
				}
				
				length = _text.length;
				
				var mheight:int = 0;
				for(i=0;i<_text.length;i++)
				{
					charid = _text.charCodeAt(i);
					charTexture = _mapChar[charid];
					if(charTexture)
					{
						charimage = new Image(charTexture);
						addChild(charimage);
						charimage.x = offsetx;
						offsetx += (charimage.texture.width+ _space_x);
						if(charimage.height > mheight)
						{
							mheight = charimage.height;
						}
					}
				}
				offsetx -= _space_x;
				_adjustH(offsetx,mheight);
			}
			
			
			
		}
		
		private function _adjustH(realx:Number,realy:Number):void
		{
			switch(_hAlign)
			{
				case HAlign.LEFT:
				{
					pivotX = 0;
					break;
				}
				case HAlign.CENTER:
				{
					pivotX = realx/2 ;
					break;
				}
				case HAlign.RIGHT:
				{
					pivotX = realx;
					break;
				}
					
				default:
				{
					pivotX = 0;
					break;
				}
			}
			
			pivotY =  realy/2;
		}
		
		
	}
}