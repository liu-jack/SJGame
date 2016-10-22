package SJ.Game.qiandao
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstDynamic;
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJItemUtil;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataOfQianDao;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_item_package_config;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.task.CJTaskFlowString;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.display.TiledImage;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class CJQiandaoLayer extends SLayer
	{
		public function CJQiandaoLayer()
		{
			super();
			this.setSize(480, 320);
		}
		
		/** 按钮 */
		private var _btnVec1:Vector.<Button>;
		private var _btnVec2:Vector.<Button>;
		
		private var _iconVec:Vector.<CJQianDaoItem>;
		
		private var currentDay:int;//当前是第几天
		private var qiandaoStates:Array;//30天签到状态
		private var giftStates:Array;//奖品领取状态
		
		private var currentTabIndex:int;//当前展示的礼包tab索引
		private var currentDayNum:int;//当前展示的礼包的索引(days)
		
		private var everyDayGoldTip:Label;//每日额外获得银两
		private var taotalNumTip:Label;//签到天数总计
		
		private var qiandaoBt:Button;//签到按钮
		private var lingquBt:Button;//领取按钮
		private var closeButton:Button;//关闭按钮
		
		override protected function initialize():void
		{
			super.initialize();
			
			// 背景
			var textureBg:Texture = SApplication.assets.getTexture("common_tankuangdi");
			var bgScaleRange:Rectangle = new Rectangle(19,19,1,1);
			var bgTexture:Scale9Textures = new Scale9Textures(textureBg, bgScaleRange);
			var bgImage:Scale9Image = new Scale9Image(bgTexture);
			bgImage.width = width;
			bgImage.height = height;
			this.addChildAt(bgImage, 0);
			
			//背景2
			var texture:Texture = SApplication.assets.getTexture("common_dizhezhaonew");
			var imgBg:Scale9Image = new Scale9Image(new Scale9Textures(texture, new Rectangle(1 ,1 , 1, 1)));
			imgBg.x = 2;
			imgBg.y = 0;
			imgBg.width = width-4;
			imgBg.height = 179;
			this.addChild(imgBg);
			
			// 全屏头部底
			var imgHeadBg:TiledImage = new TiledImage(SApplication.assets.getTexture("common_quanpingtoubudi"));
			imgHeadBg.width = width;
			this.addChild(imgHeadBg);
			
			// 边角
			var imgBgcorner:Scale9Image;
			imgBgcorner = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_quanpingzhuangshi", 14.5, 13, 1, 1);
			imgBgcorner.x = 0;
			imgBgcorner.y = 0;
			imgBgcorner.width = width;
			imgBgcorner.height = height;
			this.addChild(imgBgcorner);
			
			
			//标题
			var labTitle:CJPanelTitle = new CJPanelTitle(this._getLang("QIANDAO_TITLE"));
			labTitle.x = 100;
			this.addChild(labTitle);
			
			//red bar
			var redBar:ImageLoader = new ImageLoader();
			redBar.source = SApplication.assets.getTexture("qiandao_leijiqiandaoditiao");
			redBar.y = 20;
			redBar.scaleX = redBar.scaleY = 2;
			this.addChild(redBar);
			
			//累计签到次数
			var barTip:Label = new Label();
			barTip.text = CJLang("QIANDAO_LJQDCS");
			barTip.x = 6;
			barTip.y = 24;
			barTip.textRendererProperties.textFormat = new TextFormat( "黑体", 12, 0xFFFF00,null,null,null,null,null,TextFormatAlign.LEFT);
			this.addChild(barTip);
			
			//累计数字
			taotalNumTip = new Label();
			taotalNumTip.text = "";
			taotalNumTip.x = 100;
			taotalNumTip.y = 24;
			taotalNumTip.textRendererProperties.textFormat = new TextFormat( "黑体", 12, 0xFFFFFF,null,null,null,null,null,TextFormatAlign.LEFT);
			this.addChild(taotalNumTip);
			
			//tip
			everyDayGoldTip = new Label();
			everyDayGoldTip.text = "";
			everyDayGoldTip.x = 300;
			everyDayGoldTip.y = redBar.y+5;
			everyDayGoldTip.textRendererProperties.textFormat = new TextFormat( "黑体", 12, 0xFFFF00,null,null,null,null,null,TextFormatAlign.LEFT);
			this.addChild(everyDayGoldTip);
			
			// 30个签到按钮
			this._btnVec1 = new Vector.<Button>();
			var t_bt:Button;
			var i:int;
			for(i=0; i<30; i++)
			{
				t_bt = new Button();
				t_bt.name = i+"";
				t_bt.defaultSkin = this._getImgBtnSel(1, 1);
				t_bt.defaultSelectedSkin = this._getImgBtnSel(1, 2);
				t_bt.defaultLabelProperties.textFormat = new TextFormat("Arial", 14, 0xEDDB94);
				t_bt.label = (i+1)+"";
				t_bt.x = (i%7)*67 + 3;
				t_bt.y = int(i/7)*26 + 46;
				this._btnVec1.push(t_bt);
				this.addChild(t_bt);
			}
			
			
			//签到按钮
			qiandaoBt = new Button();
			qiandaoBt.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniuda01new"));
			qiandaoBt.downSkin = new SImage(SApplication.assets.getTexture("common_anniuda02new"));
			qiandaoBt.disabledSkin = new SImage(SApplication.assets.getTexture("common_anniuda03new"));
			qiandaoBt.label = CJLang("QIANDAO_QD");
			qiandaoBt.defaultLabelProperties.textFormat = new TextFormat("Arial", 14, 0xEDDB94);
			qiandaoBt.x = 360;
			qiandaoBt.y = 179;
			this.addChild(qiandaoBt);
			qiandaoBt.addEventListener(Event.TRIGGERED, _qianDaoClick);
			
			// 5个连续签到按钮
			var arr:Array = CJDataOfQianDao.o.getGiftNum();
			this._btnVec2 = new Vector.<Button>();
			for(i=0; i<5; i++)
			{
				t_bt = new Button();
				t_bt.name = "gifttab"+i;
				t_bt.defaultSkin = this._getImgBtnSel(2, 2);
				t_bt.defaultSelectedSkin = this._getImgBtnSel(2, 1);
				t_bt.downSkin = this._getImgBtnSel(2, 2);
				t_bt.defaultLabelProperties.textFormat = new TextFormat("Arial", 14, 0xEDDB94);
				
				var contant:String = CJLang("QIANDAO_QDC");
				t_bt.label = contant.replace("{value}", arr[i]);
				t_bt.x = i*95 - 2;
				t_bt.y = qiandaoBt.y + 27;
				
				this._btnVec2.push(t_bt);
				this.addChild(t_bt);
				
				t_bt.addEventListener(Event.TRIGGERED, _giftTabClick);
			}
			
			//道具底框
			var itemTU:Texture = SApplication.assets.getTexture("qiandao_wupindikuang");
			var itemBg:Scale9Image = new Scale9Image(new Scale9Textures(itemTU, new Rectangle(20 , 20 , 1, 1)));
			itemBg.x = 2;
			itemBg.y = 230;
			itemBg.width = width-4;
			itemBg.height = 88;
			this.addChild(itemBg);
			
			//8个道具卡片
			_iconVec = new Vector.<CJQianDaoItem>();
			var iconBg:CJQianDaoItem;
			for(i=0; i<8; i++)
			{
				iconBg = new CJQianDaoItem();
				iconBg.x = i*58 + 9;
				iconBg.y = qiandaoBt.y + 52;
				this.addChild(iconBg);
				_iconVec.push(iconBg);
				iconBg.addEventListener(TouchEvent.TOUCH, showGiftItem);
			}
			
			//领取按钮
			lingquBt = new Button();
			lingquBt.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniuda01new"));
			lingquBt.downSkin = new SImage(SApplication.assets.getTexture("common_anniuda02new"));
			lingquBt.disabledSkin = new SImage(SApplication.assets.getTexture("common_anniuda03new"));
			lingquBt.label = CJLang("QIANDAO_LJ");
			lingquBt.defaultLabelProperties.textFormat = new TextFormat("Arial", 14, 0xEDDB94);
			lingquBt.x = qiandaoBt.x;
			lingquBt.y = 286;
			this.addChild(lingquBt);
			lingquBt.addEventListener(Event.TRIGGERED, _giftClick);
			
			//关闭按钮
			closeButton = new Button();
			closeButton.defaultSkin = new SImage(SApplication.assets.getTexture("common_quanpingguanbianniu01"));
			closeButton.downSkin = new SImage(SApplication.assets.getTexture("common_quanpingguanbianniu02"));
			closeButton.addEventListener(Event.TRIGGERED , _closeHandle);
			closeButton.x = 438;
			closeButton.name = "closeBt";
			this.addChild(closeButton);
			
			//初始化数据
			_initData();
			
		}

		/**
		 * 获取按钮选中的图片
		 * @param _type 1,2代表两种按钮皮肤
		 * @param _state 1,2代表未选中和选中
		 * 
		 * @return 
		 */		
		private function _getImgBtnSel(_type:int, _state:int):SImage
		{
			var s:String;
			switch(_type)
			{
				case 1:
					if(_state==1)s = "qiandao_weiqiandao";
					else s = "qiandao_yiqiandao";
					break;
				
				case 2:
					if(_state==2)s = "qiandao_chayexiang";
					else s = "qiandao_chayexiangdianliang";
					break;
			}
			return new SImage(SApplication.assets.getTexture(s));
		}
		
		//初始化数据
		private function _initData():void
		{
			SocketManager.o.callwithRtn(ConstNetCommand.CS_QIANDAO_BASEINFO, _qianDaoBaseInfo);//请求基本数据
		}
		
		//点击签到
		private function _qianDaoClick(eve:Event):void
		{
			SocketManager.o.callwithRtn(ConstNetCommand.CS_QIANDAO_QIANDAO, _qianDao);
		}
		
		//点击领奖
		private function _giftClick(eve:Event):void
		{
			if(currentDayNum == 0)return;//此时签到数据还没有收到
			
			SocketManager.o.callwithRtn(ConstNetCommand.CS_QIANDAO_GIFT,  _getWard,  false, currentTabIndex, currentDayNum);//领奖
		}
		
		//点击道具查看信息
		private function showGiftItem(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this,TouchPhase.BEGAN)
			if(touch)
			{
				var item:CJQianDaoItem = e.currentTarget as CJQianDaoItem;
				if(item.itemId != 0)CJItemUtil.showItemTooltipsWithTemplateId(item.itemId);
			}
		}
		
		//点击奖品展示tab按钮
		private function _giftTabClick(eve:Event):void
		{
			var _name:String = eve.target["name"];
			_name = _name.replace("gifttab", "");
			var _index:int = int(_name);
			
			_showTabGift(_index);
		}
		
		/**
		 * 展示标签礼物
		 * @param _index 标签索引 0开始
		 */		
		private function _showTabGift(_index:int):void
		{
			var i:int;
			for(i=0; i <5; i++)
			{
				// 未选中
				this._btnVec2[i].isSelected = false;
			}
			
			// 选中
			this._btnVec2[_index].isSelected = true;
			
			currentTabIndex = _index;
			currentDayNum = CJDataOfQianDao.o.getDays(_index);
			
			//展示奖品
			_showGifts(_index);
			
			//领取按钮显示状态
			if(giftStates[currentTabIndex] == "1"){
				lingquBt.label = CJLang("QIANDAO_YJLQ");
				lingquBt.isEnabled = false;
			}else{
				
				var total:int=0;//总的签到天数
				for(i=0; i<qiandaoStates.length; i++)
				{
					if(int(qiandaoStates[i])==1)total++;
				}
				
				lingquBt.label = CJLang("QIANDAO_LJ");
				lingquBt.isEnabled = (total >= currentDayNum);
			}
		}
		
		//关闭窗口
		private function _closeHandle(eve:Event):void
		{
			SSoundEffectUtil.playButtonNormalSound();
			SApplication.moduleManager.exitModule("CJQiandaoModule");
		}
		
		private function _qianDaoBaseInfo(message:SocketMessage):void
		{
			if(message.getCommand() == ConstNetCommand.CS_QIANDAO_BASEINFO)
			{
				var retCode:uint = message.params(0);
				var datas:Array = message.params(1);
			
				currentDay = datas[0];
				qiandaoStates = String(datas[1]).split("");
				giftStates = String(datas[2]).split("");
				
				//刷新界面
				_flushLayer();
			}
		}
		
		private function _qianDao(message:SocketMessage):void
		{
			if(message.getCommand() == ConstNetCommand.CS_QIANDAO_QIANDAO)
			{
				var retCode:uint = message.params(0);
				var datas:Array = message.params(1);
				
				if(datas[0] == 1)
					CJMessageBox(CJLang("QIANDAO_JRYQD"));
				else{
//					CJMessageBox(CJLang("QIANDAO_QDCG"));
					qiandaoStates[currentDay-1] = "1";
					
					_flushLayer();
					
					//飘字，获得银两
					var money:int = CJDataOfQianDao.o.getMoney(currentDay);
					var contant:String = CJLang("QIANDAO_QDHDYL");
					contant = contant.replace("{value}", money);
					new CJTaskFlowString(contant, 2, 50).addToLayer();
					
					SocketCommand_role.get_role_info();//刷新银两界面显示
				}
			}
		}
		
		private function _getWard( message:SocketMessage ) : void
		{
			if(message.getCommand() == ConstNetCommand.CS_QIANDAO_GIFT)
			{
				var retCode:uint = message.params(0);
				var datas:Array = message.params(1);
			
				if(datas[0] == 0){
//					CJMessageBox(CJLang("QIANDAO_QDYXCS"));
					giftStates[currentTabIndex] = "1";
					
					//领取按钮显示状态
					lingquBt.label = CJLang("QIANDAO_YJLQ");
					lingquBt.isEnabled = false;
					
					_closeHandle(null);
					SApplication.moduleManager.enterModule("CJDynamicModule", {"pagetype":ConstDynamic.DYNAMIC_TYPE_SYSTEM});
					
				}else if(datas[0] == 1)//不符合条件
					CJMessageBox(CJLang("QIANDAO_BFHLQTJ"));
				else if(datas[0] == 2)//已经领取
					CJMessageBox(CJLang("QIANDAO_YJLQ"));
			}
			
		}
		
		//刷新界面
		private function _flushLayer():void
		{
			//签到按钮状态显示
			var i:int;
			for(i=0; i < qiandaoStates.length; i++)
			{
				//删掉之前的icon
				var gouIcon:ImageLoader = this._btnVec1[i].getChildByName("gou") as ImageLoader;
				if(gouIcon != null)this._btnVec1[i].removeChild(gouIcon);
				
				var jinIcon:ImageLoader = this._btnVec1[i].getChildByName("jin") as ImageLoader;
				if(jinIcon != null)this._btnVec1[i].removeChild(jinIcon);
					
				if (qiandaoStates[i] == "0")
				{
					// 未选中
					this._btnVec1[i].isSelected = false;
				}
				else if (qiandaoStates[i] == "1")
				{
					// 选中
					this._btnVec1[i].isSelected = true;
					
					var gouBg:ImageLoader = new ImageLoader();
					gouBg.source = SApplication.assets.getTexture("qiandao_duigou");
					gouBg.name = "gou";
					gouBg.x = 45;
					this._btnVec1[i].addChild(gouBg);
				}
				
				//"今"  ICON
				if((i+1) == currentDay)
				{
					var jinBg:ImageLoader = new ImageLoader();
					jinBg.source = SApplication.assets.getTexture("qiandao_jin");
					jinBg.name = "jin";
					jinBg.x = 2;
					this._btnVec1[i].addChild(jinBg);
				}
			}
			
			//当天签到可获得银两显示
			var money:int = CJDataOfQianDao.o.getMoney(currentDay);
			var contant:String = CJLang("QIANDAO_MRQDKHDYB");
			everyDayGoldTip.text = contant.replace("{value}", money);
			
			//连续签到天数提示
			var total:int;
			for(i=0; i < qiandaoStates.length; i++)
			{
				if(qiandaoStates[i] == "1")total++;
			}
			
			taotalNumTip.text = ""+total;
			
			//签到按钮显示状态
			if(qiandaoStates[currentDay-1] == "1"){
				qiandaoBt.label = CJLang("QIANDAO_YQD");
				qiandaoBt.isEnabled = false;
			}else{
				qiandaoBt.label = CJLang("QIANDAO_QD");
				qiandaoBt.isEnabled = true;
			}
			
			//自动切换到下次领取的tab位置
			var _preindex:int;
			var _index:int=-1;
			var arr:Array = CJDataOfQianDao.o.getGiftNum();
			for(i=0; i < arr.length; i++)
			{
				if(total >= int(arr[i]))//天数达到
				{
					_preindex = i+1;
					if(giftStates[i] == "0")//没有领取过
					{
						_index = i;
						break;
					}
				}
			}
			
			if(_index != -1){
				_showTabGift(_index);
			}
			else{
				if(_preindex > arr.length-1)_preindex = 0;
				
				_showTabGift(_preindex);
			}
		}
		
		/**
		 * 展示奖品
		 * @param _index tab序号
		 */		
		private function _showGifts(_index:int):void
		{
			//根据tab序号得到礼包id
			var boxId:int = CJDataOfQianDao.o.getBoxID(_index);
			
			//根据礼包id获得礼包中道具列表和数量等配置信息
			var arr:Array = CJDataOfQianDao.o.getLibaoItemsList(boxId);
			
			for(var i:int=0; i<_iconVec.length; i++)
			{
				if(i < arr.length)
				{
					var data:Json_item_package_config = arr[i] as Json_item_package_config;
					
					_iconVec[i].setNum(data.itemcount);
					_iconVec[i].itemId = data.itemid;//设置道具id
					
					var imgName:String = CJDataOfItemProperty.o.getTemplate(data.itemid).picture;
					_iconVec[i].setBagGoodsItem(imgName);
				}
				else
				{
					_iconVec[i].removeOldItem();
					_iconVec[i].itemId = 0;//重置
				}
			}
			
		}
		
		/**
		 * 获取语言表对应语言
		 * @param langKey
		 * @return 
		 * 
		 */		
		private function _getLang(langKey:String) : String
		{
			return CJLang(langKey);
		}
		
		private function removeAllListener():void
		{
			for(var i:int=0; i<_btnVec2.length; i++)
			{
				_btnVec2[i].removeEventListener(Event.TRIGGERED, _giftTabClick);
			}
			
			for(i=0; i<_iconVec.length; i++)
			{
				_iconVec[i].removeEventListener(TouchEvent.TOUCH, showGiftItem);
			}
			
			qiandaoBt.removeEventListener(Event.TRIGGERED, _qianDaoClick);
			closeButton.removeEventListener(Event.TRIGGERED , _closeHandle);
			lingquBt.removeEventListener(Event.TRIGGERED, _giftClick);
		}
		
		override public function dispose():void
		{
			removeAllListener();
			
			closeButton = null;
			_btnVec1 = null;
			_btnVec2 = null;
			_iconVec = null;
			qiandaoStates = null;
			giftStates = null;
			everyDayGoldTip = null;
			taotalNumTip = null;
			qiandaoBt = null;
			lingquBt = null;
			super.dispose();
		}
		
	}
}
