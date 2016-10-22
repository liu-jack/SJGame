package SJ.Game.kfcontend
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfHeroList;
	import SJ.Game.data.CJDataOfKFContend;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.lang.CJLang;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * 开服争霸
	 * @author bianbo
	 * 
	 */	
	public class CJKFContendLayer extends SLayer
	{
		
		private var closeButton:Button;
		
		private var subPanel:CJSubKFLayer;
		
		private const TabPostionX:Array = [12, 117, 222, 327];
		private const TabPostionY:int = 19;
		
		//tab类型1-4
		private var tabType:int = -1;
		
		//tab按钮
		private var rank:Button;
		private var match:Button;
		private var king:Button;
		private var god:Button;
		internal static var openservertime:int;//记录开服时间
		
		internal static var isUserVisible:Boolean=false;//是否显示玩家列
		
		
		public function CJKFContendLayer()
		{
			super();
			this.setSize(480, 320);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			//  0显示  1不显示
			var v:int = int(CJDataOfGlobalConfigProperty.o.getData("KFCONTEND_USERDATA_OPEN"));
			isUserVisible = (v == 0);
			//背景图
			var imgHeadBg:ImageLoader = new ImageLoader();
			imgHeadBg.source = SApplication.assets.getTexture("shouchong_bitu");
			imgHeadBg.x = 0;
			imgHeadBg.y = 5;
			imgHeadBg.scaleX = imgHeadBg.scaleY = 4;
			this.addChild(imgHeadBg);
			
			// 背景框
			var textureBg:Texture = SApplication.assets.getTexture("kfcontend_kuang");
			var bgTexture:Scale9Textures = new Scale9Textures(textureBg, new Rectangle(80 , 20 , 2, 2));
			var bgImage:Scale9Image = new Scale9Image(bgTexture);
			bgImage.width = SApplicationConfig.o.stageWidth;
			bgImage.height = SApplicationConfig.o.stageHeight;
			this.addChild(bgImage);
			
			// 纹理边框
			var textureBiankuang:Texture = SApplication.assets.getTexture("common_waikuangnew");
			var bgScaleRangeBk:Rectangle = new Rectangle(15 , 15 , 1, 1);
			var bgTextureBk:Scale9Textures = new Scale9Textures(textureBiankuang, bgScaleRangeBk);
			var imgBiankuang:Scale9Image = new Scale9Image(bgTextureBk);
			imgBiankuang.x = 13;
			imgBiankuang.y = 42;
			imgBiankuang.width = width-37;
			imgBiankuang.height = height-61;
			this.addChild(imgBiankuang);
			
//			// red背景
//			var redtextureBg:Texture = SApplication.assets.getTexture("kfcontend_jianglikuang");
//			var bgScaleRange:Rectangle = new Rectangle(25, 10, 10, 10);
//			var redbgTexture:Scale9Textures = new Scale9Textures(redtextureBg, bgScaleRange);
//			var redbgImage:Scale9Image = new Scale9Image(redbgTexture);
//			redbgImage.width = width;
//			redbgImage.height = height;
//			this.addChild(redbgImage);
			
			//关闭按钮
			closeButton = new Button();
			closeButton.defaultSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			closeButton.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
			closeButton.addEventListener(Event.TRIGGERED , _closeHandle);
			closeButton.x = 433;
			closeButton.y = 24;
			this.addChild(closeButton);
			
			//获得服务器时间
			SocketManager.o.callwithRtn(ConstNetCommand.CS_KFCONTEND_ServerTime, _getServerTime);
		}
		
		private function _getServerTime(message:SocketMessage):void
		{
			var textureBg1:Texture = SApplication.assets.getTexture("chongzhi_anniu01");
			var bgTexture1:Scale3Textures = new Scale3Textures(textureBg1, 15, 1, Scale3Textures.DIRECTION_HORIZONTAL);
			
			var textureBg2:Texture = SApplication.assets.getTexture("chongzhi_anniu02");
			var bgTexture2:Scale3Textures = new Scale3Textures(textureBg2, 15, 1, Scale3Textures.DIRECTION_HORIZONTAL);
			
			//白色
			var fontBtnSty1:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 12, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER);
			//蓝色
			var fontBtnSty2:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 11, 0x00FFFF, null, null, null, null, null, TextFormatAlign.CENTER);
			
