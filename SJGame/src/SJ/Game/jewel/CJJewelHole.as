package SJ.Game.jewel
{
	
	import SJ.Common.Constants.ConstBag;
	import SJ.Common.Constants.ConstJewel;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.AssetManagerUtil;
	
	import feathers.controls.Label;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;

	/**
	 * @author sangxu
	 * 2013-05-30
	 * 宝石镶嵌，装备孔
	 */
	public class CJJewelHole extends SLayer
	{
		/** controls */
		/** 物品框图片 */
		private var _imageFrame:SImage;
		/** 物品图片 */
		private var _imageGoods:SImage;
		/** 宝石名 */
		private var _labName:Label;
		
		
		/** 道具id */
		private var _itemid:String = "";
		
		private var _status:uint;
		
		/** 道具图片相对背景框图片偏移量 */
		private var _spaceXGood:int = 7;
		private var _spaceYGood:int = 8;
		/** 框图片宽高 */
		private var _frameImgWidth:int = ConstJewel.JEWEL_INLAY_HOLE_WIDTH;
		private var _frameImgHeight:int = ConstJewel.JEWEL_INLAY_HOLE_HEIGHT;
		/** 道具图片宽高 */
		private var _goodImgWidth:int = 44;
		private var _goodImgHeight:int = 44;
		
//		/** 索引 */
//		private var _index:int = 0;
		/** 是否可选中 */
		private var _canSelect:Boolean = false;
		
		private var _index:int;
		
		/** 动画 - 宝石特效 */
		private var _animBaoshi:SAnimate;
		/** 动画 - 开孔 */
		private var _animOpen:SAnimate;
		
		public function CJJewelHole(holeIndex:int)
		{
			super();
			var textureUnlock:Texture = SApplication.assets.getTexture("common_baoshidi");
			
			_init(ConstBag.FrameCreateStateLocked);
			this._index = holeIndex;
		}
		
		/**
		 * _status为ConstBag.FrameCreateStateUnlock时，创建解锁物品框，否则创建加锁物品框
		 */
		public function get status():uint
		{
			return _status;
		}
		
		public function set status(value:uint):void
		{
			_status = value;
		}
		/**
		 * 物品图片
		 * 
		 */		
		public function get imageGoods():SImage
		{
			return _imageGoods;
		}
		
		public function set imageGoods(value:SImage):void
		{
			_imageGoods = value;
		}
		
		/**
		 * 道具id
		 * @return 
		 * 
		 */		
		public function get itemId():String
		{
			return _itemid;
		}
		
		public function set itemId(value:String):void
		{
			_itemid = value;
		}
//		/**
//		 * 索引
//		 * @return 
//		 * 
//		 */		
//		public function get index():int
//		{
//			return _index;
//		}
//		public function set index(value:int):void
//		{
//			_index = value;
//		}
		
		public function set canSelect(value:Boolean):void
		{
			this._canSelect = value;
		}
		
		public function get canSelect():Boolean
		{
			return this._canSelect;
		}
		
		/**
		 * 获取孔索引
		 * @return 
		 * 
		 */		
		public function get index():int
		{
			return this._index;
		}
		
		
		/**
		 * 清除道具id
		 * 
		 */		
		public function clearItemId():void
		{
			_itemid = "";
		}

		private function _init(status:uint):void
		{
			switch(status)
			{
				case ConstBag.FrameCreateStateUnlock:
					this._imageFrame = new SImage(SApplication.assets.getTexture("common_baoshidi"));
					break;
				case ConstBag.FrameCreateStateLocked:
					this._imageFrame = new SImage(SApplication.assets.getTexture("common_baoshidijiasuo"));
					break;
				default:
					this._imageFrame = new SImage(SApplication.assets.getTexture("common_baoshidi"));
			}
			_status = status;
			this._imageFrame.width = _frameImgWidth;
			this._imageFrame.height = _frameImgHeight;
			addChildAt(_imageFrame, 0);
			
			var tfName:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 7, 0xffffff, null, null, null, null, null, TextFormatAlign.CENTER);
			
			_labName = new Label();
			_labName.textRendererProperties.textFormat = tfName;
			_labName.text = "";
			_labName.height = 9;
			_labName.width = _frameImgWidth;
			_labName.x = -2;
			_labName.y = 42;
			_labName.visible = false;
			this.addChild(_labName);
		}
		
		/**
		 * 改变装备孔的锁定或者解锁状态 
		 * 
		 */		
		public function updateFrame():void
		{
			switch(_status)
			{
				case ConstBag.FrameCreateStateUnlock:
					this._imageFrame.texture = SApplication.assets.getTexture("common_baoshidi");
					break;
				case ConstBag.FrameCreateStateLocked:
					this._imageFrame.texture = SApplication.assets.getTexture("common_baoshidijiasuo");
					this.setHoleGoodsItem("");
					this.clearItemName();
					this.removeAnimBaoshi();
					break;
				default:
					this._imageFrame.texture = SApplication.assets.getTexture("common_baoshidi");
			}
		}
		
		/**
		 * 为装备孔设置物品 
		 * 
		 */		
		public function setHoleGoodsItem(imgName : String):void
		{
			if (this._imageGoods == null)
			{
				if (imgName != "")
				{
					this._imageGoods = new SImage(SApplication.assets.getTexture(imgName));
					this._imageGoods.x = this._imageFrame.x + this._spaceXGood;
					this._imageGoods.y = this._imageFrame.y + this._spaceYGood;
					this._imageGoods.width = this._goodImgWidth;
					this._imageGoods.height = this._goodImgHeight;
					this.addChildAt(this._imageGoods, 1);
					this._setAnimBaoshi();
				}
			}
			else
			{
				if (imgName != "")
				{
					this._imageGoods.texture = SApplication.assets.getTexture(imgName);
					this._setAnimBaoshi();
				}
				else
				{
					this.removeChild(this._imageGoods);
					this._imageGoods = null;
					this.removeAnimBaoshi();
				}
			}
		}
		
		/**
		 * 添加宝石特效
		 * 
		 */		
		private function _setAnimBaoshi():void
		{
			if (this._animBaoshi != null)
			{
				return;
			}
				
			var animObject:Object = AssetManagerUtil.o.getObject("anim_baoshixiangqian");
			this._animBaoshi = SAnimate.SAnimateFromAnimJsonObject(animObject);
//			this._animBaoshi.addEventListener(Event.COMPLETE, _onAimComplete);
			this._animBaoshi.x = 0;
			this._animBaoshi.y = 0;
			this.addChildAt(this._animBaoshi, this.getChildIndex(this._imageGoods));
			Starling.juggler.add(_animBaoshi);
			this._animBaoshi.gotoAndPlay();
			this._animBaoshi.currentFrame = int(Math.random() * 6);
		}
		
		/**
		 * 开孔
		 * 
		 */
		public function openHole():void
		{
			status = ConstBag.FrameCreateStateUnlock;
			setHoleGoodsItem("");
			itemId = "";
			updateFrame();
			_playAnimOpen();
		}
		
		/**
		 * 播放开孔动画
		 * 
		 */
		private function _playAnimOpen():void
		{
			var animObject:Object = AssetManagerUtil.o.getObject("anim_xiangqiankaikong");
			_animOpen = SAnimate.SAnimateFromAnimJsonObject(animObject);
			_animOpen.x = 0;
			_animOpen.y = 0;
			_animOpen.width = this.width;
			_animOpen.height = this.height;
			_animOpen.addEventListener(Event.COMPLETE, _animOpenComplete);
			
			addChild(this._animOpen);
			Starling.juggler.add(_animOpen);
			
			this._animOpen.gotoAndPlay();
		}
		
		/**
		 * 开孔动画播放结束
		 * @param e
		 * 
		 */		
		private function _animOpenComplete(e:Event):void
		{
			if(e.target is SAnimate)
			{
				_animOpen.removeEventListener(Event.COMPLETE,_animOpenComplete);
				_animOpen.removeFromParent();
				_animOpen.removeFromJuggler();
				_animOpen = null;
			}
		}
		
		/**
		 * 移除宝石特效
		 * 
		 */		
		private function removeAnimBaoshi():void
		{
			if (this._animBaoshi != null)
			{
				this._animBaoshi.removeFromParent(true);
				this._animBaoshi.removeFromJuggler();
				this._animBaoshi = null;
			}
		}
		
		/**
		 * 根据道具模板id设置图片
		 * 调用此方法前需加载道具模板资源：ConstResource.sResItemSetting
		 * @param itemTmplId
		 * 
		 */		
		public function setHoleGoodsByTmplId(itemTmplId:int):void
		{
			var tmplData:Json_item_setting = CJDataOfItemProperty.o.getTemplate(itemTmplId);
			
			Assert(tmplData != null, "Item template is null, id is:" + itemTmplId);
			// 设置道具图片
			this.setHoleGoodsItem(tmplData.picture);
			// 设置道具名
			this.setItemName(CJLang(tmplData.itemname));
		}
		
		/**
		 * 设置道具名
		 * @param itemName
		 * 
		 */		
		public function setItemName(itemName:String):void
		{
			if (itemName != null)
			{
				this._labName.text = itemName;
				this._labName.visible = true;
			}
			else
			{
				this._labName.text = "";
				this._labName.visible = false;
			}
		}
		
		/**
		 * 清除道具名
		 * 
		 */		
		public function clearItemName():void
		{
			if (this._labName != null)
			{
				this._labName.text = "";
				this._labName.visible = false;
			}
		}
	}
}