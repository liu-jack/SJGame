package SJ.Game.fuben
{
	import SJ.Common.Constants.ConstDynamic;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.bag.CJBagItem;
	import SJ.Game.controls.CJButtonUtil;
	import SJ.Game.controls.CJItemUtil;
	import SJ.Game.data.config.CJDataOfAwardBoxProperty;
	import SJ.Game.data.config.CJDataOfFubenProperty;
	import SJ.Game.data.config.CJDataOfGuankaProperty;
	import SJ.Game.data.json.Json_fuben_config;
	import SJ.Game.data.json.Json_fuben_guanka_config;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJLayerRandomBackGround;
	import SJ.Game.layer.CJMessageBox;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.feathersextends.TextFieldTextRendererEx;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.core.ITextRenderer;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 *  副本进入显示界面
	 * @author yongjun
	 * 
	 */
	public class CJFubenEnterLayer extends SLayer
	{
		private var _bgFrame:Scale9Image;
		private var _guankadesc:Label;
		private var _labellevel:Label;
		private var _labeldrop:Label;
		private var _btnClose:Button;
		private var _huntBtn:Button;
		private var _enterBtn:Button;
		//挂机界面
		private var _hangupLayer:CJFubenHangLayer;
		//副本ID
		private var _fid:int
		//关卡ID
		private var _gid:int
		//关卡的第一次战斗ID
		private var _zid:int
		//进入的关卡数据
		public function CJFubenEnterLayer()
		{
			super();
		}
		public function get guankadesc():Label
		{
			return this._guankadesc;
		}
		public function set guankadesc(label:Label):void
		{
			this._guankadesc = label;
		}
		public function get labellevel():Label
		{
			return this._labellevel;
		}
		public function set labellevel(label:Label):void
		{
			_labellevel = label
		}
		public function get labeldrop():Label
		{
			return this._labeldrop;
		}
		public function set labeldrop(label:Label):void
		{
			_labeldrop = label;
		}
		public function set vitlabel(label:Label):void
		{
			this._labeldrop = label;
		}
		public function get btnClose():Button
		{
			return _btnClose;
		}
		public function set btnClose(value:Button):void
		{
			_btnClose = value;
		}
		override protected function initialize():void
		{
			_drawContent();
		}
		/**
		 * 绘制显示内容 
		 * 
		 */
		private function _drawContent():void
		{
			//界面底图
			this._bgFrame= new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_erjitanchuang"),new Rectangle(16, 16, 1, 1)));
			this._bgFrame.width = 324;
			this._bgFrame.height = 203;
			this.addChildAt(this._bgFrame,0);
			//设置整个节目大小，
			this.setSize(this._bgFrame.width,this._bgFrame.height);
			//关卡描述背景
			var decsBg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_tiptankuang"),new Rectangle(8,8,2,2)));
			decsBg.width = 144;
			decsBg.height = 43;
			decsBg.x = 9;
			decsBg.y = 20;
			this.addChildAt(decsBg,1);
			//困难程度描述
			var levelBg:SImage = new SImage(SApplication.assets.getTexture("fuben_tiao"));
			levelBg.x = 188;
			levelBg.y = 14;
			this.addChildAt(levelBg,2);
			
			//关闭按钮
			_btnClose.defaultSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			_btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			_btnClose.addEventListener(Event.TRIGGERED,exit);
			_btnClose.x -=13;
			_btnClose.y +=2; 
			//挂机按钮
			_huntBtn = CJButtonUtil.createCommonButton(CJLang("FUBEN_GUAJIA"));
			_huntBtn.visible = false;
//			_huntBtn.isEnabled = false;
			_huntBtn.isSelected = false;
			_huntBtn.addEventListener(Event.TRIGGERED,function(e:*):void
			{
				CJMessageBox(CJLang("FUBEN_GUAJI_UNOPEN"))
				return;
				var hangUpXml:XML = AssetManagerUtil.o.getObject("fubenHangLayout.sxml") as XML;
				_hangupLayer = SFeatherControlUtils.o.genLayoutFromXML(hangUpXml,CJFubenHangLayer) as CJFubenHangLayer;
				_hangupLayer.labellevel.text = _labellevel.text;
				_hangupLayer.guankadesc.text = CJLang("FUBEN_GUAJIA");
				CJLayerManager.o.addModuleLayer(_hangupLayer);
			});
			
			_huntBtn.x = 62;
			_huntBtn.y = 160;
			this.addChild(_huntBtn);
			//进入战斗
			_enterBtn = CJButtonUtil.createCommonButton(CJLang("FUBEN_ENTER"));
			_enterBtn.addEventListener(Event.TRIGGERED,function(e:*):void
			{
				SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadAssistantInfo);
				ConstDynamic.isEnterFromFuben = ConstDynamic.ENTER_FROM_FB;
				CJFbUtil.enterFb()
			});
			_enterBtn.x = 119;
			_enterBtn.y = 160;
			_enterBtn.visible = false;
			this.addChild(_enterBtn);
			
			_labeldrop.text = CJLang("FUBEN_DIAOLUO");
			_labeldrop.textRendererProperties.textFormat = ConstTextFormat.textformat;
			
			_labellevel.textRendererProperties.textFormat = ConstTextFormat.fubenDescformat;
			_guankadesc.textRendererFactory = function ():ITextRenderer
			{
				var _htmltextRender:TextFieldTextRendererEx;
				_htmltextRender = new TextFieldTextRendererEx()
				_htmltextRender.isHTML = true;
				_htmltextRender.wordWrap = true;
				_htmltextRender.textFormat = ConstTextFormat.fubenDescformat;
				return _htmltextRender
			}
			var guankaProperty:Json_fuben_guanka_config = CJDataOfGuankaProperty.o.getPropertyById(_gid);
			var leveltext:String
			if(int(guankaProperty.level) == 0)
			{
				leveltext = CJLang("FUBEN_EASY");
			}
			else
			{
				leveltext = CJLang("FUBEN_HARD");
			}
			//难易程度
			_labellevel.text = leveltext;
			//关卡描述
			_guankadesc.text = CJLang(guankaProperty.desc);
			//关卡第一场战斗ID
			_zid = guankaProperty.zid1;
			//显示星星
//			for(var i:int =0;i<3;i++)
//			{
//				var startexture:String
//				if(int(guankaProperty.level) == 1)
//				{
//					startexture = "common_xingxing1";
//				}
//				else
//				{	
//					i>0? startexture = "common_xingxing1":startexture = "common_xingxing2";
//				}
//				var starImg:SImage = new SImage(SApplication.assets.getTexture(startexture));
//				
//				starImg.x = 253+i*(15+5);
//				starImg.y = 35;
//				
//				this.addChild(starImg);
//			}
			update(_fid);
			CJLayerRandomBackGround.Close();
		}
		
		/**
		 * 加载服务器助战好友数据 
		 * @param e Event
		 * 
		 */		
		private function _onloadAssistantInfo(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() == ConstNetCommand.CS_FUBEN_GET_INVITE_HEROS)
			{
				SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadAssistantInfo);
				if (message.retcode == 0)
				{
					exit();
				}
			}
		}
