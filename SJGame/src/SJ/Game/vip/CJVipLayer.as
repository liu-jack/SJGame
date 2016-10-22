package SJ.Game.vip
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketCommand_vip;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.config.CJDataOfVipExpSetting;
	import SJ.Game.data.config.CJDataOfVipFuncSetting;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.data.json.Json_vip_exp_setting;
	import SJ.Game.data.json.Json_vip_function_setting;
	import SJ.Game.lang.CJLang;
	import SJ.Game.task.util.CJTaskLabel;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SAtlasLabel;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.ProgressBar;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	
	public class CJVipLayer extends SLayer
	{
		private var _imgBigVip:ImageLoader;
		/**  当前vip大图标 **/
		public function get imgBigVip():ImageLoader
		{
			return _imgBigVip;
		}
		/** @private **/
		public function set imgBigVip(value:ImageLoader):void
		{
			_imgBigVip = value;
		}
		private var _labelNeedMoreGold:Label;
		/**  再充值XXX元宝 **/
		public function get labelNeedMoreGold():Label
		{
			return _labelNeedMoreGold;
		}
		/** @private **/
		public function set labelNeedMoreGold(value:Label):void
		{
			_labelNeedMoreGold = value;
		}
		private var _imgTinyVip:ImageLoader;
		/**  下级vip小图标 **/
		public function get imgTinyVip():ImageLoader
		{
			return _imgTinyVip;
		}
		/** @private **/
		public function set imgTinyVip(value:ImageLoader):void
		{
			_imgTinyVip = value;
		}
		private var _btnPay:Button;
		/**  充值按钮 **/
		public function get btnPay():Button
		{
			return _btnPay;
		}
		/** @private **/
		public function set btnPay(value:Button):void
		{
			_btnPay = value;
		}
		private var _expProgressBar:ProgressBar;
		/**  经验条伸缩部分 **/
		public function get expProgressBar():ProgressBar
		{
			return _expProgressBar;
		}
		/** @private **/
		public function set expProgressBar(value:ProgressBar):void
		{
			_expProgressBar = value;
		}
		private var _labelvipexp:Label;
		/**  vip经验值文字 **/
		public function get labelvipexp():Label
		{
			return _labelvipexp;
		}
		/** @private **/
		public function set labelvipexp(value:Label):void
		{
			_labelvipexp = value;
		}
		private var _labelGetAwardDes:Label;
		/**  vip说明文字 **/
		public function get labelGetAwardDes():Label
		{
			return _labelGetAwardDes;
		}
		/** @private **/
		public function set labelGetAwardDes(value:Label):void
		{
			_labelGetAwardDes = value;
		}
		private var _labelGiftDes:Label;
		/**  vip奖励描述 **/
		public function get labelGiftDes():Label
		{
			return _labelGiftDes;
		}
		/** @private **/
		public function set labelGiftDes(value:Label):void
		{
			_labelGiftDes = value;
		}
		private var _btnGetAward:Button;
		/**  领取奖励按钮 **/
		public function get btnGetAward():Button
		{
			return _btnGetAward;
		}
		/** @private **/
		public function set btnGetAward(value:Button):void
		{
			_btnGetAward = value;
		}
		private var _btnVipInfoShow:Button;
		/**  VIP特权一览 **/
		public function get btnVipInfoShow():Button
		{
			return _btnVipInfoShow;
		}
		/** @private **/
		public function set btnVipInfoShow(value:Button):void
		{
			_btnVipInfoShow = value;
		}
		private var _labelCurVipTitle:Label;
		/**  |VIP拥有的特权|文字 **/
		public function get labelCurVipTitle():Label
		{
			return _labelCurVipTitle;
		}
		/** @private **/
		public function set labelCurVipTitle(value:Label):void
		{
			_labelCurVipTitle = value;
		}
		private var _labelVipDes:Label;
		/**  当前vip拥有特权描述 **/
		public function get labelVipDes():Label
		{
			return _labelVipDes;
		}
		/** @private **/
		public function set labelVipDes(value:Label):void
		{
			_labelVipDes = value;
		}
		private var _btnClose:Button;
		/**  关闭按钮 **/
		public function get btnClose():Button
		{
			return _btnClose;
		}
		/** @private **/
		public function set btnClose(value:Button):void
		{
			_btnClose = value;
		}

		private var _davipLabel:SAtlasLabel;
		private var _xiaovipLabel:SAtlasLabel;
		
		private var _getAwardDes:CJTaskLabel;
		private var _imgIsMaxVipLevel:ImageLoader;
		
		// 特权详细描述
		private var _vipDesPanel:CJVipDesPanel;
		
		public function CJVipLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			width = SApplicationConfig.o.stageWidth;
			height = SApplicationConfig.o.stageHeight;
			
			// 关闭按钮
			btnClose.addEventListener(Event.TRIGGERED, function(e:Event):void{
				SApplication.moduleManager.exitModule("CJVipModule");
			});
			
			btnPay.addEventListener(Event.TRIGGERED, function(e:Event):void{
				SApplication.moduleManager.exitModule("CJVipModule");
				// 进入充值模块
				SApplication.moduleManager.enterModule("CJRechargeModule");
			});
			
			
			// 提示再充值xxx元宝 底图
			_imgIsMaxVipLevel = new ImageLoader;
			_imgIsMaxVipLevel.x = 100;
			_imgIsMaxVipLevel.y = 60;
			addChild(_imgIsMaxVipLevel);
			// 小vip图片
			addChild(imgTinyVip);
			
			// vip奖励描述
			labelGiftDes.textRendererProperties.multiline = true; // 可显示多行
			labelGiftDes.textRendererProperties.wordWrap = true; // 可自动换行
			
//			// 领取奖励按钮
//			btnGetAward.defaultLabelProperties.textFormat = ConstTextFormat.textformatkhakisize11;
//			btnGetAward.label = CJLang("vip_receive");
			btnGetAward.visible = false;
			
			// vip特权一览
			btnVipInfoShow.defaultLabelProperties.textFormat = ConstTextFormat.textformatkhakisize11;
			btnVipInfoShow.label = CJLang("vip_privileges_view");
			btnVipInfoShow.addEventListener(Event.TRIGGERED, function(e:Event):void{
				SApplication.moduleManager.enterModule("CJVipPrivilegeModule");
			});
			
			// 奖励提示上部的小提示
			_getAwardDes = new CJTaskLabel();
			_getAwardDes.fontSize = 10;
			_getAwardDes.x = labelGetAwardDes.x;
			_getAwardDes.y = labelGetAwardDes.y;
			_getAwardDes.width = labelGetAwardDes.width;
			_getAwardDes.height = labelGetAwardDes.height;
			addChild(_getAwardDes);
			
			// 特权描述
//			labelVipDes.textRendererProperties.textFormat = ConstTextFormat.viptextformatblack;
//			labelVipDes.textRendererProperties.multiline = true; // 可显示多行
//			labelVipDes.textRendererProperties.wordWrap = true; // 可自动换行
			_vipDesPanel = new CJVipDesPanel;
			_vipDesPanel.x = labelVipDes.x;
			_vipDesPanel.y = labelVipDes.y;
			_vipDesPanel.width = labelVipDes.width;
			_vipDesPanel.height = labelVipDes.height - 2;
			addChild(_vipDesPanel);
			
			
			var vipdazidi:SImage = new SImage(SApplication.assets.getTexture("vip_VIPdazidi"));
			vipdazidi.x = 17;
			vipdazidi.y = 57;
			this.addChildAt(vipdazidi, 0);
			
			var textureBg:Texture = SApplication.assets.getTexture("vip_xiaokuang");
			var bgScaleRange:Rectangle = new Rectangle(15, 15, 1, 1);
			var bgTexture:Scale9Textures = new Scale9Textures(textureBg, bgScaleRange);
			var bgImage1:Scale9Image = new Scale9Image(bgTexture);
			bgImage1.x = 92;
			bgImage1.y = 43;
			bgImage1.width = 215;
			bgImage1.height = 78;
			this.addChildAt(bgImage1, 0);
			
			var bgImage2:Scale9Image = new Scale9Image(bgTexture);
			bgImage2.x = 27;
			bgImage2.y = 162;
			bgImage2.width = 279;
			bgImage2.height = 68;
			this.addChildAt(bgImage2, 0);
			
			var bgImage3:Scale9Image = new Scale9Image(bgTexture);
			bgImage3.x = 27;
			bgImage3.y = 233;
			bgImage3.width = 279;
			bgImage3.height = 55;
			this.addChildAt(bgImage3, 0);
			
			var textureBg1:Texture = SApplication.assets.getTexture("vip_wenzikuang");
			var bgScaleRange1:Rectangle = new Rectangle(18, 18, 26, 26);
			var bgTexture1:Scale9Textures = new Scale9Textures(textureBg1, bgScaleRange1);
			var bgImage4:Scale9Image = new Scale9Image(bgTexture1);
			bgImage4.x = 317;
			bgImage4.y = 43;
			bgImage4.width = 145;
			bgImage4.height = 247;
			this.addChildAt(bgImage4, 0);
			
			var textureLine:Texture = SApplication.assets.getTexture("kfcontend_kuang");
			var lineScaleRange:Rectangle = new Rectangle(110, 25, 1, 1);
			var lineTexture:Scale9Textures = new Scale9Textures(textureLine, lineScaleRange);
			var imgLine:Scale9Image = new Scale9Image(lineTexture);
			imgLine.x = 4;
			imgLine.y = 12;
			imgLine.width = 470;
			imgLine.height = 287;
			this.addChildAt(imgLine, 0);
					
			var bg2:Scale3Image = new Scale3Image(new Scale3Textures(SApplication.assets.getTexture("vip_tequandi") ,15 ,1));
			bg2.x = 324;
			bg2.y = 50;
			bg2.width = 130;
			this.addChildAt(bg2, 0);
			
			var bg1:SImage = new SImage(SApplication.assets.getTexture("vip_di"));
			bg1.x = 324;
			bg1.y = 50;
			bg1.scaleX = 4;
			bg1.scaleY = 4;
			this.addChildAt(bg1, 0);
			
			for(var x:int = 0; x <6; x++)
			{
				for(var y:int = 0; y <3; y++)
				{
					var bg:SImage = new SImage(SApplication.assets.getTexture("vip_bg"));
					bg.x = 10 + x * (75 * 1.03 - 1);
					bg.y = 20 + y * (75 * 1.23 - 1);
					bg.scaleX = 1.03;
					bg.scaleY = 1.23;
					this.addChildAt(bg, 0);
				}
			}
			
			_davipLabel = new SAtlasLabel();
			_davipLabel.hAlign = HAlign.LEFT;
			_davipLabel.registerChars("0123456789", "vip_davip", SApplication.assets);
			_davipLabel.space_x = -4;
			_davipLabel.x = imgBigVip.x + 40;
			_davipLabel.y = imgBigVip.y + 13;
			this.addChild(_davipLabel);
			
			imgTinyVip.x = imgTinyVip.x - 3;
			_xiaovipLabel = new SAtlasLabel();
			_xiaovipLabel.hAlign = HAlign.LEFT;
			_xiaovipLabel.registerChars("0123456789", "vip_xiaovip", SApplication.assets);
			_xiaovipLabel.space_x = -1;
			_xiaovipLabel.x = imgTinyVip.x + 30;
			_xiaovipLabel.y = imgTinyVip.y + 8;
			this.addChild(_xiaovipLabel);
			
			var Label1:Label = new Label();
			Label1.text = CJLang("vip_level_desc");
			Label1.x = 34;
			Label1.y = 252;
			Label1.textRendererFactory = textRender.glowTextRender;
			Label1.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xFFFF00);
			this.addChild(Label1);
			
			function __loadVipInfoComplete(message:SocketMessage):void
			{
				var rtnObject:Object = message.retparams;
				
				// 更新vip经验信息
				CJDataManager.o.DataOfVIP.vipExp = int(rtnObject[0]);
				
				// 更新界面
				_updateLayer();
			}
			
			// 重新获取vip信息
			SocketCommand_vip.get_info(__loadVipInfoComplete)
		}
		
		private function _updateLayer():void
		{
			// 获取当前玩家信息
			var vipLevel:uint = CJDataManager.o.DataOfRole.vipLevel;
			// 当前经验VIP
			var vipExp:uint = CJDataManager.o.DataOfVIP.vipExp;
			// 配置vip最大等级
			var maxVipLevel:uint = uint(CJDataOfGlobalConfigProperty.o.getData("VIP_MAX_LEVEL"));
			// 判断vip等级是否有效
			vipLevel = vipLevel >= maxVipLevel ? maxVipLevel : vipLevel;
			
			if (vipLevel == maxVipLevel)
			{
				// vip满级
				_imgIsMaxVipLevel.source = SApplication.assets.getTexture("vip_vipmanji");
				imgTinyVip.visible = false;
				labelNeedMoreGold.visible = false;
			}
			else
			{
				// vip
				_imgIsMaxVipLevel.source = SApplication.assets.getTexture("vip_chongzhiziti");
				imgTinyVip.visible = true;
				labelNeedMoreGold.visible = true;
			}
			
			
			
			// vip Json 数据
			var jsVip:Json_vip_function_setting = CJDataOfVipFuncSetting.o.getData(String(vipLevel));
			
			// 当前经验
			var curExp:uint = CJDataManager.o.DataOfVIP.vipExp;
			// 当前vip等级的最大经验值
			var maxExp:uint = CJDataOfVipExpSetting.o.getData(String(vipLevel)).vipexp;
			
			// 当前vip大图标
			imgBigVip.source = SApplication.assets.getTexture("vip_davip");
			_davipLabel.text = String(vipLevel);
			
			// 计算再充值多少元宝可升级到下一VIP等级
			var expJs:Json_vip_exp_setting = CJDataOfVipExpSetting.o.getData(String(vipLevel));
			if (null != expJs)
			{
				var exp:int = expJs.vipexp;
				if (vipExp < exp) // 当前经验 < 升到下级经验
				{
					// 相差的经验
					var value:int = exp - vipExp;
					// 充值N元宝可达到该经验
					var gold:int = value / jsVip.ratio;
					// 再充值XXX元宝
					labelNeedMoreGold.text = String(gold);
				}
			}
			
			
			// vip经验条进度
			expProgressBar.minimum = 0;
			expProgressBar.maximum = maxExp;
			expProgressBar.value = curExp;
			// vip经验值文字
			labelvipexp.text = curExp + "/" + maxExp;
			// 下级vip小图标
			// 判断下级viplevel
			var nextVipLevel:uint = vipLevel+1 >= maxVipLevel ? maxVipLevel : vipLevel+1;
			imgTinyVip.source = SApplication.assets.getTexture("vip_xiaovip");
			_xiaovipLabel.text = String(nextVipLevel);
			
			// 奖励提示上部的小提示
			_getAwardDes.text = CJLang("vip_everyday_receive", {"viplevel":vipLevel});
//			labelGetAwardDes.text = CJLang("vip_everyday_receive", {"viplevel":vipLevel});
			// VIP礼包奖励展示
			// 获取道具信息
			var itemTemplate:Json_item_setting = CJDataOfItemProperty.o.getTemplate(jsVip.itemid);
			labelGiftDes.text = null;
			if (null != itemTemplate)
				labelGiftDes.text = CJLang(itemTemplate.description);
			
			// |VIP拥有的特权|文字
//			var strVL:uint = vipLevel == 0 ? 1 : vipLevel;
			labelCurVipTitle.text = CJLang("vip_privileges_have", {"viplevel":vipLevel});
		}
		
	}
}