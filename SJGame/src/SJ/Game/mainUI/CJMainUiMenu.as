package SJ.Game.mainUI
{
	import SJ.Common.Constants.ConstFunctionList;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.chat.CJMainChatLayer;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfFunctionList;
	import SJ.Game.data.CJDataOfScene;
	import SJ.Game.data.config.CJDataOfFuncPropertyList;
	import SJ.Game.data.json.Json_function_open_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.utils.SCompileUtils;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.STween;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.core.FeathersControl;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	import starling.textures.Texture;
	
	/**
	 +------------------------------------------------------------------------------
	 * 主界面菜单层
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-27 下午5:45:23  
	 +------------------------------------------------------------------------------
	 */
	public class CJMainUiMenu extends SLayer
	{
		/*初始按钮的位置*/
		private static const INIT_BOTTOM_BUTTON_POS_X:Number = 436;
		private static const INIT_BOTTOM_BUTTON_POS_Y:Number = 282;
		private static const INIT_RIGHT_BUTTON_POS_X:Number = 436;
		private static const INIT_RIGHT_BUTTON_POS_Y:Number = 278;
		/*间隔距离*/
		private static const OFFSET:Number = 42;
		
		private var _functionConfigList:CJDataOfFuncPropertyList;
		private var _funcList:CJDataOfFunctionList;
		
		private var _rightButtonList:Array = new Array();
		private var _bottomButtonList:Array = new Array();
		private var _leftButtonList:Array = new Array();
		private var aniTweenList:Array = new Array();
		
		/*菜单是否显示*/
		private var _isHide:Boolean = true;
		/*是否正在指引*/
		private var _isIndicate:Boolean = false;
		/*右下角的菜单按钮 */
		private var _btnMenu:Button;
		/*右下角的菜单按钮装饰 */
		private var _imgMenuDecoration:ImageLoader;
		/*左下角的信息展示框*/
		private var _chatLayer:CJMainChatLayer;
		
		private var _filter:ColorMatrixFilter;
		
		public function CJMainUiMenu()
		{
			super();
		}
		
		override protected function initialize():void
		{
			this._initData();
			
			this._drawContent();
			
			this._addEventListeners();
		}
		
		private function _drawContent():void
		{
			_imgMenuDecoration = new ImageLoader();
			_imgMenuDecoration.source = SApplication.assets.getTexture("zhujiemian_caidanzhuangshi")
			_imgMenuDecoration.x = 403;
			_imgMenuDecoration.y = 275;
			this.addChild(_imgMenuDecoration);
			
			_btnMenu = new Button();
			_btnMenu.defaultSkin = new SImage( SApplication.assets.getTexture("zhujiemian_caidanchangtai"));
			_btnMenu.downSkin = new SImage( SApplication.assets.getTexture("zhujiemian_caidananxia"));
			_btnMenu.isSelected = !this._isHide;
			_btnMenu.x = 432;
			_btnMenu.y = 276;
			_btnMenu.addEventListener(Event.TRIGGERED, this._clickMenu);
			this.addChild(_btnMenu);
			
			_chatLayer = new CJMainChatLayer();
			_chatLayer.x = 0;
			_chatLayer.y = 291;
			this.addChild(_chatLayer);
			
			//编译开关
			_chatLayer.visible = !SCompileUtils.o.isOnVerify();
			
			_genDownSimulateFilter();
		}
		
		private function _genDownSimulateFilter():void
		{
			_filter = new ColorMatrixFilter();
			_filter.matrix = Vector.<Number>([
				1,0,0,0,0,
				0,1,0,0,0,
				0,0,1,0,0,
				0,0,0,1,0
			]);
			_filter.adjustBrightness(-0.1); //亮度
		}
		
		private function _clickMenu(e:Event):void
		{
			SSoundEffectUtil.playButtonNormalSound();
			this.hideShow();
		}
		
		private function _initData():void
		{
			this._funcList = CJDataManager.o.DataOfFuncList;
			this._functionConfigList = CJDataOfFuncPropertyList.o;
		}
		
		private function _addEventListeners():void
		{
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_INDICATE_ENTER , this._enterIndicate);
//			升级到特定等级需要显示战斗力按钮
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_SELF_PLAYER_UPLEVEL , this._uplevelHandler);
			
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData , this._onSocketComplete);
			
			this.addEventListener("draw_button_complete" , this._refreshMenu);
		}
		
		private function _onSocketComplete(e:Event):void
		{
			var msg:SocketMessage = e.data as SocketMessage;
			var command:String = msg.getCommand();
			if(command == ConstNetCommand.SC_REWARD_GETREWARD)
			{
				
				for(var i:String in _leftButtonList)
				{
					if(_leftButtonList[i].name == 'CJRewardModule')
					{
						_leftButtonList[i].visible = true;
					}
				}
			}
		}
		
		private function _uplevelHandler(e:Event):void
		{
			if(e.type != CJEvent.EVENT_SELF_PLAYER_UPLEVEL)
			{
				return;
			}
			
			var data:Object = e.data;
			var currentLevel:int = data.currentLevel;
			
			//左边所有按钮，等级低于配置值都 不开启
			for(var i:String in _leftButtonList)
			{
				var funcListConfig:Json_function_open_setting = CJDataOfFuncPropertyList.o.getPropertyByExactlyModulename(_leftButtonList[i].name);
				if(funcListConfig && int(CJDataManager.o.DataOfHeroList.getMainHero().level) >= int(funcListConfig.level))
				{
					_leftButtonList[i].visible = true;
				}
				
				
				if(_leftButtonList[i].name == 'CJRewardModule')
				{
					//				没有奖励的时候,领奖按钮不显示
					var rewardList:Array = CJDataManager.o.DataOfReward.validList;
					if(!rewardList || rewardList.length == 0)
					{
						_leftButtonList[i].visible = false;
					}
				}
			}
		}
		
		override public function dispose():void
		{
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_INDICATE_ENTER , this._enterIndicate);
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_SELF_PLAYER_UPLEVEL , this._uplevelHandler);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData , this._onSocketComplete);
			super.dispose();
			_filter.dispose();
		}
		
		
		private function _refreshMenu(e:Event):void
		{
			if(this._isHide)
			{
				this.hideShow();
			}
		}
		
		override protected function draw():void
		{
			super.draw();
			this.removeAllButton();
			this._drawLeftButtons();
			this._drawRightButtons();
			this._drawBottomButtons();
			this.setChildIndex(_btnMenu, this.numChildren -1);
			
			if(_isIndicate)
			{
				this.dispatchEventWith("draw_button_complete");
			}
		}
		
		
		private function removeAllButton():void
		{
			for(var i:String in this._leftButtonList)
			{
				(this._leftButtonList[i] as FeathersControl).removeFromParent();
			}
			for(var j:String in this._rightButtonList)
			{
				(this._rightButtonList[j] as Button).removeFromParent();
			}
			for(var k:String in this._bottomButtonList)
			{
				(this._bottomButtonList[k] as Button).removeFromParent();
			}
		}
		
		/**
		 * 菜单显示或者隐藏
		 */ 
		public function hideShow():void
		{
			_isHide = !_isHide;
			_btnMenu.isSelected = !this._isHide;
			if (_btnMenu.isSelected)
			{
				_btnMenu.defaultSkin = new SImage( SApplication.assets.getTexture("zhujiemian_caidandakai"));
				_btnMenu.isSelected = false;
			}
			else
			{
				_btnMenu.defaultSkin = new SImage( SApplication.assets.getTexture("zhujiemian_caidanchangtai"));
			}
			this._chatLayer.resize(_isHide);
			if(_isHide)
			{
				this._hide();
			}
			else
			{
				this._show();
			}
		}
		
		private function _show():void
		{
			this._isHide = false;
			for(var i:String in this._bottomButtonList)
			{
				var btn:Button = this._bottomButtonList[i];
				btn.visible = true;
				var aniTween1:STween = new STween(btn , 0.3 , Transitions.LINEAR);
				aniTween1.moveTo(INIT_BOTTOM_BUTTON_POS_X - (int(i) + 1) * OFFSET , INIT_BOTTOM_BUTTON_POS_Y);
				aniTween1.onCompleteArgs = new Array(aniTween1 , btn);
				aniTween1.onComplete = function (tween:STween , button:Button):void
				{
					button.visible = !this._isHide;
					button.touchable = !this._isHide;
					Starling.juggler.remove(tween);
				};
				btn.touchable = false;
				Starling.juggler.add(aniTween1);
				aniTweenList.push(aniTween1);
			}
			for(var j:String in this._rightButtonList)
			{
				var rb:Button = this._rightButtonList[j];
				rb.visible = true;
				var aniTween2:STween = new STween(rb , 0.3 , Transitions.LINEAR);
				aniTween2.moveTo(INIT_RIGHT_BUTTON_POS_X , INIT_RIGHT_BUTTON_POS_Y - (int(j) + 1) * OFFSET);
				aniTween2.onCompleteArgs = new Array(aniTween2 , rb);
				aniTween2.onComplete = function (tween:STween , button:Button):void
				{
					button.visible = !this._isHide;
					button.touchable = !this._isHide;
					Starling.juggler.remove(tween);
				};
				rb.touchable = false;
				Starling.juggler.add(aniTween2);
				aniTweenList.push(aniTween2);
			}
			
			CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_MAIN_BUTTON_MENU_OPENING)
			Starling.juggler.delayCall(function():void{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_MAIN_BUTTON_MENU_OPENED)
			},0.4);
		}
		
		private function _hide():void
		{
			this._isHide = true;
			
			for(var i:String in this._bottomButtonList)
			{
				var btn:Button = this._bottomButtonList[i];
				var aniTween1:STween= new STween(btn , 0.3 , Transitions.LINEAR);
				aniTween1.moveTo(INIT_BOTTOM_BUTTON_POS_X, INIT_BOTTOM_BUTTON_POS_Y);
				aniTween1.onCompleteArgs = new Array(aniTween1 , btn);
				aniTween1.onComplete = function (tween:STween , button:Button):void
				{
					button.visible = !this._isHide;
					button.touchable = !this._isHide;
					Starling.juggler.remove(tween);
				};
				btn.touchable = false;
				Starling.juggler.add(aniTween1);
				aniTweenList.push(aniTween1);
			}
			for(var j:String in this._rightButtonList)
			{
				var rb:Button = this._rightButtonList[j];
				var aniTween2:STween = new STween(rb , 0.3 , Transitions.LINEAR);
				aniTween2.moveTo(INIT_RIGHT_BUTTON_POS_X , INIT_RIGHT_BUTTON_POS_Y);
				aniTween2.onCompleteArgs = new Array(aniTween2 , rb);
				aniTween2.onComplete = function (tween:STween , button:Button):void
				{
					button.visible = !this._isHide;
					button.touchable = !this._isHide;
					Starling.juggler.remove(tween);
				};
				rb.touchable = false;
				Starling.juggler.add(aniTween2);
				aniTweenList.push(aniTween2);
			}
			
			CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_MAIN_BUTTON_MENU_CLOSEING)
			Starling.juggler.delayCall(function():void{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_MAIN_BUTTON_MENU_CLOSED)
			},0.4);
		}
		
		
		private function _enterIndicate(e:Event):void
		{
			if(e.type != CJEvent.EVENT_INDICATE_ENTER)
			{
				return;
			}
			
			var data:Object = e.data;
			
			if(data.hasOwnProperty("step") && int(data.step) == 0)
			{
				this._hide();
			}
			
			else if(data.step && int(data.step) == 1)
			{
				_isIndicate = true;
				this.invalidate();
			}
		}
		
		/**
		 * 返回经过排序的按钮列表
		 */ 
		private function _genButtonList(type:int):Array
		{
			var noNeedOpenFunctionIdList:Array = this._functionConfigList.getFunctionListNoNeedOpenByType(type);
			var openList:Array = new Array();
			if(this._funcList.isIndicating)
			{
				openList = this._funcList.getAllFunctionIdList(type);
			}
			else
			{
				openList = this._funcList.getAllCompleteFunctionIdList(type);
			}
			
			var tempList:Array = new Array();
			//去掉重复的
			for(var i:String in openList)
			{
				if(noNeedOpenFunctionIdList.indexOf(openList[i]) == -1)
				{
					tempList.push(openList[i]);
				}
			}
			
			var allFunctionIdList:Array = noNeedOpenFunctionIdList.concat(tempList);
			allFunctionIdList = sortList(allFunctionIdList);
			return allFunctionIdList;
		}
		
		private function sortList(idList:Array):Array
		{
			var tempArray :Array = new Array();
			for(var i :String in idList)
			{
				var config:Json_function_open_setting = CJDataOfFuncPropertyList.o.getProperty(idList[i]);
				tempArray.push({"functionid":int(config.functionid) , "index":int(config.index)});
			}
			tempArray = tempArray.sort(_compare);
			
			var tempIdArray:Array = new Array();
			while(tempArray.length != 0)
			{
				tempIdArray.push(tempArray.pop().functionid);
			}
			return tempIdArray;
		}
		
		/**
		 * 由大到小排序
		 */ 
		private function _compare(ob1:Object , ob2:Object):int
		{
			if(int(ob1.index) > int(ob2.index) )
			{
				return 1;
			}
			else if(int(ob1.index) < int(ob2.index) )
			{
				return -1;
			}
			else
			{
				return 0;
			}
		}
		
		/**
		 * 画左边的按钮列表
		 */ 
		private function _drawLeftButtons():void
		{
			_leftButtonList = new Array();
			 
			var idList:Array = _genButtonList(ConstFunctionList.FUNCITON_MAIN_LEFT);
			for(var i :String in idList)
			{
				var config:Json_function_open_setting = CJDataOfFuncPropertyList.o.getProperty(idList[i]);
				if(!config)
				{
					continue;
				}
				var btn:Button = new Button();
				var t1:Texture = SApplication.assets.getTexture(config.icon);
				if(t1)
				{
					btn.defaultSkin = new SImage(t1);
					var img:SImage = new SImage(t1);
					img.filter = _filter;
					btn.downSkin = img;
				}

				
//				活动按钮 - 审核屏蔽
				if(btn.name == "CJSplendidActivityModule")
				{
					btn.visible = !SCompileUtils.o.isOnVerify();
				}
				
//				左边所有按钮，等级低于配置值都 不开启
				btn.name = config.modulename;
				var funcListConfig:Json_function_open_setting = CJDataOfFuncPropertyList.o.getPropertyByExactlyModulename(btn.name);
				if(funcListConfig && int(CJDataManager.o.DataOfHeroList.getMainHero().level) < int(funcListConfig.level))
				{
					btn.visible = false;
				}
				
//				没有奖励的时候,领奖按钮不显示
				
				if(btn.name == 'CJRewardModule')
				{
					var rewardList:Array = CJDataManager.o.DataOfReward.validList;
					if(!rewardList || rewardList.length == 0)
					{
						btn.visible = false;
					}
				}
				

				btn.addEventListener(Event.TRIGGERED , function (e:Event):void
				{
					SSoundEffectUtil.playTipSound();
					SApplication.moduleManager.enterModule((e.target as Button).name.split("_")[0]);
				}
				);
				
				
				btn.x = 0;
				btn.y = 250 - (int(i) + 1)*OFFSET;
				this.addChild(btn);
				_leftButtonList.push(btn);
			}
		}
		
		/**
		 * 画右边的按钮列表
		 */ 
		private function _drawRightButtons():void
		{
			_rightButtonList = new Array();
			var idList:Array = _genButtonList(ConstFunctionList.FUNCITON_MAIN_RIGHT);
			for(var i :String in idList)
			{
				var config:Json_function_open_setting = CJDataOfFuncPropertyList.o.getProperty(idList[i]);
				if(!config)
				{
					continue;
				}
				var btn:Button = this._drawButton(INIT_RIGHT_BUTTON_POS_X , INIT_RIGHT_BUTTON_POS_Y , config.icon , config.icon + "anxia");
				btn.name = config.modulename;
				btn.visible = false;
				btn.touchable = false;
				btn.addEventListener(Event.TRIGGERED , function (e:Event):void
				{
					SSoundEffectUtil.playTipSound();
					SApplication.moduleManager.enterModule((e.target as Button).name.split("_")[0]);
				}
				);
				_rightButtonList.push(btn);
			}
		}
		
		/**
		 * 画底部的按钮列表
		 */
		private function _drawBottomButtons():void
		{
			_bottomButtonList = new Array();
			var idList:Array = _genButtonList(ConstFunctionList.FUNCITON_MAIN_BOTTOM);
			
			for(var i :String in idList)
			{
				var config:Json_function_open_setting = CJDataOfFuncPropertyList.o.getProperty(idList[i]);
				var btn:Button = this._drawButton(INIT_BOTTOM_BUTTON_POS_X, INIT_BOTTOM_BUTTON_POS_Y , config.icon , config.icon + "anxia");
				btn.name = config.modulename;
				if(btn.name.indexOf("CJWinebarModule") != -1)
				{
					btn.addEventListener(Event.TRIGGERED , function (e:Event):void
					{
						SSoundEffectUtil.playTipSound();
						SApplication.moduleManager.enterModule((e.target as Button).name.split("_")[0] , CJDataOfScene.o.sceneid);
					}
					);
				}
				else
				{
					btn.addEventListener(Event.TRIGGERED , function (e:Event):void
					{
						SSoundEffectUtil.playTipSound();
						SApplication.moduleManager.enterModule((e.target as Button).name.split("_")[0]);
					}
					);
				}
				
				btn.visible = false;
				btn.touchable = false;
				_bottomButtonList.push(btn);
			}
		}
		
		private function _drawButton(x:Number , y:Number , defaultSkin:String , downSkin:String):Button
		{
			var btn:Button = new Button();
			btn.x = x;
			btn.y = y;
			var t1:Texture = SApplication.assets.getTexture(defaultSkin);
			if(t1)
			{
				btn.defaultSkin = new SImage(t1);
				var img:SImage = new SImage(t1);
				img.filter = _filter;
				btn.downSkin = img;
				btn.width = btn.defaultSkin.width;
				btn.height = btn.defaultSkin.height;
			}
			
			this.addChild(btn);
			return btn;
		}

		public function get isHide():Boolean
		{
			return _isHide;
		}

	}
}