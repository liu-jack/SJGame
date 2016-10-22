package SJ.Game.friends
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import SJ.Common.Constants.ConstFilter;
	import SJ.Game.SocketServer.SocketCommand_friend;
	import SJ.Game.controls.CJFlyWordsUtil;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	import starling.textures.Texture;
	

	/**
	 * 好友管理单元
	 * @author zhengzheng
	 * 
	 */	
	public class CJFriendManageItem extends CJItemTurnPageBase
	{
		/**背景图*/
		private var _imgBg:Scale9Image;
		/**玩家对象*/
		private var _item:CJHeroHeadIconItem;
		/**玩家名称*/
		private var _labName:Label;
		/**玩家等级*/
		private var _labLevel:Label;
		/**玩家状态*/
		private var _labState:Label;
		/**删除按钮*/
		private var _btnDelete:Button;
		public function CJFriendManageItem()
		{
			super("CJFriendManageItem");
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
			
			_labLevel = new Label();
			_labLevel.x = 68;
			_labLevel.y = 22;
			_labLevel.textRendererProperties.textFormat = new TextFormat( "Arial", 10, 0xE4BC51);
			
			_labState = new Label();
			_labState.x = 68;
			_labState.y = 38;
			_labState.textRendererProperties.textFormat = new TextFormat( "Arial", 10, 0x60FEFE);
			
			_btnDelete = new Button();
			_btnDelete.x = 193;
			_btnDelete.y = 18;
			_btnDelete.width = 70;
			_btnDelete.height = 30;
			_btnDelete.defaultLabelProperties.textFormat = new TextFormat( "黑体", 12, 0xD3CA9E);
			_btnDelete.label = CJLang("FRIEND_DELETE");
			_btnDelete.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			_btnDelete.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			_btnDelete.addEventListener(Event.TRIGGERED , this._btnDeleteTriggered);
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
			addChild(_labLevel);
			addChild(_labState);
			addChild(_btnDelete);
		}
		override protected function draw():void
		{
			super.draw();
			const isSelectInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(isSelectInvalid && data)
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
		

		override public function dispose():void
		{
			CJFriendUtil.o.dipose();
			super.dispose();
		}
		/**
		 * 触发删除好友事件
		 * @param e Event
		 * 
		 */		
		private function _btnDeleteTriggered(e:Event):void
		{
			SSoundEffectUtil.playButtonNormalSound();
			CJConfirmMessageBox(CJLang("FRIEND_DELETE_FRIEND_OR_NOT"), _confirmDelFriend);
		}
		
		
		/**
		 * 确定删除好友
		 * @param e Event
		 * 
		 */		
		public function _confirmDelFriend():void
		{
			if (data && data.hasOwnProperty("frienduid"))
			{
				CJFriendUtil.o.delFriendRetTips();
				SocketCommand_friend.delFriend(data.frienduid);
			}
			else
			{
				CJFlyWordsUtil(CJLang("FRIEND_PLAYER_DATA_ERROR"));
			}
		}
	}
}