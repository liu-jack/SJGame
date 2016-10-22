package SJ.Game.jewelCombine
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstJewelCombine;
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_item;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.activity.CJActivityEventKey;
	import SJ.Game.controls.CJFlyWordsUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class CJJewelCombineOneKeyLayer extends SLayer
	{
		/**宝石一键合成说明 */
		private var _labTipTitle:Label;
		/**确定按钮*/
		private var _btnConfirm:Button;
		/**关闭按钮*/
		private var _btnClose:Button;
		/**四级宝石文本 */
		private var _labJewelLevel4:Label;
		/**五级宝石文本 */
		private var _labJewelLevel5:Label;
		/**六级宝石文本 */
		private var _labJewelLevel6:Label;
		/**七级宝石文本 */
		private var _labJewelLevel7:Label;
		/**八级宝石文本 */
		private var _labJewelLevel8:Label;
		/**九级宝石文本 */
		private var _labJewelLevel9:Label;
		/**十级宝石文本 */
		private var _labJewelLevel10:Label;
		/**十一级宝石文本 */
		private var _labJewelLevel11:Label;
		/**十二级宝石文本 */
		private var _labJewelLevel12:Label;
//		/**默认第一个选中的宝石等级按钮 */
//		private var _btnDefaultSeclected:Button;
		/**初始化上次选中的按钮*/
		private var _oldBtn:Button = null;
		/**当前选中的等级*/
		private var _currentSelectedLevel:int;
		/**返回的一键合成成功的宝石的数据*/
		private var _retResult:Object;
		/**一键合成返回状态*/
		private var _retState:int;
		/**可点击背景*/
		private var _quad:Quad;
		/**一键合成需要的玩家的vip等级*/
		private var _needVipLevel:int;
		public function CJJewelCombineOneKeyLayer()
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
//			_currentSelectedLevel = 4;
			_labTipTitle.text = CJLang("JEWEL_COMBINE_ONE_KEY_TIP_TITLE");
			_btnConfirm.label = CJLang("JEWEL_CONFIRM");
			//设置字体格式
			var fontFormat:TextFormat = new TextFormat( "Arial", 10, 0x74B02B,null,null,null,null,null,TextFormatAlign.CENTER);
			_labTipTitle.textRendererProperties.textFormat = fontFormat;
			
			fontFormat = new TextFormat( "Arial", 12, 0xEDF1C2,null,null,null,null,null,TextFormatAlign.CENTER);
			_btnConfirm.defaultLabelProperties.textFormat = fontFormat;
			
			fontFormat = new TextFormat( "Arial", 10, 0xFFFFFF);
			
			//设置可选择宝石等级的文本
			var jewelLevelLabels:Vector.<Label> = new Vector.<Label>(ConstJewelCombine.JEWEL_COMBINE_ONE_KEY_SELECT_LVL_NUM);
			for(var i:uint = 0; i < jewelLevelLabels.length; i++)
			{
				jewelLevelLabels[i] = this["labJewelLevel" + (i + 4)] as Label;
				if(null == jewelLevelLabels[i]) continue;
				jewelLevelLabels[i].text = CJLang("JEWEL_LEVEL_" + (i + 4));
				jewelLevelLabels[i].textRendererProperties.textFormat = fontFormat;
			}
			
			_needVipLevel = int(CJDataOfGlobalConfigProperty.o.getData("JEWEL_COMBINE_ONE_KEY_NEED_VIP_LEVEL"));
		}
		
		/**
		 * 绘制界面内容
		 */		
		private function _drawContent():void
		{
			_quad = new Quad(SApplicationConfig.o.stageWidth, SApplicationConfig.o.stageHeight);
			_quad.alpha = 0;
			_quad.x = (this.width - SApplicationConfig.o.stageWidth) / 2;
			_quad.y = (this.height - SApplicationConfig.o.stageHeight) / 2;
			this.addChildAt(_quad, 0);
			//背景图
			var bg:Scale9Image =  ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_tankuangdi", 19,19,1,1);
			bg.width = this.width;
			bg.height = this.height;
			this.addChildAt(bg , 1);
			
			//选择等级背景图
			var levelBg:Scale9Image =  ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_hechengwenzidi", 10, 10,1,1);
			levelBg.width = 257;
			levelBg.height = 104;
			levelBg.x = 13;
			levelBg.y = 47;
			this.addChildAt(levelBg, 2);
			
			//分割线
			var line:ImageLoader = new ImageLoader();
			line.source = SApplication.assets.getTexture("common_fengexian");
			line.x = 20;
			line.y = 37;	
			line.width = this.width - 40;
			line.height = 5;
			this.addChildAt(line, 3);
			

			_btnConfirm.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			_btnConfirm.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			
			_btnClose.defaultSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			_btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
			_btnClose.visible = false;
			
			var jewelSelectLevelItems:Vector.<CJJewelSelectLevelItem> = new Vector.<CJJewelSelectLevelItem>(ConstJewelCombine.JEWEL_COMBINE_ONE_KEY_SELECT_LVL_NUM);
			//循环行数
			for(var j:uint = 0; j < ConstJewelCombine.JEWEL_SELECT_LVL_ROW_NUM; j++)
			{
				//循环列数
				for (var k:uint = 0; k < ConstJewelCombine.JEWEL__SELECT_LVL_COL_NUM; k++)
				{
					var index:int = j * ConstJewelCombine.JEWEL__SELECT_LVL_COL_NUM + k;
					jewelSelectLevelItems[index] = new CJJewelSelectLevelItem();
					jewelSelectLevelItems[index].x += ConstJewelCombine.JEWEL_SELECT_LVL_SPACE_HOR * k + 15;
					jewelSelectLevelItems[index].y += ConstJewelCombine.JEWEL_SELECT_LVL_SPACE_VER * j + 52;
					jewelSelectLevelItems[index].level = (index + 4);
//					if (0 == index)
//					{
//						_btnDefaultSeclected = jewelSelectLevelItems[0].btnSelect;
//						//默认第一个被选中
//						_btnDefaultSeclected.isSelected = true;
//					}
					this.addChild(jewelSelectLevelItems[index]);
					//为每个铸造装备分类按钮添加监听
					jewelSelectLevelItems[index].btnSelect.addEventListener(starling.events.Event.TRIGGERED, _itemChangeHandler);
				}
			}
		}
		/**
		 *宝石一键合成选择合成等级事件处理 
		 * @param event Event
		 * 
		 */		
		private function _itemChangeHandler(event:Event):void
		{
			SSoundEffectUtil.playButtonNormalSound();
			//获得当前点击的按钮
			var currentBtn:Button = event.currentTarget as Button;
			//如果当前点击的按钮不是默认的选中按钮，则把默认选中按钮的选中状态改为未选中
//			if (_btnDefaultSeclected != currentBtn)
//			{
//				_btnDefaultSeclected.isSelected = false;
//			}
//			else
//			{
//				_btnDefaultSeclected.isSelected = true;
//			}
			if (_oldBtn == currentBtn) return;
			//把当前点击的按钮设置为选中状态，上次选中的按钮设置为未选中状态
			if (null != _oldBtn)
			{
				_oldBtn.isSelected = false;
			}
			currentBtn.isSelected = true;
			//把当前点击的按钮设置为上次选中的按钮
			_oldBtn = currentBtn;
			var currentItem:CJJewelSelectLevelItem = currentBtn.parent as CJJewelSelectLevelItem;
			_currentSelectedLevel = currentItem.level; 
		}
		/**
		 * 为控件添加监听 
		 * 
		 */	
		private function _addListener():void
		{
			//为确定按钮添加监听
			_btnConfirm.addEventListener(starling.events.Event.TRIGGERED, function (e:*):void{
				SSoundEffectUtil.playButtonNormalSound();
				if (_currentSelectedLevel == 0)
				{
//					CJMessageBox(CJLang("JEWEL_COMBINE_ONE_KEY_TIP_TITLE"));
					CJFlyWordsUtil(CJLang("JEWEL_COMBINE_ONE_KEY_TIP_TITLE"));
				}
				else
				{
					var message:String = CJLang("JEWEL_COMBINE_ONE_KEY_CONFIRM") + _currentSelectedLevel + CJLang("JEWEL_COMBINE_RESULT_LEVEL");
					CJConfirmMessageBox(message,_funcConfirm);
				}
			});
			//为关闭按钮添加监听
			_btnClose.addEventListener(starling.events.Event.TRIGGERED, _onBtnCloseClick);
			_quad.addEventListener(TouchEvent.TOUCH, _onClickQuad);
		}
		
		override public function dispose():void
		{
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadCombineOneKeyInfo);
			super.dispose();
		}
		/**
		 * 触发关闭事件
		 * @param e
		 * 
		 */		
		private function _onClickQuad(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(_quad,TouchPhase.ENDED);
			if (!touch)
			{
				return;	
			}
			this.removeFromParent(true);
		}
		/**
		 * 选择确定按钮
		 * @param event
		 * 
		 */		
		private function _funcConfirm() : void
		{
			this.removeFromParent(true);
			// 添加网络锁
//			SocketLockManager.Lock(ConstNetLockID.CJJewelModule);
			//添加一键合成数据到达监听 
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadCombineOneKeyInfo);
			SocketCommand_item.jewelCombineOneKey(_currentSelectedLevel);
		}
		/**
		 * 加载一键合成服务器返回数据 
		 * @param e Event
		 * 
		 */		
		private function _onloadCombineOneKeyInfo(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() != ConstNetCommand.CS_JEWEL_COMBINE_COMBINE_ONE_KEY)
				return;
			// 去除网络锁
