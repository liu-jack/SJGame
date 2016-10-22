package SJ.Game.kfcontend
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.CJDataOfKFContend;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.json.Json_kfcontend_active_setting;
	import SJ.Game.data.json.Json_kfcontend_setting;
	import SJ.Game.lang.CJLang;
	import SJ.Game.utils.SDateUtil;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	import starling.textures.Texture;

	public class CJSubKFLayer extends SLayer
	{
		private var type:int;//1土豪排行 2冲级大赛 3格斗之神 4战争之王
		
		private var titleTF:Label; 
		private var timeTF:Label;
		private var infoTF:Label;
		private var lookRankBt:Button;
		
		private var vecTFList1:Vector.<Label>;//排行index
		private var vecTFList2:Vector.<Label>;//奖励说明
		private var vecTFList3:Vector.<Label>;//玩家名字
		
		//土豪数据(土豪排行榜)
		private var _rankRichData:Array;
		//冲级大赛数据(等级排行榜)
		private var _rankLevelData:Array;
		//格斗之王数据(竞技场)
		private var _rankFightData:Array;
		//战争之神数据(战力排行榜)
		private var _rankBattleData:Array;
		
		private const RankPos:Point = new Point(50, 110);//排行面板统一位置
		
		public function CJSubKFLayer()
		{
			super();
			this.setSize(480, 320);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			//红色底条
			var imgHeadBg:ImageLoader = new ImageLoader();
			imgHeadBg.source = SApplication.assets.getTexture("npcduihua_duihuatiao");
			imgHeadBg.x = 20;
			imgHeadBg.y = 40;
			imgHeadBg.scaleX = 0.9
			imgHeadBg.scaleY = 0.8;
			this.addChild(imgHeadBg);
			
			//红色背景
			var textureBg:Texture = SApplication.assets.getTexture("shouchong_jianglikuang");
			var bgScaleRange:Rectangle = new Rectangle(10, 10, 1, 1);
			var bgTexture:Scale9Textures = new Scale9Textures(textureBg, bgScaleRange);
			var bgImage:Scale9Image = new Scale9Image(bgTexture);
			bgImage.width = CJKFContendLayer.isUserVisible ? 370 : 260;//是否显示玩家
			bgImage.height = 176;
			bgImage.x = RankPos.x - 8;
			bgImage.y = RankPos.y - 18;
			addChild(bgImage);
			
			//title tip
			titleTF = new Label();
			titleTF.x = 30;
			titleTF.y = 48;
			titleTF.textRendererProperties.textFormat = new TextFormat( "黑体", 12, 0xFFFF00,null,null,null,null,null,TextFormatAlign.LEFT);
			this.addChild(titleTF);
			
			//活动时间
			timeTF = new Label();
			timeTF.x = 30;
			timeTF.y = 63;
			timeTF.textRendererProperties.textFormat = new TextFormat( "黑体", 12, 0x00FF00,null,null,null,null,null,TextFormatAlign.LEFT);
			this.addChild(timeTF);
			
			//活动说明
			infoTF = new Label();
			infoTF.x = 30;
			infoTF.y = 78;
			infoTF.textRendererProperties.textFormat = new TextFormat( "黑体", 10, 0xFF9900,null,null,null,null,null,TextFormatAlign.LEFT);
			this.addChild(infoTF);
			
			//排名
			var rankTF:Label = new Label();
			rankTF.text = CJLang("kaifu_ranktf");
			rankTF.x = RankPos.x;
			rankTF.y = RankPos.y - 17;
			rankTF.textRendererProperties.textFormat = new TextFormat( "黑体", 12, 0xFF0000,null,null,null,null,null,TextFormatAlign.LEFT);
			this.addChild(rankTF);
			
			//奖品
			var awardTF:Label = new Label();
			awardTF.text = CJLang("kaifu_awardtf");
			awardTF.x = RankPos.x + 125;
			awardTF.y = RankPos.y - 17;
			awardTF.textRendererProperties.textFormat = new TextFormat( "黑体", 12, 0xFF0000,null,null,null,null,null,TextFormatAlign.LEFT);
			this.addChild(awardTF);
			
			//玩家
			var userTF:Label = new Label();
			userTF.text = CJLang("kaifu_usertf");
			userTF.x = RankPos.x + 260;
			userTF.y = RankPos.y - 17;
			userTF.width = 100;
			userTF.textRendererProperties.textFormat = new TextFormat( "黑体", 12, 0xFF0000,null,null,null,null,null,TextFormatAlign.LEFT);
			this.addChild(userTF);
			userTF.visible = CJKFContendLayer.isUserVisible;//是否显示玩家
			
			//查看排行榜按钮
			lookRankBt = new Button();
			lookRankBt.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			lookRankBt.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			lookRankBt.label = CJLang("kaifu_lookrank");
			lookRankBt.defaultLabelProperties.textFormat = new TextFormat("Arial", 14, 0xEDDB94);
			lookRankBt.x = 193;
			lookRankBt.y = 269;
			this.addChild(lookRankBt);
			lookRankBt.visible = false;//查看排行按等级开放 lookRankBtVisible方法
			lookRankBt.addEventListener(Event.TRIGGERED, lookRankClick);
			
			createRankLable();
			
		}
		
		public function set lookRankBtVisible(_bool:Boolean):void
		{
			lookRankBt.visible = _bool;
		}
		
		//最大12条数据，Lable复用
		private function createRankLable():void
		{
			vecTFList1 = new Vector.<Label>();
			vecTFList2 = new Vector.<Label>();
			vecTFList3 = new Vector.<Label>();
			
			var i:int=0;
			for(i=0; i<12; i++)
			{
				var lab1:Label = new Label();
				lab1.x = RankPos.x;
				lab1.y = RankPos.y + i*13;
				this.addChild(lab1);
				
				var lab2:Label = new Label();
				lab2.x = RankPos.x + 100;
				lab2.y = RankPos.y + i*13;
				this.addChild(lab2);
				
				var lab3:Label = new Label();
				lab3.x = RankPos.x + 240;
				lab3.y = RankPos.y + i*13;
				this.addChild(lab3);
				lab3.visible = CJKFContendLayer.isUserVisible;//是否显示玩家数据
				
				vecTFList1.push(lab1);
				vecTFList2.push(lab2);
				vecTFList3.push(lab3);
				
				var color:uint;
				if(i==0)color = 0xFFFF00;//黄
				else if(i==1)color = 0x00FFFF;//蓝
				else if(i==2)color = 0xFF00FF;//紫
				else if(i<10)color = 0x99CC66;//暗绿
				else color = 0xFFFFFF;//白色
				
				lab1.textRendererProperties.textFormat = new TextFormat( "黑体", 10, color,null,null,null,null,null,TextFormatAlign.LEFT);
				lab2.textRendererProperties.textFormat = new TextFormat( "黑体", 10, color,null,null,null,null,null,TextFormatAlign.LEFT);
				lab3.textRendererProperties.textFormat = new TextFormat( "黑体", 10, color,null,null,null,null,null,TextFormatAlign.CENTER);
				
			}
		}
		
		//刷新界面
		public function flushView(_type:int):void
		{
			type = _type;
			
			var js:Json_kfcontend_active_setting = CJDataOfKFContend.o.getActiveByType(type);
			
			var _arr:Array = CJDataOfKFContend.o.getDataByType(type);
			if(_arr.length <= 0)return;
			
			var _jsondata:Json_kfcontend_setting = _arr[0] as Json_kfcontend_setting;
			titleTF.text = CJLang(js.titletip);
			infoTF.text = CJLang(js.info);
			
			var timerc:int = int(CJDataOfGlobalConfigProperty.o.getData("KFCONTEND_TIMESET"));//容错时间
			var timerc2:int = int(CJDataOfGlobalConfigProperty.o.getData("KFCONTEND_TIMESET2"));//容错时间
			
			var arr:Array = String(js.kftime).split(":");
			var targetTime:int = int(js.kfday)*24*60*60 + int(arr[0])*60*60 + int(arr[1])*60 + int(arr[2]) + CJKFContendLayer.openservertime + timerc2;//活动开启时间 单位 S
			
			timeTF.text = SDateUtil.LTSeconds2YYMMDDHHIISS(targetTime) +"  --  "+ SDateUtil.LTSeconds2YYMMDDHHIISS(targetTime + int(js.lasttime)*60)
			
			var i:int=0;
			for(i=0; i<12; i++)
			{
				if(i < _arr.length)
				{
					_jsondata = _arr[i] as Json_kfcontend_setting;
					
					if(i <=9){
						var contant:String = CJLang(_jsondata.indextip);
						contant = contant.replace("{value}", (i+1)+"");
						vecTFList1[i].text = contant;
					}
					else{
						vecTFList1[i].text = CJLang(_jsondata.indextip);
					}
					vecTFList2[i].text = CJLang(_jsondata.award);
				}
				else
				{
					vecTFList1[i].text = "";
					vecTFList2[i].text = "";
				}
			}
			
			if(CJKFContendLayer.isUserVisible)//是否显示玩家)
			{
				if(_type==1 && _rankRichData == null)SocketManager.o.callwithRtn(ConstNetCommand.CS_KFCONTEND_RICH_LEVEL, _onSocketComplete);
				else if(_type==2 && _rankLevelData == null)SocketManager.o.callwithRtn(ConstNetCommand.CS_KFCONTEND_LEVEL, _onSocketComplete);
				else if(_type==3 && _rankFightData == null)SocketManager.o.callwithRtn(ConstNetCommand.CS_KFCONTEND_GETRNAK, _onSocketComplete);
				else if(_type==4 && _rankBattleData == null)SocketManager.o.callwithRtn(ConstNetCommand.CS_KFCONTEND_BATTLE, _onSocketComplete);
				else flushuserData();
			}
		}
		
		//刷新数据排行
		private function flushuserData():void
		{
			var _arr:Array = CJDataOfKFContend.o.getDataByType(type);
			
			var _userarr:Array=[];
			if(type==1)_userarr = _rankRichData;
			else if(type==2)_userarr = _rankLevelData;
			else if(type==3)_userarr = _rankFightData;
			else if(type==4)_userarr = _rankBattleData;
			
			var i:int=0;
			var _jsondata:Json_kfcontend_setting;
			for(i=0; i<12; i++)
			{
				if(i < _userarr.length && i < _arr.length && i < 10)
				{
					if(type==1)vecTFList3[i].text = _userarr[i].name;
					else if(type==2)vecTFList3[i].text = _userarr[i].name;
					else if(type==3)vecTFList3[i].text = _userarr[i].rolename;
					else if(type==4)vecTFList3[i].text = _userarr[i].name;
				}
				else
				{
					vecTFList3[i].text = "";
				}
			}
		}
		
		private function _onSocketComplete(message:SocketMessage):void
		{
			var retParams:Array;
			if (message.getCommand() == ConstNetCommand.CS_KFCONTEND_LEVEL)
			{
				if (message.retcode == 0)
				{
					_rankLevelData = message.retparams as Array;
					flushuserData();
				}
			}
			else if (message.getCommand() == ConstNetCommand.CS_KFCONTEND_BATTLE)
			{
				if (message.retcode == 0)
				{
					_rankBattleData = message.retparams as Array;
					flushuserData();
				}
			}
			else if (message.getCommand() == ConstNetCommand.CS_KFCONTEND_RICH_LEVEL)
			{
				if (message.retcode == 0)
				{
//					_rankRichData = new Array();
//					var tempRankRichData:Array = message.retparams as Array;
//					for (var i:int = 0; i < tempRankRichData.length; i++) 
//					{
//						var rankRichObj:Object = tempRankRichData[i] as Object;
//						if (rankRichObj.hasOwnProperty("expensegold") && rankRichObj.expensegold > 0)
//						{
//							_rankRichData.push(rankRichObj);
//						}
//					}
					_rankRichData = message.retparams as Array;
					flushuserData();
				}
			}
			else if (message.getCommand() == ConstNetCommand.CS_KFCONTEND_GETRNAK)
			{
				if (message.retcode == 0)
				{
					_rankFightData = message.retparams as Array;
					flushuserData();
				}
			}
		}
		
		private function lookRankClick(e:Event):void
		{
			SApplication.moduleManager.exitModule("CJKFContendModule");
			
			
			SSoundEffectUtil.playTipSound();
			if(type==3)SApplication.moduleManager.enterModule("CJArenaModule");//竞技场
			else SApplication.moduleManager.enterModule("CJRankModule");//排行榜
			
		}
		
		private function removeAllListener():void
		{
			lookRankBt.removeEventListener(Event.TRIGGERED, lookRankClick);
		}
		
		override public function dispose():void
		{
			removeAllListener();
			
			super.dispose();
		}
	}
}