//			beibaoBtns[i].defaultLabelProperties.textFormat = fontBtnUnsel;
//			beibaoBtns[i].selectedDownLabelProperties.textFormat = fontBtnSel;
//			beibaoBtns[i].selectedHoverLabelProperties.textFormat = fontBtnSel;
//			beibaoBtns[i].selectedUpLabelProperties.textFormat = fontBtnSel;
			

			//tab按钮
			//土豪排行
			rank = new Button();
			rank.defaultSelectedSkin = new Scale3Image(bgTexture1);
			rank.defaultSkin = new Scale3Image(bgTexture2);
			rank.addEventListener(Event.TRIGGERED , _tabPanelClick);
			rank.width = 100;
			rank.name = "1";
			rank.x = TabPostionX[0];
			rank.y = TabPostionY;
			rank.label = CJLang("kf_tabtitle1");
			this.addChild(rank);
			
			//冲级大赛
			match = new Button();
			match.defaultSelectedSkin = new Scale3Image(bgTexture1);
			match.defaultSkin = new Scale3Image(bgTexture2);
			match.addEventListener(Event.TRIGGERED , _tabPanelClick);
			match.width = 100;
			match.name = "2";
			match.x = TabPostionX[1];
			match.y = TabPostionY;
			match.label = CJLang("kf_tabtitle2");
			this.addChild(match);
			
			//格斗之王
			king = new Button();
			king.defaultSelectedSkin = new Scale3Image(bgTexture1);
			king.defaultSkin = new Scale3Image(bgTexture2);
			king.addEventListener(Event.TRIGGERED , _tabPanelClick);
			king.width = 100;
			king.name = "3";
			king.x = TabPostionX[2];
			king.y = TabPostionY;
			king.label = CJLang("kf_tabtitle3");
			this.addChild(king);
			
			//战争之神
			god = new Button();
			god.defaultSelectedSkin = new Scale3Image(bgTexture1);
			god.defaultSkin = new Scale3Image(bgTexture2);
			god.addEventListener(Event.TRIGGERED , _tabPanelClick);
			god.width = 100;
			god.name = "4";
			god.x = TabPostionX[3];
			god.y = TabPostionY;
			god.label = CJLang("kf_tabtitle4");
			this.addChild(god);
			
			var retCode:uint = message.params(0);
			var data:Array = message.params(1);
			
			var sec:int = int(data[0]) + 8*60*60;//后台传的是少了8时区的标准时间，加上转为本地时间
			var day:int = int(sec/(24*60*60));
			openservertime = day*24*60*60;//整天的秒数
			var servertime:int = int(data[1]);
			var arr:Array = CJDataOfKFContend.o.getState(servertime, openservertime);
			
			for(var i:int=0; i<arr.length; i++)
			{
				var bt:Button;
				var _obj:Object = arr[i];
				if(_obj.type==1)bt = rank;
				else if(_obj.type==2)bt = match;
				else if(_obj.type==3)bt = king;
				else if(_obj.type==4)bt = god;
				
				//1未开启 2已结束 3正在开启
				if(_obj.state==1){
					bt.defaultLabelProperties.textFormat = fontBtnSty2;
					bt.label += CJLang("kf_notopen");
				}
				else if(_obj.state==2){
					bt.defaultLabelProperties.textFormat = fontBtnSty2;
					bt.label += CJLang("kf_timeover");
				}else{
					bt.defaultLabelProperties.textFormat = fontBtnSty1;
				}
			}
			
			tanChange(1);
			rank.isSelected = true;
			match.isSelected = false;
			king.isSelected = false;
			god.isSelected = false;
		}
		
		//子面板切换
		private function _tabPanelClick(e:Event):void
		{
			var t_type:int = int(e.target["name"]);
			
			rank.isSelected = false;
			match.isSelected = false;
			king.isSelected = false;
			god.isSelected = false;
			// 选中
			(e.target as Button).isSelected = true;
			
			tanChange(t_type);
		}
		
		private function tanChange(_tabType:int):void
		{
			if(tabType == _tabType)return;
			
			tabType = _tabType;
			
			if(subPanel == null)
			{
				subPanel = new CJSubKFLayer();
				addChild(subPanel);
			}
			subPanel.flushView(tabType);
			
			//查看排行版， 考虑排行和竞技场的开启等级
			var moduleType:int;
			if(tabType==3)moduleType = 12;
			else moduleType = 11;
			
			var openLv:int = CJDataOfKFContend.o.getModuleOpenLv(moduleType);
			var heroInfo:CJDataOfHeroList = CJDataManager.o.getData("CJDataOfHeroList");
			var mainHero:CJDataOfHero = heroInfo.getMainHero();
			subPanel.lookRankBtVisible = (int(mainHero.level) >= openLv);
		}
		
		private function _closeHandle(e:Event):void
		{
			SSoundEffectUtil.playButtonNormalSound();
			SApplication.moduleManager.exitModule("CJKFContendModule");
		}
		
		private function removeAllListener():void
		{
			if(closeButton!=null && closeButton.hasEventListener(Event.TRIGGERED))
			closeButton.removeEventListener(Event.TRIGGERED , _closeHandle);
			
			if(rank!=null && rank.hasEventListener(Event.TRIGGERED))
			rank.addEventListener(Event.TRIGGERED , _tabPanelClick);
			
			if(match!=null && match.hasEventListener(Event.TRIGGERED))
			match.addEventListener(Event.TRIGGERED , _tabPanelClick);
			
			if(king!=null && king.hasEventListener(Event.TRIGGERED))
			king.addEventListener(Event.TRIGGERED , _tabPanelClick);
			
			if(god!=null && god.hasEventListener(Event.TRIGGERED))
			god.addEventListener(Event.TRIGGERED , _tabPanelClick);
		}
		
		override public function dispose():void
		{
			removeAllListener();
			
			if(subPanel != null ){
				this.contains(subPanel) && removeChild(subPanel);
				subPanel.dispose();
			}
			
			closeButton = null;
			super.dispose();
		}
		
	}
}