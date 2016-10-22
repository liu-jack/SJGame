package SJ.Game.friends
{
	import SJ.Common.Constants.ConstFilter;
	import SJ.Common.Constants.ConstFriend;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import starling.textures.Texture;
	

	/**
	 * 好友显示单元
	 * @author zhengzheng
	 * 
	 */	
	public class CJFriendPlayerItem extends CJItemTurnPageBase
	{
		/**背景图*/
		private var _imgBg:Scale9Image;
		/**玩家对象*/
		private var _item:CJHeroHeadIconItem;
		/**玩家名称*/
		private var _labName:Label;
		/**总战斗力*/
		private var _labBattlePower:Label;
		/**职业*/
		private var _imgJob:ImageLoader;
		/**阵营*/
		private var _imgCamp:ImageLoader;
		/**玩家vip等级*/
		private var _labVipLevel:Label;
		/**玩家军衔*/
		private var _labLevel:Label;
		/**玩家状态*/
		private var _labState:Label;
		/** 点击好友玩家单元弹出的菜单 */
		private var _menuClickItem:CJFriendPlayerItemClickMenu;
		public function CJFriendPlayerItem()
		{
			super("CJFriendPlayerItem");
		}
		override protected function initialize():void
		{
			super.initialize();
			_initData();
			_drawContent();
		}
		
		/**
		 * 初始化数据
		 */		
		private function _initData():void
		{
			this.width = 289;
			this.height = 59;
			
			var textureBg:Texture = SApplication.assets.getTexture("common_tankuangdi2");
			var bgScaleRange:Rectangle = new Rectangle(5, 5, 1, 1);
			_imgBg = new Scale9Image(new Scale9Textures(textureBg, bgScaleRange));
			_imgBg.width = this.width - 5;
			_imgBg.height = this.height;
			_imgBg.x = 3;
			_imgBg.y = 3;
			
			
			_item = new CJHeroHeadIconItem();
			_item.x = 7;
			_item.y = 7;
			
			_labName = new Label();
			_labName.x = 68;
			_labName.y = 7;
			_labName.textRendererProperties.textFormat = new TextFormat( "Arial", 10, 0xFAFEBF);
			
			_labBattlePower = new Label();
			_labBattlePower.x = 68
			_labBattlePower.y = 22;
			_labBattlePower.textRendererProperties.textFormat = new TextFormat( "Arial", 10, 0x66B252);;
			
			_imgJob = new ImageLoader();
			_imgJob.x = 68;
			_imgJob.y = 35;
			
			_imgCamp = new ImageLoader();
			_imgCamp.x = 96;
			_imgCamp.y = 37;
			_imgCamp.width = 20;
			_imgCamp.height = 20;
			
			_labVipLevel = new Label();
			_labVipLevel.x = 115;
			_labVipLevel.y = 38;
			_labVipLevel.textRendererProperties.textFormat = new TextFormat( "Arial", 10, 0xEDD672);
			
			_labLevel = new Label();
			_labLevel.x = 178;
			_labLevel.y = 7;
			_labLevel.textRendererProperties.textFormat = new TextFormat( "Arial", 10, 0xE4BC51);
			
			_labState = new Label();
			_labState.x = 178;
			_labState.y = 22;
			_labState.textRendererProperties.textFormat = new TextFormat( "Arial", 10, 0x60FEFE);
			
			
		}
		/**
		 * 画出单个条目
		 * 
		 */
		private function _drawContent():void
		{
			addChild(_imgBg);
			addChild(_item);
			addChild(_labName);
			addChild(_labBattlePower);
			addChild(_imgJob);
			addChild(_imgCamp);
			addChild(_labVipLevel);
			addChild(_labLevel);
			addChild(_labState);
		}
		override protected function draw():void
		{
			super.draw();
			const isSelectInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(isSelectInvalid)
			{
				var heroTmpl:CJDataHeroProperty = CJDataOfHeroPropertyList.o.getProperty(data.templateid);
				_item.setHeadImg(heroTmpl.headicon);
				if (data.online == 0)
				{
					_item.imageHead.filter = ConstFilter.genBlackFilter();
				}
				else 
				{
					if(_item.imageHead.filter != null)
					{
						_item.imageHead.filter.dispose();
					}
					_item.imageHead.filter = null;
				}
				var roleName:String = data.rolename;
				if (roleName.length > 8)
				{
					roleName = roleName.substring(0, 8) + "...";
				}
				_labName.text = CJLang("FRIEND_NAME") + "：" + roleName;
				_labBattlePower.text = CJLang("FRIEND_BATTLE_POWER").replace(" {battleeffect}",("：" + data.battleeffectsum));
				_imgJob.source = SApplication.assets.getTexture("haoyou_zhiye" + data.job);
				//有阵营
				if (data.camp != 0)
				{
					//吴国
					if (data.camp == 4)
					{
						_imgCamp.source = SApplication.assets.getTexture("common_zhenyingtubiao03");
					}
					else
					{
						_imgCamp.source = SApplication.assets.getTexture("common_zhenyingtubiao0" + data.camp)
					}
				}
				_labVipLevel.text = "VIP" + ": " + data.viplevel;
				_labLevel.text = CJLang("FRIEND_LEVEL") + "：" + data.level;
				if (data.online == 0)
				{
					var offlineTime:String = CJFriendUtil.o.changeSecondToDate(Number(data.lately_login))
					_labState.text = CJLang("FRIEND_STATE") + "：" + CJLang("FRIEND_OFFLINE") + offlineTime;
				}
				else 
				{
					_labState.text = CJLang("FRIEND_STATE") + "：" + CJLang("FRIEND_ONLINE");
				}
				
			}
		}
		
		/**
		 * 处理选中事件
		 * @param selectedIndex 单元的索引
		 * 
		 */
		override protected function onSelected():void
		{
			CJEventDispatcher.o.dispatchEventWith(("selectPlayerInfoEvent" + ConstFriend.FRIEND_SHOW_TYPE) ,false, {"selectPlayerInfo":data, "itemIsSelected":true});
		}
		override public function set isSelected(value:Boolean):void
		{
			var textureBg:Texture;
			var bgScaleRange:Rectangle;
			if (value)
			{
				//设置选中效果
				textureBg = SApplication.assets.getTexture("haoyou_xuanzhong");
				bgScaleRange = new Rectangle(10, 10, 2, 2);
				_imgBg.textures = new Scale9Textures(textureBg, bgScaleRange);
			}
			else
			{
				//设置未选中效果
				textureBg = SApplication.assets.getTexture("common_tankuangdi2");
				bgScaleRange = new Rectangle(5, 5, 1, 1);
				_imgBg.textures = new Scale9Textures(textureBg, bgScaleRange);
			}
		}

	}
}