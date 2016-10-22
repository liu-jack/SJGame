package SJ.Game.duobao
{
	import com.greensock.TweenLite;
	
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.CJDataOfDuoBao;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.json.Json_treasure_part_setting;
	import SJ.Game.formation.CJTurnPage;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.task.CJTaskFlowString;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.ProgressBar;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	import starling.textures.Texture;

	/**
	 * 
	 * @author bianbo
	 * 
	 */
	public class CJSubXunBaoLayer extends SLayer
	{
		private var _addBaoHuCount:Button;
		private var _xunbaoTabBt:Button;
		
		private var _expLabel:Label;
		private var _progressBar:ProgressBar;
		private var xunlevel:Label;
		private var xunNum:Label;
		
		private var _findLevel:int;//寻宝等级
		private var _baoGetTip:String="";//开启新宝物后给用户的提示
		
		private var findedItemsList:Vector.<CJDuoBaoItemLayer>
		
		//左边宝物列表
		private var _scrollView:CJTurnPage;
		
		private var cardConn:SLayer;
		
		private var _parent:CJDuoBaoLayer;
		
		public function CJSubXunBaoLayer(parent:CJDuoBaoLayer)
		{
			super();
			_parent = parent;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			// 背景
			var textureBg:Texture = SApplication.assets.getTexture("duobao_xunbaobg");
			var bgScaleRange:Rectangle = new Rectangle(25, 10, 10, 10);
			var bgTexture:Scale9Textures = new Scale9Textures(textureBg, bgScaleRange);
			var bgImage:Scale9Image = new Scale9Image(bgTexture);
			bgImage.x = 127;
			bgImage.y = 37;
			bgImage.width = 344;
			bgImage.height = 260;
			this.addChild(bgImage);
			
			//黑色道具框
			var texture:Texture;
			texture = SApplication.assets.getTexture("zhuce_zuijindengludi");
			var bg:Scale9Image = new Scale9Image(new Scale9Textures(texture, new Rectangle(5, 5, 2, 2)));
			bg.x = 140;
			bg.y = 105-30;
			bg.width = 317;
			bg.height = 60;
			bg.color = 0x444444;
			this.addChild(bg);
			
			//绿色道具底框
			var itemTU:Texture = SApplication.assets.getTexture("green_dikuang");
			var itemBg:Scale9Image = new Scale9Image(new Scale9Textures(itemTU, new Rectangle(20 , 20 , 1, 1)));
			itemBg.x = 140;
			itemBg.y = 105-30;
			itemBg.width = 317;
			itemBg.height = 60;
			this.addChild(itemBg);
			
			findedItemsList = new Vector.<CJDuoBaoItemLayer>();
			cardConn = new SLayer();
			cardConn.x = bg.x + 5;
			cardConn.y = bg.y;
			addChild(cardConn);
			//5个道具卡片
			var iconBg:CJDuoBaoItemLayer;
			for(var i:int=0; i<5; i++)
			{
				iconBg = new CJDuoBaoItemLayer();
				iconBg.x = i*62;// + bg.x + 5;
				iconBg.y = 0;//bg.y;
				cardConn.addChild(iconBg);
				
				findedItemsList.push(iconBg);
			}
			cardConn.clipRect = new Rectangle(0, 4, 310, 54);
			
			//寻宝次数提示
			var xunNumTip:Label = new Label();
			xunNumTip.text = CJLang("XUNBAO_FINDNUM");//"寻宝次数：";
			xunNumTip.x = 237 - 75;
			xunNumTip.y = 76 + 171;
			xunNumTip.textRendererProperties.textFormat = new TextFormat( "黑体", 12, 0x00FF00,null,null,null,null,null,TextFormatAlign.CENTER);
			this.addChild(xunNumTip);
			
			//寻宝次数
			xunNum = new Label();
			xunNum.text = "";
			xunNum.x = xunNumTip.x + 63;
			xunNum.y = xunNumTip.y;
			xunNum.textRendererProperties.textFormat = new TextFormat( "黑体", 12, 0xcc6600,null,null,null,null,null,TextFormatAlign.LEFT);
			this.addChild(xunNum);
			
			//加号按钮
			_addBaoHuCount = new Button();
			_addBaoHuCount.defaultSkin = new SImage(SApplication.assets.getTexture("common_jiaanniu01"));
			_addBaoHuCount.downSkin = new SImage(SApplication.assets.getTexture("common_jiaanniu02"));
			_addBaoHuCount.disabledSkin = new SImage(SApplication.assets.getTexture("common_jiaanniu03"));
			_addBaoHuCount.addEventListener(starling.events.Event.TRIGGERED, _addXunBaoNumClick);
			_addBaoHuCount.x = xunNumTip.x + 90;
			_addBaoHuCount.y = xunNumTip.y - 4;
			this.addChild(_addBaoHuCount);
			
			//累计数字
			var taotalNumTip:Label = new Label();
			taotalNumTip.text = CJLang("XUNBAO_FINDLVTIP");//"提升寻宝等级，每次寻宝获得更多宝物碎片";
			taotalNumTip.x = 180;
			taotalNumTip.y = 168-30;
			taotalNumTip.textRendererProperties.textFormat = new TextFormat( "黑体", 12, 0xFFFF00,null,null,null,null,null,TextFormatAlign.CENTER);
			this.addChild(taotalNumTip);
			
			//寻宝等级
			xunlevel = new Label();
			xunlevel.text = "";//"寻宝等级LV";
			xunlevel.x = 296-50;
			xunlevel.y = 200-30;
			xunlevel.width = 100;
			xunlevel.textRendererProperties.textFormat = new TextFormat( "黑体", 12, 0x00FFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			this.addChild(xunlevel);
			
			// 进度条底框
			var scale3texture:Scale3Textures = new Scale3Textures(SApplication.assets.getTexture("herostar_jindutiaokuang"), 38, 6);
			var _progressBarBG:Scale3Image = new Scale3Image(scale3texture);
			_progressBarBG.width = 270;
			_progressBarBG.x = 161;
			_progressBarBG.y = 215-30;
			this.addChild(_progressBarBG);
			
			// 伸缩部分
			scale3texture = new Scale3Textures(SApplication.assets.getTexture("wujiang_jingyantiao1"),2,1);
			var fillSkin:Scale3Image = new Scale3Image(scale3texture);
			_progressBar = new ProgressBar();
			_progressBar.fillSkin = fillSkin;
			_progressBar.x = _progressBarBG.x+32;
			_progressBar.y = _progressBarBG.y+9;
			_progressBar.width = _progressBarBG.width-32*2;
			_progressBar.height = 5;
			this.addChild(_progressBar);
			_progressBar.validate();

			// 经验条上的显示百分比文字
			_expLabel = new Label;
			_expLabel.textRendererProperties.textFormat = new TextFormat( "Arial", 9, 0xFFFF00,null,null,null,null,null, TextFormatAlign.CENTER );
			_expLabel.x = _progressBarBG.x + _progressBarBG.width/2 - 50;
			_expLabel.width = 100;
			_expLabel.y = _progressBarBG.y + 4;
			_expLabel.text = "";//"10000001/100000001";
			this.addChild(_expLabel);
			
			//每天时间点次数提示
			var _numtipLabel:Label = new Label;
			var tf:TextFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xffff00, null, null, null, null, null, TextFormatAlign.CENTER);
			_numtipLabel.textRendererProperties.textFormat = tf;
			_numtipLabel.y = _progressBarBG.y + 22;
			_numtipLabel.text = CJLang("DUOBAO_DUOBAOBUY_TIP");
			_numtipLabel.x = 305 - _numtipLabel.text.length*5;
			this.addChild(_numtipLabel);
			
			//寻宝按钮
			_xunbaoTabBt = new Button();
			_xunbaoTabBt.x = 240+74;
			_xunbaoTabBt.y = 240;
			_xunbaoTabBt.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniuda01new"));
			_xunbaoTabBt.downSkin = new SImage(SApplication.assets.getTexture("common_anniuda02new"));
			_xunbaoTabBt.disabledSkin = new SImage(SApplication.assets.getTexture("common_anniuda03new"));
			_xunbaoTabBt.label = CJLang("XUNBAO_TITLETXT");//"寻宝";
			_xunbaoTabBt.defaultLabelProperties.textFormat = new TextFormat("Arial", 14, 0xEDDB94);
			_xunbaoTabBt.addEventListener(Event.TRIGGERED, _xunbaoClick);
			this.addChild(_xunbaoTabBt);
			
			SocketManager.o.callwithRtn(ConstNetCommand.CS_XUNBAO_BASEINFO, _baseInfoBack);
		}
		
		private function _baseInfoBack(message:SocketMessage):void
		{
			var obj:Object = message.retparams;//{"findmaxnum":5,"findlevel":10,"findexp":0,"findnum":3,"maxexp":"1900"}
			
			_findLevel = int(obj.findlevel);
			
			flushDataView(obj);
			
			initTargetItems();//初始化可获得碎片格子状态
		}
		
		private function initTargetItems():void
		{
			var num:int = CJDataOfDuoBao.o.getEleNumByLevel(_findLevel);
			
			for(var i:int=0 ; i<findedItemsList.length; i++)
			{
				var targetLv:int = CJDataOfDuoBao.o.getLevelByGridIndex(i+1);
				if(i < num)
				{
					findedItemsList[i].setItemTip("");
				}
				else
				{
					var contant:String = CJLang("XUNBAO_OPENLV");
					findedItemsList[i].setItemTip(contant.replace("{value}", targetLv) +"\n" + CJLang("XUNBAO_OPENLV2"));//"寻宝"+targetLv+"级\n开启"
				}
			}
		}
		
		//点击寻宝按钮
		private function _xunbaoClick(e:Event):void
		{
			_xunbaoTabBt.isEnabled = false;
			SocketManager.o.callwithRtn(ConstNetCommand.CS_XUNBAO_XUNBAO, _xunBao);
		}
		
		//点击加号按钮, 增加购买次数
		private function _addXunBaoNumClick(e:Event):void
		{
			SocketManager.o.callwithRtn(ConstNetCommand.CS_DUOBAO_GETCURBUYNUM, _getBuyNum);
		}
		//
		private function _getBuyNum(message:SocketMessage):void
		{
			var obj:Object = message.retparams;
			//obj.buyfindnum
			//obj.fvipnum
			if(int(obj.buyfindnum) >= int(obj.fvipnum))
			{
				CJMessageBox(CJLang("XUNBAO_HAVENOBUYNUM"));//"已经没有购买次数了"
			}
			else
			{
				var tipPanel:CJBuyNumTipPanel = new  CJBuyNumTipPanel();
				tipPanel.buyNum = int(obj.buyfindnum);
				tipPanel.vipBuyNum = int(obj.fvipnum);
				tipPanel.funcHandle = _addXunBaoNum;
				tipPanel.buyType = 1;
				tipPanel.x = 144;
				tipPanel.y = 75;
				addChild(tipPanel);
			}
		}
		
		//寻宝返回
		private function _xunBao(message:SocketMessage):void
		{
			if(message.retcode > 0)_xunbaoTabBt.isEnabled = true;
				
			
			if(message.retcode==1)
			{
				CJMessageBox(CJLang("XUNBAO_NOFINDNUM"));//"没有寻宝次数"
			}
			else if(message.retcode==2)
			{
				CJMessageBox(CJLang("XUNBAO_RANDOMGETNUM"));//"碎片随机获取的次数"
			}
			else if(message.retcode==3)
			{
				CJMessageBox(CJLang("XUNBAO_LVLIMIT"));//"寻宝等级不够"
			}
			else if(message.retcode==4)
			{
				CJMessageBox(CJLang("XUNBAO_NOTGETPART"));//"没有获得宝物碎片"
			}
			else
			{
				//{"part":{"16":1,"6":1,"23":1,"8":3,"12":2,"13":1,"14":1},"findlevel":10,"findexp":0,"findmaxnum":5,"maxexp":"1900","findnum":2}
				var obj:Object = message.retparams;
//				trace(JSON.stringify(obj));
				
				_baoGetTip = "";//重置空字符串
				if(_findLevel != int(obj.findlevel))
				{
					_findLevel = int(obj.findlevel);
					initTargetItems();//初始化可获得碎片格子状态
					_baoGetTip = CJDataOfDuoBao.o.getTreasureByOpenLV(_findLevel);
				}
				
				flushDataView(obj);
				flushItemsView(obj.part);
				
				this.parent != null && (this.parent as CJDuoBaoLayer).flushBaoList();
			}
		}
		
		//刷新数据显示
		private function flushDataView(obj:Object):void
		{
			//经验条
			_progressBar.minimum = 0;
			_progressBar.maximum = int(obj.maxexp);
			if(int(obj.findlevel) >= int(CJDataOfGlobalConfigProperty.o.getData("TREASURE_FIND_MAX_LEVEL"))){
				_progressBar.value = _progressBar.maximum;
				_expLabel.text = "MAX";//经验条
			}else{
				_progressBar.value = int(obj.findexp);
				_expLabel.text = String(obj.findexp)+"/"+String(obj.maxexp);//经验条
			}
			xunlevel.text =  CJLang("XUNBAO_XBLV")+int(obj.findlevel);//"寻宝等级LV" + 
			xunNum.text = obj.findnum;
		}
		
		//刷新道具界面显示
		private function flushItemsView(obj:Object):void
		{
			var num:int = CJDataOfDuoBao.o.getEleNumByLevel(_findLevel);
			
			//显示获得的碎片
			var index:int=0;
			for(var key:* in obj)
			{
				if(index < num && index<findedItemsList.length)
				{
					var js:Json_treasure_part_setting = CJDataOfDuoBao.o.getTreasurePartByID(key);
					for(var a:int=0; a<int(obj[key]); a++)
					{
						findedItemsList[index].setItem(js.picture, js.treasurename);
						index++;
					}
				}else if(index >= num)
				{
					//飘字, 仅debug
					new CJTaskFlowString("log overflow num" +(index - num +1), 1.6, 46).addToLayer();
				}
			}
			
			//没有寻到碎片
			if(index==0){
				_xunbaoTabBt.isEnabled = true;
				CJMessageBox(CJLang("XUNBAO_XBFAIL"));//"寻宝失败"
			}
			else{
				
				var minnum:int = findedItemsList.length;
				if(num <= findedItemsList.length)minnum = num;
				if(index < minnum)minnum = index;
				
				//滚动效果
				rockNum =  minnum;
				clockEffectFunc();//第一次即时
				
				if(rockNum-1 > 0)
				{
					var t:Timer = new Timer(200, rockNum-1);
					t.addEventListener(TimerEvent.TIMER, timerClock);
					t.start();
				}
			}
		}
		
		private function timerClock(e:TimerEvent):void
		{
			clockEffectFunc();

			var t:Timer = e.target as Timer;
			if(t.currentCount == t.repeatCount){
				t.stop();
				t.removeEventListener(TimerEvent.TIMER, timerClock);
			}
		}
		
		private var rockNum:int;
		private var rockIndex:int=0;
		private function clockEffectFunc():void
		{
			var t:TweenRock = new TweenRock(findedItemsList[rockIndex], rockIndex);
			t.addEventListener(TweenRock.RockOver, rockOver);
			rockIndex++;
			
			if(rockIndex == rockNum)
			{
				rockIndex = 0;
				if(_baoGetTip != ""){
					CJMessageBox(_baoGetTip);//开启新宝物，提示用户
					_baoGetTip = "";
				}
			}
		}
		
		private var flyIndex:int=0;
		private function rockOver(e:RockEvent):void
		{
			findedItemsList[e.index].setImgVisible();//显示结果
			(e.target as TweenRock).removeEventListener(TweenRock.RockOver, rockOver);
			
			try{
				//延迟飞过
				var i:int = setTimeout(function ():void{
					
					clearTimeout(i);
					var pic:SImage = findedItemsList[e.index].getClone();
					addChild(pic);
					TweenLite.to(pic, 1.1, {x:75, y:140, alpha:0.4, onComplete:function ():void{
						
						flyIndex++;
						removeChild(pic);
						TweenLite.killTweensOf(pic);
						
						if(flyIndex == rockNum){
							flyIndex = 0;
							_xunbaoTabBt.isEnabled = true;
						}
					
					}});
					
				}, 1500);
			}catch(e:Error){
				flyIndex = 0;
				_xunbaoTabBt.isEnabled = true;
			}
		}
		
		//增加寻宝次数返回
		internal function _addXunBaoNum(message:SocketMessage):void
		{
			var retCode:uint = message.params(0);
			
			if(retCode==1)
			{
				CJMessageBox(CJLang("XUNBAO_HAVENOBUYNUM"));//"购买次数不足"
			}
			else if(retCode==2)
			{
				CJMessageBox(CJLang("XUNBAO_GOLDNOTENOUGH"));//"元宝不够"
			}
			else if(retCode==0)
			{
				//飘字，获得银两
				new CJTaskFlowString(CJLang("XUNBAO_FINDNUMADDONE") + CJBuyNumTipPanel.buynumtip, 1.6, 46).addToLayer();//"寻宝次数加1"
				
				var obj:Object = message.retparams;//{"findmaxnum":5,"findlevel":10,"findexp":0,"findnum":3,"maxexp":"1900"}
				
				xunNum.text =  obj.findnum+"";
				
				SocketCommand_role.get_role_info();//刷新银两界面显示
			}
		}
		
		/**
		 * @private
		 * 选中左边列表中的宝物
		 */
		public function onSelectItem(item:CJDuoBaoListItem):void
		{
			if(!item.isOpen)return;
				
			var _curSelectBaoId:int = item.id;
			
			var _treasureData:Object = _parent.getTreasureData()
			if(_parent.getTreasureData() == null)return;
			
			var _itemInfoLayer:CJDuoBaoItemInfoLayer = new CJDuoBaoItemInfoLayer();
			_itemInfoLayer.width = 277;
			_itemInfoLayer.height = 256;
			
			var data: Object = new Object();
			data["treasureId"] = _curSelectBaoId;
			data["level"] = parseInt(_treasureData[_curSelectBaoId]["level"]);
			data["exp"] = parseInt(_treasureData[_curSelectBaoId]["exp"]);
			data["addExp"] = false;	
			CJLayerManager.o.addModuleLayer(_itemInfoLayer);
			_itemInfoLayer.setData(data);
		}
		
		private function removeAllListener():void
		{
			_addBaoHuCount.removeEventListener(starling.events.Event.TRIGGERED, _addXunBaoNumClick);
			_xunbaoTabBt.removeEventListener(Event.TRIGGERED, _xunbaoClick);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			removeAllListener();
			
			while(numChildren)removeChildAt(0);
		}
		
	}
}
import flash.events.TimerEvent;
import flash.utils.Timer;

