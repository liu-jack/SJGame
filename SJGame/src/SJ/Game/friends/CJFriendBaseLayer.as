package SJ.Game.friends
{
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * 好友基本层
	 * @author zhengzheng
	 * 
	 */	
	public class CJFriendBaseLayer extends SLayer
	{
		
		/**左按钮*/
		protected var btnLeft:Button;
		/**右按钮*/
		protected var btnRight:Button;
		/** 页码显示 */
		/**当前页数*/
		protected var labelPageShow:Label;
		protected var currentPage:int = 1;
		/**总页数*/
		protected var pageNum:int = 1;
		/**选中按钮*/
		protected var btnSelect:Button;
		/**选中按钮点击区域*/
		protected var btnSelectRegion:Button;
		/** 在线显示 */
		protected var labelOnlineShow:Label;
		/**添加按钮*/
		protected var btnAdd:Button;
		
		public function CJFriendBaseLayer()
		{
			super();
		}
		override protected function initialize():void
		{
			super.initialize();
			_initData();
			_drawContent();
			_addListener();
		}
		
		/**
		 * 初始化基本数据
		 */		
		private function _initData():void
		{
			
		}
		/**
		 * 绘制界面内容
		 */	
		private function _drawContent():void
		{
			
			//左按钮
			this.btnLeft = new Button();
			this.btnLeft.name = "pre";
			this.btnLeft.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeright01"));
			this.btnLeft.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeright03"));
			this.btnLeft.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeright02"));
			this.btnLeft.scaleX = -1;
			this.btnLeft.width = 22;
			this.btnLeft.height = 32;
			this.btnLeft.x = 133 + this.btnLeft.width;
			this.btnLeft.y = 216;
//			this.addChild(btnLeft);
			//右按钮
			this.btnRight = new Button();
			this.btnRight.name = "next";
			this.btnRight.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeright01"));
			this.btnRight.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeright03"));
			this.btnRight.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeright02"));
			this.btnRight.width = 22;
			this.btnRight.height = 32;
			this.btnRight.x = 212;
			this.btnRight.y = 216;
//			this.addChild(btnRight);
			
			//页数显示背景图
			var imgPageBg:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_fanyeyemawenzidi", 5, 5,1,1);
			imgPageBg.x = 124;
			imgPageBg.y = 222;
			imgPageBg.width = 75;
			imgPageBg.height = 21;
//			this.addChild(imgPageBg);
			
			//页码显示
			labelPageShow = new Label();
			labelPageShow.x = 124;
			labelPageShow.y = 225;
			labelPageShow.width = 75;
//			this.addChild(labelPageShow);
			//选中按钮
			this.btnSelect = new Button();
			this.btnSelect.defaultSkin = new SImage(SApplication.assets.getTexture("haoyou_fuxuankuang"));
			this.btnSelect.defaultSelectedSkin = new SImage(SApplication.assets.getTexture("haoyou_fuxuankuang03"));
			this.btnSelect.width = 14;
			this.btnSelect.height = 14;
			this.btnSelect.x = 14;
			this.btnSelect.y = 247;
			this.addChild(btnSelect);
			
			//在线显示
			labelOnlineShow = new Label();
			labelOnlineShow.x = 29;
			labelOnlineShow.y = 246;
			labelOnlineShow.width = 80;
			labelOnlineShow.text = CJLang("FRIEND_SHOW_ONLINE_FRIENDS");
			this.addChild(labelOnlineShow);
			
			//选中按钮点击区域
			this.btnSelectRegion = new Button();
			this.btnSelectRegion.defaultSkin = new SImage(Texture.fromColor(100,20,0x01FFFFFF,false,SApplication.assets.scaleFactor),true);
			this.btnSelectRegion.x = 12;
			this.btnSelectRegion.y = 247;
			this.addChild(btnSelectRegion);
			
			//添加按钮
			this.btnAdd = new Button();
			this.btnAdd.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			this.btnAdd.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			this.btnAdd.width = 55;
			this.btnAdd.height = 28;
			this.btnAdd.x = 252;
			this.btnAdd.y = 237;
			btnAdd.label = CJLang("FRIEND_ADD");
			this.addChild(btnAdd);
			_setTextFormat();
		}
		
		/**
		 * 设置控件的字体 
		 */		
		private function _setTextFormat():void
		{
			var fontFormat:TextFormat;
			labelPageShow.textRendererProperties.textFormat = ConstTextFormat.textformatwhitecenter;
			labelOnlineShow.textRendererProperties.textFormat = ConstTextFormat.textformatwhitecenter;
			
			fontFormat = new TextFormat( "黑体", 12, 0xD3CA9E,null,null,null,null,null,TextFormatAlign.CENTER);
			btnAdd.defaultLabelProperties.textFormat = fontFormat;
		}
		/**
		 * 为控件添加监听 
		 * 
		 */	
		private function _addListener():void
		{
			//添加按钮
			this.btnAdd.addEventListener(Event.TRIGGERED , this._addFriendDialog);
		}
		/**
		 * 触发添加好友
		 */		
		private function _addFriendDialog(e:Event):void
		{
			SSoundEffectUtil.playTipSound();
			var addFriendDialog:CJFriendAddFriendDialog = new CJFriendAddFriendDialog;
			addFriendDialog.x = (Starling.current.stage.stageWidth - addFriendDialog.width)>>1;
			addFriendDialog.y = (Starling.current.stage.stageHeight - addFriendDialog.height)>>1;
			CJLayerManager.o.addModuleLayer(addFriendDialog);
		}
	}
}