//		/**
//		 * 进入关卡服务器返回 
//		 * @param e
//		 * 
//		 */		
//		private function enterGuankaHandler(e:Event):void
//		{
//			var message:SocketMessage = e.data as SocketMessage;
//			if (message.getCommand() == ConstNetCommand.CS_FUBEN_ENTERGUANKA)
//			{
//				switch(message.retcode)
//				{
//					case 0:
//						var rtnObject:Object = message.retparams;
//						exit();
//						SApplication.moduleManager.exitModule("CJWorldModule");
//						SApplication.moduleManager.exitModule("CJFubenModule");
//						SApplication.moduleManager.enterModule("CJFubenBattleBaseModule",{"battletype":1,"battleid":_zid,"gid":rtnObject.gid,"fid":rtnObject.fid});
//						break;
//					case 1:
//						CJMessageBox(CJLang("FUBEN_ENTER_UNLEVEL"));
//						break;
//					case 2:
//						CJMessageBox(CJLang("FUBEN_ENTER_UNTASK"));
//						break;
//					case 3:
//						CJMessageBox(CJLang("FUBEN_ENTER_UNGUANKAID"));
//						break;
//					case 4:
//						CJMessageBox(CJLang("FUBEN_ENTER_NOVIT"));
//						break;
//				}
//
//			}
//		}
		/**
		 *设置界面数据，并更新 
		 * @param d
		 * 
		 */		
		public function set data(d:Object):void
		{
			_fid = d.fid;
			//当前关卡ID
			_gid = d.gid
			this.invalidate();
		}
		
		/**
		 * 
		 * 更新掉落信息
		 */
		private function update(fid:int):void
		{
			clearBagItem();
			//显示掉落道具图标
			var guankaProperty:Json_fuben_config = CJDataOfFubenProperty.o.getPropertyById(fid);
			var dropItems:Array = CJDataOfAwardBoxProperty.o.getFiveAward(int(guankaProperty.dropitems))
			for(var i:String in dropItems)
			{
				var item:CJBagItem = new CJBagItem
				item.setBagGoodsItemByTmplId(dropItems[i]);
				item.addEventListener(TouchEvent.TOUCH,_touchHandler);
				item.x = 15+int(i)*(55+5);
				item.y = 87;
				var nameLabel:Label = new Label;
				nameLabel.textRendererProperties.textFormat = ConstTextFormat.fubentextformat;
				nameLabel.text = CJLang(item.templData.itemname);
				nameLabel.x = item.x;
				nameLabel.width = item.imageGoods.width;
				nameLabel.y = item.y + item.imageGoods.height + 4;
				this.addChild(item);
				this.addChild(nameLabel);
			}
		}
		
		private function _touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this,TouchPhase.BEGAN)
			if(touch)
			{
				var bagItem:CJBagItem = e.currentTarget as CJBagItem;
					
//				var tipsLayer:CJItemTooltip = new CJItemTooltip;
//				tipsLayer.setItemTemplateIdAndRefresh(bagItem.templateId)
//				CJLayerManager.o.addModuleLayer(tipsLayer);
				CJItemUtil.showItemTooltipsWithTemplateId(bagItem.templateId);
			}
		}
		
		/**
		 * 清除掉落道具显示 
		 * 
		 */		
		private function clearBagItem():void
		{
			for(var i:int =0;i<this.numChildren;i++)
			{
				var item:DisplayObject = this.getChildAt(i);
				if(item is CJBagItem)
				{
					(item as CJBagItem).removeEventListener(TouchEvent.TOUCH,_touchHandler);
					(item as CJBagItem).dispose();
					(item as CJBagItem).removeFromParent(true);
				}
			}
		}
		
		/**
		 * 退出副本界面 
		 * 
		 */		
		public function exit(e:Event = null):void
		{
			this.btnClose.removeEventListener(Event.TRIGGERED,exit);
			this.clearBagItem();
			this.removeFromParent(true);
		}
	}
}