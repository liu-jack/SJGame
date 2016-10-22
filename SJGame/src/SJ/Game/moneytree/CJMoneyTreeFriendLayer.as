package SJ.Game.moneytree
{
	
	import SJ.Common.Constants.ConstCamp;
	import SJ.Game.data.CJDataOfMoneyTreeSingleFriend;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	CJDataOfMoneyTreeSingleFriend
	import feathers.controls.Label;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import starling.textures.Texture;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.Constants.ConstNPCDialog;
	import feathers.display.Scale9Image;

	/**
	 * @author sangxu
	 * 创建时间：2013-06-20
	 * 摇钱树单个好友信息层
	 */
	public class CJMoneyTreeFriendLayer extends SLayer
	{
		/** data */
		/** 索引 */
		private var _index:int = 0;
		/** 单个好友数据 */
		private var _dataFriend:CJDataOfMoneyTreeSingleFriend;
		
		/** controls */
		/** 图片 - 选中背景 */
		private var _imgBg:Scale9Image;
		/** 文字 - 名 */
		private var _labName:Label;
		/** 图片 - 阵营 */
		private var _imgZhenying:SImage;
		/** 文字 - 等级 */
		private var _labLevel:Label;
		/** 图片 - 施肥 */
		private var _imgShifei:SImage;
		/** 文字 - 施过肥 */
		private var _labShifei:Label;
		
		public function CJMoneyTreeFriendLayer()
		{
			super();
//			this._dataFriend = data;
			
			_init();
		}
		
		private function _init():void
		{
			this.width = 206;
			this.height = 20;
			// 选中背景
			this._imgBg = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_liebiaoxuanzhong",4,4 ,1 , 1);
			this._imgBg.width = this.width;
			this._imgBg.height = this.height;
			this._imgBg.visible = false;
			this.addChild(this._imgBg);
			
			// 名
			var fontFormatName:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xFDFF65, null, null, null, null, null, TextFormatAlign.CENTER);
			this._labName = new Label();
			this._labName.x = 1;
			this._labName.y = 3;
			this._labName.width = 63;
			this._labName.height = 15;
			this._labName.textRendererProperties.textFormat = fontFormatName;
//			this._labName.text = this._dataFriend.name;
			this.addChild(this._labName);
			
			// 阵营
			var texture:Texture = this._getTextureZhenying();
			
			if (null != texture)
			{
				this._imgZhenying = new SImage(texture);
				this._imgZhenying.x = 72;
				this._imgZhenying.y = 2;
				this._imgZhenying.width = 18;
				this._imgZhenying.height = 18;
				this.addChild(this._imgZhenying);
			}
			
			// 等级
			var fontFormatLv:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0x73FF42, null, null, null, null, null, TextFormatAlign.CENTER);
			this._labLevel = new Label();
			this._labLevel.x = 115;
			this._labLevel.y = 4;
			this._labLevel.width = 35;
			this._labLevel.height = 13;
//			this._labLevel.text = String(this._dataFriend.treelevel);
			this._labLevel.textRendererProperties.textFormat = fontFormatLv;
			this.addChild(this._labLevel);
			
			// 状态
			this._imgShifei = new SImage(SApplication.assets.getTexture("yaoqianshu_anniushifei01"));
			this._imgShifei.x = 171;
			this._imgShifei.y = 0;
			this._imgShifei.width = 19;
			this._imgShifei.height = 19;
			this.addChild(this._imgShifei);
			
			this._labShifei = new Label();
			this._labShifei.x = 171;
			this._labShifei.y = 3;
			this._labShifei.width = 16;
			this._labShifei.height = 17;
			this._labShifei.text = "--";
			this._labShifei.textRendererProperties.textFormat = fontFormatName;
			this.addChild(this._labShifei);
			
			this._imgShifei.visible = false;
			this._labShifei.visible = false;
			
			// 设置是否可施肥
//			this._setCanFeed();
		}
		
		/**
		 * 获取阵营纹理
		 * @return 
		 * 
		 */		
		private function _getTextureZhenying():Texture
		{
			if (this._dataFriend == null)
			{
				return null;
			}
			var texture:Texture;
			switch(this._dataFriend.camp)
			{
				case ConstCamp.CONST_CAMP_WEI:
					texture = SApplication.assets.getTexture("zhenying_tubiao01");
					break;
				case ConstCamp.CONST_CAMP_SHU:
					texture = SApplication.assets.getTexture("zhenying_tubiao02");
					break;
				case ConstCamp.CONST_CAMP_WU:
					texture = SApplication.assets.getTexture("zhenying_tubiao03");
					break;
			}
			return texture;
		}
		
		/**
		 * 设置是否可施肥
		 * 
		 */		
		public function setCanFeed(canFeed:Boolean):void
		{
			if (this._dataFriend == null)
			{
				return;
			}
			this._dataFriend.canfeed = canFeed;
			if (this._dataFriend.canfeed)
			{
				this._imgShifei.visible = true;
				this._labShifei.visible = false;
			}
			else
			{
				this._imgShifei.visible = false;
				this._labShifei.visible = true;
			}
		}
		
		/**
		 * 索引
		 * @return 
		 * 
		 */		
		public function get index():int
		{
			return _index;
		}
		
		public function set index(value:int):void
		{
			_index = value;
		}
		/**
		 * 索引
		 * @return 
		 * 
		 */		
		public function get friendData():CJDataOfMoneyTreeSingleFriend
		{
			return this._dataFriend;
		}
		
		/**
		 * 清除数据
		 * 
		 */		
		public function clearData():void
		{
			
		}

		
		
		/**
		 * 根据数据更新界面
		 * 
		 */		
		public function updateFrameWithData(data:CJDataOfMoneyTreeSingleFriend):void
		{
			this._dataFriend = data;
			this._updateFrame();
		}
		
		/**
		 * 更新界面
		 * 
		 */		
		private function _updateFrame():void
		{
			if (this._dataFriend == null)
			{
				// 设置所有控件不可见
				this._setVisible(false);
			}
			else
			{
				// 设置所有控件可见
				this._setVisible(true);
				
				// 名
				this._labName.text = this._dataFriend.name;
				
				// 阵营
				var texture:Texture = this._getTextureZhenying();
				if (null != texture)
				{
					if (this._imgZhenying == null)
					{
						this._imgZhenying = new SImage(texture);
						this._imgZhenying.x = 72;
						this._imgZhenying.y = 2;
						this._imgZhenying.width = 17;
						this._imgZhenying.height = 17;
						this.addChild(this._imgZhenying);
					}
					else
					{
						this._imgZhenying.texture = texture;
					}
				}
				
				// 等级
				this._labLevel.text = String(this._dataFriend.treelevel);
				
				// 施肥
				this.setCanFeed(this._dataFriend.canfeed);
			}
		}
		
		/**
		 * 是否有数据
		 * @return 
		 * 
		 */		
		public function hasData():Boolean
		{
			if (this._dataFriend == null)
			{
				return false;
			}
			return true;
		}
		
		/**
		 * 设置选中
		 * @param select
		 * 
		 */		
		public function set select(select:Boolean):void
		{
			if (this._dataFriend == null)
			{
				// 当前数据为空，不可选中
				return;
			}
			this._imgBg.visible = select;
			
//			this.parent.selectFriend(this._index, this._dataFriend);
		}
		
		/**
		 * 获取是否选中
		 * @return 
		 * 
		 */		
		public function get select():Boolean
		{
			return this._imgBg.visible;
		}
		
		/**
		 * 设置全部控件是否可见
		 * @param visible
		 * 
		 */		
		private function _setVisible(visible:Boolean):void
		{
			this._imgBg.visible = false;
			this._labName.visible = visible;
			if (this._imgZhenying != null)
			{
				this._imgZhenying.visible = visible;
			}
			this._labLevel.visible = visible;
			this._imgShifei.visible = visible;
			this._labShifei.visible = visible;
		}
		
	}
}