package SJ.Game.duobao
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.data.CJDataOfDuoBao;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.TextInput;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class CJBuyNumTipPanel extends SLayer
	{
		internal var funcHandle:Function;
		internal var buyNum:int;//已经购买的次数
		internal var vipBuyNum:int;//可以购买的次数
		internal var buyType:int;
		
		private var curNum:int=1;
		
		private var _tiCombineNum:TextInput;
		private var tip1:Label; 
		private var tip2:Label;
		private var btnSub:Button;
		private var btnAdd:Button;
		private var btnMax:Button;
		private var btnSure:Button;
		private var bamask:Quad;
		
		internal static var buynumtip:int;//购买次数提示
		
		public function CJBuyNumTipPanel()
		{
			super();
			this.setSize(200,180)
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			bamask = new Quad(SApplicationConfig.o.stageWidth, SApplicationConfig.o.stageHeight, 0, true);
			bamask.x = -this.x;
			bamask.y = -this.y;
			bamask.alpha = 0;
			addChild(bamask);
			bamask.addEventListener(TouchEvent.TOUCH, _touchClosePrompt);
			
			// 背景
			var texture:Scale9Textures = new Scale9Textures(SApplication.assets.getTexture("common_tishikuang"),new Rectangle(16,15,2,2));
			var bg:Scale9Image = new Scale9Image(texture)
			bg.width = this.width;
			bg.height = this.height;
			this.addChild(bg);
			
			// 按钮 - 减
			btnSub = new Button();
			btnSub = new Button();
			btnSub.width = 18;
			btnSub.height = 18;
			btnSub.x = 28;
			btnSub.y = 67;
			addChild(btnSub);
			btnSub.addEventListener(starling.events.Event.TRIGGERED, _subNumClick);
			btnSub.defaultSkin = new SImage(SApplication.assets.getTexture("common_jiananniu"));
			
			// 按钮 - 加
			btnAdd = new Button();
			btnAdd.width = 18;
			btnAdd.height = 18;
			btnAdd.x = btnSub.x + 90;
			btnAdd.y = btnSub.y;
			addChild(btnAdd);
			btnAdd.addEventListener(starling.events.Event.TRIGGERED, _addNumClick);
			btnAdd.defaultSkin = new SImage(SApplication.assets.getTexture("common_jiaanniu"));
			
			//购买次数
			_tiCombineNum = new TextInput();
			_tiCombineNum.backgroundSkin = new SImage(SApplication.assets.getTexture("common_shurukuagn"));
			_tiCombineNum.paddingTop = 1;
			_tiCombineNum.text = "1";
			_tiCombineNum.x = btnSub.x+ 27;
			_tiCombineNum.y = btnSub.y+ 2;
			_tiCombineNum.isEditable = false;
			var fontFormat:Object = _tiCombineNum.textEditorProperties;
			fontFormat.fontSize = 10;
			fontFormat.autoSizeIfNeeded = true;
			fontFormat.textAlign = "center";
			this.addChild(_tiCombineNum);
			
			
			// 按钮 - MAX
			btnMax = new Button();
			btnMax.width = 32;
			btnMax.height = 12;
			btnMax.x = btnAdd.x + 29;
			btnMax.y = btnAdd.y + 3;
			addChild(btnMax);
			btnMax.addEventListener(starling.events.Event.TRIGGERED, _maxNumClick);
			btnMax.defaultSkin = new SImage(SApplication.assets.getTexture("zq_zuidahua"));
			
			//购买寻宝次数txt
			var title:Label = new Label();
			var titleFmt:TextFormat = new TextFormat("Source Sans Pro", 14, 0xFFFF00 );
			titleFmt.align = TextFormatAlign.CENTER;
			title.textRendererProperties.textFormat = titleFmt;
			title.width = this.width;
			title.y = 9;
			if(buyType==1)title.text = CJLang("XUNBAO_BUYNUM_TITLE");//"购买寻宝次数"
			else title.text = CJLang("DUOBAO_BUYNUM_TITLE");//"购买夺宝次数"
			this.addChild(title);
			
			//购买寻宝次数txt
			tip1 = new Label();
			var tip1Fmt:TextFormat = new TextFormat("Source Sans Pro", 12, 0xFFFFFF	);
			tip1Fmt.align = TextFormatAlign.CENTER;
			tip1.textRendererProperties.textFormat = tip1Fmt;
			tip1.width = this.width;
			tip1.y = 40;
			tip1.text = "";//今日还可购买X次
			addChild(tip1);
			
			//购买寻宝次数txt
			tip2 = new Label();
			var tip2Fmt:TextFormat = new TextFormat("Source Sans Pro", 12, 0xFFFFFF	);
			tip2Fmt.align = TextFormatAlign.CENTER;
			tip2.textRendererProperties.textFormat = tip2Fmt;
			tip2.width = this.width;
			tip2.y = 92;
			tip2.text = "";//您将花费XX元宝
			addChild(tip2);
			
			//购买寻宝次数txt
			var tip3:Label = new Label();
			var tip3Fmt:TextFormat = new TextFormat("Source Sans Pro", 10, 0xFF0000	);
			tip3Fmt.align = TextFormatAlign.CENTER;
			tip3.textRendererProperties.textFormat = tip3Fmt;
			tip3.width = this.width;
			tip3.y = 113;
			var tiptxt3:String = "";
			if(buyType==1)tiptxt3 = CJLang("XUNBAO_BUYNUM_TIP");
			else tiptxt3 = CJLang("DUOBAO_BUYNUM_TIP");
			var arrtiptxt3:Array = tiptxt3.split("N");
			tip3.text = arrtiptxt3[0] +"\n"+ arrtiptxt3[1];
//			tip3.text = "寻宝次数每日0点即刷新，请将购买的\n寻宝次数在当日用完以免造成损失";
			addChild(tip3);
			
			// 按钮 - 确认
			btnSure = new Button();
			btnSure.width = 60;
			btnSure.height = 22;
			btnSure.x = (width - btnSure.width) / 2;
			btnSure.y = height - btnSure.height - 12;
			btnSure.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			btnSure.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			btnSure.disabledSkin = new SImage(SApplication.assets.getTexture("common_anniu03new"));
			var fontBtn:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 11, 0xFFFEFD);
			btnSure.defaultLabelProperties.textFormat = fontBtn;
			btnSure.label = CJLang("BAG_EXPAND_BTN_NAME_SURE");
			addChild(btnSure);
			btnSure.addEventListener(starling.events.Event.TRIGGERED, buyClick);
			
			curNum = 1;
			flushTip();
		}
		
		//+号
		private function _addNumClick(e:Event):void
		{
			if(curNum < (vipBuyNum-buyNum))
			{
				curNum ++;
			}
			flushTip();
		}
		
		//-号
		private function _subNumClick(e:Event):void
		{
			if(curNum > 1)
			{
				curNum --;
			}
			flushTip();
		}
		
		//max
		private function _maxNumClick(e:Event):void
		{
			curNum = vipBuyNum-buyNum;
			flushTip();
		}
		
		private function flushTip():void
		{
			_tiCombineNum.text = curNum+"";
			var numtip:String = CJLang("BAOWU_BUYNUM_TIP");
			tip1.text = numtip.replace("{value}", (vipBuyNum-buyNum-curNum));//"今日还可购买"+(vipBuyNum-buyNum-curNum) + "次";
			
			var costtip:String = CJLang("BAOWU_BUYNUM_COSTTIP");
			tip2.text = costtip.replace("{value}", getBuyNumCost());// "总计消费"+getBuyNumCost()+"元宝";
		}
		
		//获得该用户当前次购买  1 寻宝/ 2夺宝 花费元宝数
		private function getBuyNumCost():int
		{
			var cost:int=0; //如果找不到次数对应的消费金额，可能当前次数溢出配置表，取最贵的消费金额
			for(var i:int=1; i<=curNum;  i++)
			{
				if(buyType==1){
					cost += CJDataOfDuoBao.o.getTreasureFindCostByCount(buyNum + i);
				}else{
					cost += CJDataOfDuoBao.o.getTreasureLootCostByCount(buyNum + i);
				}
			}
			return cost;
		}
		
		private function buyClick(e:Event):void
		{
			buynumtip = curNum;
			if(buyType==1)SocketManager.o.callwithRtn(ConstNetCommand.CS_XUNBAO_ADDNUM, funcHandle, false, curNum);
			else SocketManager.o.callwithRtn(ConstNetCommand.CS_DUOBAO_ADDNUM, funcHandle, false, curNum);
			
			this.dispose();
		}
		
		/** 关闭提示 **/
		private function _touchClosePrompt(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if (touch == null)
				return;
			
			if (touch.phase != TouchPhase.ENDED)
				return;
			
			this.dispose();
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			bamask.removeEventListener(TouchEvent.TOUCH, _touchClosePrompt);
			if(btnSub != null)btnSub.addEventListener(starling.events.Event.TRIGGERED, _subNumClick);
			if(btnAdd != null)btnAdd.addEventListener(starling.events.Event.TRIGGERED, _addNumClick);
			if(btnSure != null)btnSure.removeEventListener(starling.events.Event.TRIGGERED, buyClick);
			if(btnMax != null)btnMax.addEventListener(starling.events.Event.TRIGGERED, _maxNumClick);
			
			while(numChildren)removeChildAt(0);
		}
	}
}