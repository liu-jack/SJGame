package SJ.Game.NPCDialog
{	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstResource;
	import SJ.Common.global.textRender;
	import SJ.Game.controls.CJItemUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHeroList;
	import SJ.Game.data.CJDataOfTask;
	import SJ.Game.data.CJDataOfTaskList;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.lang.CJLang;
	import SJ.Game.mainUI.CJGuideArrow;
	import SJ.Game.task.CJTaskChecker;
	import SJ.Game.task.util.CJTaskLabel;
	
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	import engine_starling.display.SScale3Plane;
	import engine_starling.utils.AssetManagerUtil;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class CJNPCDialogLayer extends SLayer
	{
		//关闭按钮
		private var _btnClose:Button;
		//头像
		private var _imagePortrait:ImageLoader;
		
		//缩放后的半身像大小
		private var _PORTRAIT_WIDTH:Number = 140;
		private var _PORTRAIT_HEIGHT:Number = 160;
		//半身像的位置
		private var _PORTRAIT_POSX:Number = 210;
		private var _PORTRAIT_POSY:Number = 175;
		
		//姓名label
		private var _labelName:Label;
		//台词内容label
		private var _labelContent:CJTaskLabel;
		//功能点及奖励layer
		private var _layerActionAndReward:SLayer;
		//功能点面板
		private var _layerActions:SLayer;
		//奖励面板
		private var _layerReward:SLayer;
		//"奖励"label
		private var _labelRewardTitle:Label;
		//"经验"label
		private var _labelRewardExpTitle:Label;
		//经验值label
		private var _labelRewardExp:Label;
		//"银两"label
		private var _labelRewardYinliangTitle:Label;
		//银两数label
		private var _labelRewardYinliang:Label;
		//top 渐变效果条
		private var _imageTopLine:ImageLoader;
		//文本档
		private var _imageContentBack:SScale3Plane;
		//主layer
		private var _layerMain:SLayer;
		
		private var _arrRewardItemView:Array = new Array;
		private var _arrActionView:Array = new Array;
		private var _delegate:Object = null;
		private var _params:CJNPCDialogContentObject = null;

//		private var _tipTemp:CJItemTooltip;
		
		private var _clickButton:Button;
		//指引箭头
		private var _arrow:CJGuideArrow;
		private var _heroList:CJDataOfHeroList;
		
		public function CJNPCDialogLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			_heroList = CJDataManager.o.DataOfHeroList;
			
			_btnClose.addEventListener(starling.events.Event.TRIGGERED,function(e:*):void{
				onClose(null);
			});
			
			var bgWrapDec:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_dinewzhezhao") , new Rectangle(45 ,45 , 1, 1)));
			bgWrapDec.width = 350;
			bgWrapDec.height = 193;
			bgWrapDec.x = 74;
			bgWrapDec.y = 87;
			this.addChildAt(bgWrapDec , 0);
			
			var bgWrap:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_dinew") , new Rectangle(1 ,1 , 1, 1)));
			bgWrap.width = 350;
			bgWrap.height = 193;
			bgWrap.x = 74;
			bgWrap.y = 87;
			this.addChildAt(bgWrap , 0);
			
			_labelName.textRendererProperties.textFormat = new TextFormat("宋体", null, 0xffffff, null, null, null, null, null, TextFormatAlign.LEFT);
			_labelName.textRendererFactory = textRender.htmlTextRender;
			
			
			_labelContent = new CJTaskLabel();
			_labelContent.wrap = true;
			_labelContent.width = 170;
			_labelContent.height = 100;
			_labelContent.text = "";
			_labelContent.fontFamily = "黑体";
			_labelContent.fontSize = 10;
			_labelContent.fontColor = 0xffffff;
			_labelContent.x = 150;
			_labelContent.y = 40;
			this._layerMain.addChild(_labelContent);

			this.labelRewardTitle.textRendererProperties.textFormat = new TextFormat("宋体", 10, 0xfde647, null, null, null, null, null, TextFormatAlign.LEFT);
			this.labelRewardExpTitle.textRendererProperties.textFormat = new TextFormat("宋体", 10, 0xffffff, null, null, null, null, null, TextFormatAlign.LEFT);
			this.labelRewardExp.textRendererProperties.textFormat = new TextFormat("宋体", 10, 0xfde647, null, null, null, null, null, TextFormatAlign.LEFT);
			this.labelRewardYinliangTitle.textRendererProperties.textFormat = new TextFormat("宋体", 10, 0xffffff, null, null, null, null, null, TextFormatAlign.LEFT);
			this.labelRewardYinliang.textRendererProperties.textFormat = new TextFormat("宋体", 10, 0xfde647, null, null, null, null, null, TextFormatAlign.LEFT);
			
			var scale9Image_topBack:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("npcduihua_zhuangbeiqianghua_zhezhaodi",
				7, 7, 1, 1);
			scale9Image_topBack.x = 0;
			scale9Image_topBack.y = 0;
			scale9Image_topBack.width = 241;
			scale9Image_topBack.height = 24;
			
			var scale9Image_bottomBack:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_waikuangnew",
				15 , 15 , 1, 1);
			scale9Image_bottomBack.x = 0;
			scale9Image_bottomBack.y = 24;
			scale9Image_bottomBack.width = 350;
			scale9Image_bottomBack.height = 195;
			scale9Image_bottomBack.alpha = 0.9;
			
			this.layerMain.addChildAt(scale9Image_topBack, 0);
			this.layerMain.addChildAt(scale9Image_bottomBack, 0);
			
			this._clickButton.labelFactory = textRender.htmlTextRender;
			this._clickButton.addEventListener(Event.TRIGGERED, _actionClicked);
			this._clickButton.visible = false;
			
		}
		
		/**
		 * 绘制引导箭头
		 * 
		 */		
		private function _showArrow():void
		{
			var guideMinLv:int = int(CJDataOfGlobalConfigProperty.o.getData("GUIDE_MAX_LV"));
			
			if (int(_heroList.getMainHero().level) > guideMinLv)
			{
				return;
			}
			
			if (null == _arrow)
			{
				var dataTaskList:CJDataOfTaskList = CJDataManager.o.DataOfTaskList;
				var text:String = "";
				var dataTask:CJDataOfTask = dataTaskList.getCurrentMainTask();
				if (CJTaskChecker.isTaskCanReward(dataTask) == 1)
				{
					// 完成
					text = CJLang("GUIDE_GET_TASK_AWARD");
				}
				else if (CJTaskChecker.isTaskCanAccept(dataTask))
				{
					// 可接受
					text = CJLang("GUIDE_ACCEPT_TASK");
				}
				else
				{
					// 执行
					text = CJLang("GUIDE_ACTION");
				}
				
				_arrow = new CJGuideArrow(text);
				_arrow.width = 100;
				_arrow.height = 75;
				_arrow.x = clickButton.x - _arrow.width - 10 + (_arrow.width / 2);
				_arrow.y = clickButton.y + (_arrow.height / 2) - 18;
				_arrow.touchable = false;
				
				this.addChild(_arrow);
				if (true == _arrow.isAnimate)
				{
					Starling.juggler.add(_arrow);
				}
				
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_NPCDIALOG_GUID_SHOW);
			}
		}
		
		/**
		 * 移除引导箭头动画
		 * 
		 */
		private function _removeArrow():void
		{
			if (null != _arrow)
			{
				if (true == _arrow.isAnimate)
				{
					Starling.juggler.remove(_arrow);
				}
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_NPCDIALOG_GUID_HIDE);
			}
		}
		
		/**
		 * 更新UI
		 * @param 外部传进来的数据
		 * 
		 */	
		public function refreshWithParams(params:CJNPCDialogContentObject):void
		{
			var contentObject:CJNPCDialogContentObject = new CJNPCDialogContentObject();
			_params = params;
			
			var texture:Texture = SApplication.assets.getTexture(params.portraitResourceName);
			var region:Rectangle = SApplication.assets.getAtlasTextureRegion(params.portraitResourceName);
			
			if(texture)
			{
				var originalWidth:Number = texture.width;
				var originalHeight:Number = texture.height;
				
				_imagePortrait.source = texture;
				_imagePortrait.touchable = false;
				
				var ratioWidth:Number = _PORTRAIT_WIDTH / originalWidth ;
				var ratioHeight:Number =  _PORTRAIT_HEIGHT / originalHeight;
				
				var ratio:Number = Math.max(ratioWidth , ratioHeight);
				_imagePortrait.scaleX = _imagePortrait.scaleY = ratio;
				
				_imagePortrait.pivotX = region.width - texture.frame.x;
				_imagePortrait.pivotY = region.height - texture.frame.y;
				
				_imagePortrait.x = _PORTRAIT_POSX;
				_imagePortrait.y = _PORTRAIT_POSY;
			}

			_labelName.textRendererFactory = textRender.htmlTextRender;
			_labelName.text = params.npcName;
			_labelContent.text = params.content;
			
			_refreshRewardLayer(params);
			_refreshActions(params);
			
		}
		
		/**
		 * 更新奖励的物品
		 * @param 外部传进来的数据
		 * 
		 */		
		private function _refreshRewardLayer(params:CJNPCDialogContentObject):void
		{
			//更新奖励层
			if (params.rewardExp || params.rewardYinliang)
			{
				this._layerActionAndReward.visible = true;
				this._layerReward.visible = true;
				this._labelRewardTitle.visible = true;
				this._labelRewardExp.visible = true;
				this._labelRewardExpTitle.visible = true;
				this._labelRewardYinliang.visible = true;
				this._labelRewardYinliangTitle.visible = true;
				this._labelRewardTitle.text = CJLang("NPCDIALOG_REWARD");
				this._labelRewardExpTitle.text = CJLang("NPCDIALOG_EXP");
				this._labelRewardExp.text = "+" + String(params.rewardExp);
				this._labelRewardYinliangTitle.text = CJLang("NPCDIALOG_YINGLIANG");
				this._labelRewardYinliang.text = "+" + String(params.rewardYinliang);
				if(params.buttonText)
				{
					this._clickButton.label = params.buttonText;
					this._clickButton.visible = true;
					// 显示引导箭头
					_showArrow();
				}
				else
				{
					this._clickButton.visible = false;
				}
			}
			else
			{
				this._labelRewardTitle.visible = false;
				this._labelRewardExp.visible = false;
				this._labelRewardExpTitle.visible = false;
				this._labelRewardYinliang.visible = false;
				this._labelRewardYinliangTitle.visible = false;
			}
			
			//把旧的奖励显示删除
			for each (var bagItem:Button in _arrRewardItemView)
			{
				layerReward.removeChild(bagItem);	
			}
			if (params.rewardItemIdArray && 0 != params.rewardItemIdArray.length)
			{
				var arr_rewardList:Array = params.rewardItemIdArray as Array;
				var length:int = arr_rewardList.length;
				if (4 < length)
				{
					Assert(false,"length of rewadlist is more than 4");
				}
				_arrRewardItemView = new Array;
				
				for (var i:int = 0; i < arr_rewardList.length; i++)
				{
					var itemID:int = int(arr_rewardList[i]['id']);
					var num:int = int(arr_rewardList[i]['count']);
					var button_rewardItem:Button = new Button;
					var gap:Number = 56.0;
					var width:Number = 54.0;
					var height:Number = 54.0;
					button_rewardItem.x = 16 + i * gap;
					button_rewardItem.y = 0;
					button_rewardItem.width = width;
					button_rewardItem.height = height;
					button_rewardItem.name = String(itemID);
					var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResItemSetting) as Array;
					var resourceName:String = null;
					for(var j:int=0; j < obj.length; j++)
					{
						if  (itemID == int(obj[j]['id']))
						{
							resourceName = obj[j]['picture'];
							break;
						}
					}
					var s9imageBack:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_tubiaokuang1", 15, 15, 1, 1);
					s9imageBack.width = button_rewardItem.width;
					s9imageBack.height = button_rewardItem.height;
					layerReward.addChild(button_rewardItem);
					button_rewardItem.addChildAt(s9imageBack, 0);
					
					var imageItem:ImageLoader = new ImageLoader();
					imageItem.width = button_rewardItem.width - 10;
					imageItem.height = button_rewardItem.height - 10;
					imageItem.x = 5;
					imageItem.y = 3;
					imageItem.source = SApplication.assets.getTexture(resourceName);
					imageItem.maintainAspectRatio = false;
					button_rewardItem.addChild(imageItem);
					
					//大于1才显示多少个。
					if(num > 1)
					{
						var numLabel:Label = new Label();
						numLabel.text = ""+num;
						numLabel.x = button_rewardItem.width - 12;
						numLabel.y = button_rewardItem.height - 15;
						var tf:TextFormat = new TextFormat();
						tf.align = TextFormatAlign.RIGHT;
						tf.color = 0xFFFFFF;
						numLabel.textRendererProperties.textFormat = tf;
						button_rewardItem.addChild(numLabel);
					}
					
					button_rewardItem.addEventListener(Event.TRIGGERED , _tipClicked);
					_arrRewardItemView.push(button_rewardItem);
				}
			}
		}
		
		private function _tipClicked(e:Event):void
		{
			if(e.target && e.target is Button )
			{
//				if(_tipTemp == null)
//				{
//					_tipTemp = new CJItemTooltip();
//				}
//				_tipTemp = new CJItemTooltip();
//				_tipTemp.setItemTemplateIdAndRefresh(int((e.target as Button).name));
//				CJLayerManager.o.addModuleLayer(_tipTemp);
				
				CJItemUtil.showItemTooltipsWithTemplateId(int((e.target as Button).name));
			}
		}
	
		
		/**
		 * 更新功能点
		 * @param 外部传进来的数据
		 * 
		 */	
		private function _refreshActions(params:CJNPCDialogContentObject):void
		{
			if (params.NPCActionObjectArray && 0 != params.NPCActionObjectArray.length)
			{
				_layerActions.visible = true;
				var arr_actions:Array = params.NPCActionObjectArray as Array;
				for each (var subview:SLayer in _arrActionView)
				{
					_layerActions.removeChild(subview);
				}
				_arrActionView = new Array;
				
				var y:Number = 0;
				var gap:Number = 25;
				var width:Number = 244;
				var height:Number = 25;
				var x_icon:Number = 34;
				var y_icon:Number = 4;
				var width_icon:Number = 20;
				var height_icon:Number = 20;
				var x_label:Number = 56;
				var y_label:Number = 9;
				var width_label:Number = 320;
				var height_label:Number = 11;
				for (var i:int; i < arr_actions.length; i++)
				{
					var actionInfo:CJNPCDialogActionObject = arr_actions[i] as CJNPCDialogActionObject;
					var view_action:SLayer = new SLayer;
//					view_action.defaultSkin = new SImage(SApplication.assets.getTexture("npcduihua_duihuatiao"));
					view_action.x = 3;
					view_action.y = y + gap * i;
					view_action.width = width;
					view_action.height = height;
					//生成功能点描述
					var label_description:Label = new Label;
					label_description.textRendererFactory = textRender.htmlTextRender;
					label_description.x = x_label;
					label_description.y = y_label - 4;
					label_description.width = width_label;
					label_description.height = height_label;
					label_description.textRendererFactory = textRender.htmlTextRender
					label_description.text = actionInfo.actionName;
					label_description.textRendererProperties.textFormat = new TextFormat("Arial", 12, 0xffffff, null, null, null, null, null, TextFormatAlign.LEFT);
					label_description.textRendererProperties.wordWrap = true;
					view_action.addChild(label_description);
					//等级限制
					if(actionInfo.levelLimit)
					{
						label_description.text += actionInfo.levelLimit;
					}
					
					var iconType:int = int(actionInfo.specialIconType);
					//生成符号Icon
					var imageIcon:ImageLoader = new ImageLoader();
					var iconResource:String = null;
					switch (iconType)
					{
						case ConstNPCDialog.IconType_Tanhao_SHI:
							iconResource = "npcduihua_renwutanhao";
							break;
						case ConstNPCDialog.IconType_TanHao_xu:
							iconResource = "npcduihua_renwutanhao2";
							break;
						case ConstNPCDialog.IconType_Wenhao_SHI:
							iconResource = "npcduihua_renwuwenhao";
							break;
						case ConstNPCDialog.IconType_Wenhao_xu:
							iconResource = "npcduihua_renwuwenhao2";
							break;
						default:
							iconResource = "npcduihua_dian";
							break;
					}
					imageIcon.maintainAspectRatio = false;
					imageIcon.source = SApplication.assets.getTexture(iconResource);
					imageIcon.x = 43;
					imageIcon.y = -2;
					imageIcon.width = 14;
					imageIcon.height = 29;
					imageIcon.scaleX = imageIcon.scaleY = 0.9;
					view_action.addChild(imageIcon);
					
					if (ConstNPCDialog.IconType_Default == iconType)
					{
						imageIcon.x = 46;
						imageIcon.y = 12;
						imageIcon.width = 7;
						imageIcon.height = 7;
					}
					else
					{
						var imageBack:ImageLoader = new ImageLoader();
						imageBack.source = SApplication.assets.getTexture("npcduihua_duihuatiao");
						imageBack.x = 31;
						imageBack.y = 0;
						imageBack.width = 200;
						imageBack.height = 26;
						imageBack.maintainAspectRatio = false;
						view_action.addChildAt(imageBack, 0);
					}
					
					var buttonTemp:Button = new Button();
					buttonTemp.x = 0;
					buttonTemp.y = 0;
					buttonTemp.width = view_action.width;
					buttonTemp.height = view_action.height;
					view_action.addChild(buttonTemp);
					buttonTemp.addEventListener(Event.TRIGGERED, _actionClicked);
					_layerActions.addChild(view_action);
					_arrActionView.push(view_action);
				}
			}
			else
			{
				_layerActions.visible = false;
			}
		}
		
		/**
		 * 关闭对话框
		 * @param 事件
		 * 
		 */	
		private function onClose(params:Object):void
		{
			_params = null;
			
			// 移除引导箭头动画
			_removeArrow();
			
			SApplication.moduleManager.exitModule("CJNPCDialogModule");
		}
		
		/**
		 * 事件View被点击
		 * @param 外部传进来的数据
		 * 
		 */	
		private function _actionClicked(e:Event):void
		{
			var arr_actions:Array = _params.NPCActionObjectArray;
			if (arr_actions.length != 0)
			{
				var actionInfo:CJNPCDialogActionObject = arr_actions[0];
				var recallParams:Object = actionInfo.recallParams;
				if (null != recallParams)
				{
					CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_NPCDIALOG_ACTIONCLICKED, false, recallParams);
				}
			}
			// 移除引导箭头动画
			_removeArrow();
		}
		
		public function get layerMain():SLayer
		{
			return _layerMain;
		}
		
		public function set layerMain(value:SLayer):void
		{
			_layerMain = value;
		}
		
		public function get btnClose():Button
		{
			return _btnClose;
		}
		
		public function set btnClose(value:Button):void
		{
			_btnClose = value;
		}
		
		public function get imagePortrait():ImageLoader
		{
			return _imagePortrait;
		}
		
		public function set imagePortrait(value:ImageLoader):void
		{
			_imagePortrait = value;
		}
		
		public function get labelName():Label
		{
			return _labelName;
		}
		
		public function set labelName(value:Label):void
		{
			_labelName = value;
		}
		
		public function get labelContent():CJTaskLabel
		{
			return _labelContent;
		}
		
		public function set labelContent(value:CJTaskLabel):void
		{
			_labelContent = value;
		}
		
		public function get layerActionAndReward():SLayer
		{
			return _layerActionAndReward;
		}
		
		public function set layerActionAndReward(value:SLayer):void
		{
			_layerActionAndReward = value;
		}
		
		public function get layerActions():SLayer
		{
			return _layerActions;
		}
		
		public function set layerActions(value:SLayer):void
		{
			_layerActions = value;
		}
		
		public function get layerReward():SLayer
		{
			return _layerReward;
		}
		
		public function set layerReward(value:SLayer):void
		{
			_layerReward = value;
		}
		
		public function get labelRewardTitle():Label
		{
			return _labelRewardTitle;
		}
		
		public function set labelRewardTitle(value:Label):void
		{
			_labelRewardTitle = value;
		}
		
		public function get labelRewardExpTitle():Label
		{
			return _labelRewardExpTitle;
		}
		
		public function set labelRewardExpTitle(value:Label):void
		{
			_labelRewardExpTitle = value;
		}
		
		public function get labelRewardExp():Label
		{
			return _labelRewardExp;
		}
		
		public function set labelRewardExp(value:Label):void
		{
			_labelRewardExp = value;
		}
		
		public function get labelRewardYinliangTitle():Label
		{
			return _labelRewardYinliangTitle;
		}
		
		public function set labelRewardYinliangTitle(value:Label):void
		{
			_labelRewardYinliangTitle = value;
		}
		
		public function get labelRewardYinliang():Label
		{
			return _labelRewardYinliang;
		}
		
		public function set labelRewardYinliang(value:Label):void
		{
			_labelRewardYinliang = value;
		}
		
		public function get imageContentBack():SScale3Plane
		{
			return _imageContentBack;
		}
		
		public function set imageContentBack(value:SScale3Plane):void
		{
			_imageContentBack = value;
		}
		public function get imageTopLine():ImageLoader
		{
			return _imageTopLine;
		}
		
		public function set imageTopLine(value:ImageLoader):void
		{
			_imageTopLine = value;
		}

		public function get clickButton():Button
		{
			return _clickButton;
		}

		public function set clickButton(value:Button):void
		{
			_clickButton = value;
		}

	}
}