//			SocketLockManager.UnLock(ConstNetLockID.CJJewelModule);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadCombineOneKeyInfo);
			if (message.retcode == 0)
			{
				var retParams:Array = message.retparams;
				_retResult = retParams[0];
				_retState = int(retParams[1]);
				_showJewelCombineOneKeyResult(_retResult, _retState);
			}
		}
		
		/**
		 * 显示一键合成结果
		 * @param retResult 一键合成返回合成宝石的数据
		 * @param retState 一键合成的返回状态值
		 * 
		 */		
		private function _showJewelCombineOneKeyResult(retResult:Object, retState:int):void
		{
			var resultStr:String;
			switch (retState)
			{
				case ConstJewelCombine.JEWEL_COMBINE_RESULT_SUCCESS:
					resultStr = CJLang("JEWEL_COMBINE_ONE_KEY_SUCESS");
//					"," + CJLang("JEWEL_COMBINE_RESULT_GET");
//					for(var key:String in retResult)
//					{
//						var templateItemSettingDes:Json_item_setting = CJDataOfItemProperty.o.getTemplate(int(key));
//						resultStr += retResult[key] + CJLang("JEWEL_COMBINE_RESULT_COUNT") +  
//							CJLang(templateItemSettingDes.itemname);
//					}
					CJFlyWordsUtil(resultStr);
					//请求更新背包数据
					SocketCommand_item.getBag();
					CJDataManager.o.activityManager.dispatchEventWith(CJEvent.EVENT_ACTIVITY_HAPPEN , false, {"key":CJActivityEventKey.ACTIVITY_JEWELCOMBINE});
					break;
				case ConstJewelCombine.JEWEL_COMBINE_ONE_KEY_RETSTATE_VIP_NOT_ENOUGH:
					resultStr = "VIP" + _needVipLevel +
					CJLang("JEWEL_COMBINE_ONE_KEY_RETSTATE_VIP_NOT_ENOUGH")
					CJFlyWordsUtil(resultStr);
					break;
				case ConstJewelCombine.JEWEL_COMBINE_ONE_KEY_RESULT_BAG_SPACE_LACK:
					CJFlyWordsUtil(CJLang("JEWEL_COMBINE_ONE_KEY_RESULT_BAG_SPACE_LACK"));
					break;
				case ConstJewelCombine.JEWEL_COMBINE_ONE_KEY_RESULT_MATERIAL_LACK:
					CJFlyWordsUtil(CJLang("JEWEL_COMBINE_ONE_KEY_RESULT_MATERIAL_LACK"));
					break;
				case ConstJewelCombine.JEWEL_COMBINE_ONE_KEY_RETSTATE_NO_LOWER_LEVEL:
					CJFlyWordsUtil(CJLang("JEWEL_COMBINE_ONE_KEY_RETSTATE_NO_LOWER_LEVEL"));
					break;
				default:
					Assert(false,"宝石一键合成返回数据错误！");
					break;
			}
		}
		/**
		 * 按钮点击处理 - 关闭按钮
		 * @param event
		 * 
		 */		
		private function _onBtnCloseClick(event:Event) : void
		{
			SSoundEffectUtil.playButtonNormalSound();
			this.removeFromParent(true);
		}
		/**宝石一键合成说明 */
		public function get labTipTitle():Label
		{
			return _labTipTitle;
		}

		public function set labTipTitle(value:Label):void
		{
			_labTipTitle = value;
		}

		/**确定按钮*/
		public function get btnConfirm():Button
		{
			return _btnConfirm;
		}

		public function set btnConfirm(value:Button):void
		{
			_btnConfirm = value;
		}

		/**关闭按钮*/
		public function get btnClose():Button
		{
			return _btnClose;
		}

		public function set btnClose(value:Button):void
		{
			_btnClose = value;
		}

		/**四级宝石文本 */
		public function get labJewelLevel4():Label
		{
			return _labJewelLevel4;
		}

		/**
		 * @private
		 */
		public function set labJewelLevel4(value:Label):void
		{
			_labJewelLevel4 = value;
		}

		/**五级宝石文本 */
		public function get labJewelLevel5():Label
		{
			return _labJewelLevel5;
		}

		/**
		 * @private
		 */
		public function set labJewelLevel5(value:Label):void
		{
			_labJewelLevel5 = value;
		}

		/**六级宝石文本 */
		public function get labJewelLevel6():Label
		{
			return _labJewelLevel6;
		}

		/**
		 * @private
		 */
		public function set labJewelLevel6(value:Label):void
		{
			_labJewelLevel6 = value;
		}

		/**七级宝石文本 */
		public function get labJewelLevel7():Label
		{
			return _labJewelLevel7;
		}

		/**
		 * @private
		 */
		public function set labJewelLevel7(value:Label):void
		{
			_labJewelLevel7 = value;
		}

		/**八级宝石文本 */
		public function get labJewelLevel8():Label
		{
			return _labJewelLevel8;
		}

		/**
		 * @private
		 */
		public function set labJewelLevel8(value:Label):void
		{
			_labJewelLevel8 = value;
		}

		/**九级宝石文本 */
		public function get labJewelLevel9():Label
		{
			return _labJewelLevel9;
		}

		/**
		 * @private
		 */
		public function set labJewelLevel9(value:Label):void
		{
			_labJewelLevel9 = value;
		}

		/**十级宝石文本 */
		public function get labJewelLevel10():Label
		{
			return _labJewelLevel10;
		}

		/**
		 * @private
		 */
		public function set labJewelLevel10(value:Label):void
		{
			_labJewelLevel10 = value;
		}

		/**十一级宝石文本 */
		public function get labJewelLevel11():Label
		{
			return _labJewelLevel11;
		}

		/**
		 * @private
		 */
		public function set labJewelLevel11(value:Label):void
		{
			_labJewelLevel11 = value;
		}

		/**十二级宝石文本 */
		public function get labJewelLevel12():Label
		{
			return _labJewelLevel12;
		}

		/**
		 * @private
		 */
		public function set labJewelLevel12(value:Label):void
		{
			_labJewelLevel12 = value;
		}


	}
}