import SJ.Game.duobao.CJDuoBaoItemLayer;

import starling.events.Event;
import starling.events.EventDispatcher;

class TweenRock extends EventDispatcher{
	
	internal static const RockOver:String = "RockOver";
	
	private var t:Timer;
	private var index:int;
	public function TweenRock(_card:CJDuoBaoItemLayer, _index:int)
	{
		initCard = _card
		initCardY = _card.y;
		
		index = _index;
		
		t = new Timer(30, 30);
		t.addEventListener(TimerEvent.TIMER, rockCard);
		t.start();
	}
	
	private var initCard:CJDuoBaoItemLayer;
	private var initCardY:int;
	private const initTweenSpeed:int = 50;
	
	private function rockCard(e:TimerEvent):void
	{
		initCard.y +=initTweenSpeed;
		if(initCard.y > initCardY + 60){
			initCard.y = initCardY - 60;
		}
		
		//over
		if(t.currentCount >= t.repeatCount)
		{
			initCard.y = initCardY;
			
			t.stop();
			t.removeEventListener(TimerEvent.TIMER, rockCard);
			t = null;
			var re:RockEvent = new RockEvent(RockOver);
			re.index = index;
			this.dispatchEvent(re);
		}
	}
	
//	private var initCard:CJDuoBaoItemLayer;
//	private var initCardY:int;
//	private var tweenIndex:int;
//	private const initTweenSpeed:int = 50;
//	private var tweenSpeed:int;
//	
//	private function rockCard(e:TimerEvent):void
//	{
//		tweenIndex++;
//		if(tweenIndex==1)tweenSpeed = initTweenSpeed;
//		
//		initCard.y +=tweenSpeed;
//		if(initCard.y > initCardY + 60){
//			initCard.y = initCardY - 60;
//			if(tweenSpeed > 12){
//				tweenSpeed -= 2;
//			}else {
//				//over
//				tweenIndex = 0;
//				initCard.y = initCardY;
//				
//				t.stop();
//				t.removeEventListener(TimerEvent.TIMER, rockCard);
//				t = null;
//			}
//		}
//	}
}

class RockEvent extends Event
{
	public var index:int;
	
	public function RockEvent(type:String)
	{
		super(type);
	}
}