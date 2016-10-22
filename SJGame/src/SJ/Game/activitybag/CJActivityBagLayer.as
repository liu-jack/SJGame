package SJ.Game.activitybag
{
	import SJ.Common.Constants.ConstFunctionList;
	import SJ.Common.Constants.ConstFuben;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfFuben;
	import SJ.Game.data.config.CJDataOfFuncPropertyList;
	import SJ.Game.data.json.Json_function_open_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.lang.CJLang;
	import SJ.Game.onlineReward.CJOLRewardMenu;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * 活跃度集合包
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-9-14  11:51:17  
	 +------------------------------------------------------------------------------
	 */
	public class CJActivityBagLayer extends SLayer
	{
		private var _buttonList:Array;
		private var _beginX:Number = 30;
		private var _beginY:Number = 20;
		private var _spanX:Number = 54;
		private var _spanY:Number = 55;
		
		public function CJActivityBagLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			this._drawContent();
		}
		
		private function _drawContent():void
		{
			this._drawBg();
			this._drawTitle();
			this._drawFuncListIcon();
			
			var button:Button = new Button();
			button.defaultSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			button.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
			button.addEventListener(Event.TRIGGERED , function ():void
			{
				SApplication.moduleManager.exitModule("CJSplendidActivityModule");
			});
			button.x = 308;
			button.y = -18;
			this.addChild(button);
			
			//处理指引
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
		}
		
		private function _drawFuncListIcon():void
		{
			var configList:CJDataOfFuncPropertyList = CJDataOfFuncPropertyList.o;
			//不需要等级开启的整合列表
			var notNeedOpenIdList:Array = configList.getFunctionListNoNeedOpenByType(ConstFunctionList.FUNCITON_ACTIVITY_BAG);
			
			//完成开启的整合列表
			var allCompletedFuncitonList:Array = CJDataManager.o.DataOfFuncList.getAllCompleteFunctionIdList(ConstFunctionList.FUNCITON_ACTIVITY_BAG);
			
			var showList:Array = allCompletedFuncitonList.concat(notNeedOpenIdList);
			
			//如果正在指引，且该功能点需要放到整合里面的
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				var currenOpenId:int = CJDataManager.o.DataOfFuncList.getNextUnOpenFunctionId(int(CJDataManager.o.DataOfHeroList.getMainHero().level));
				if(currenOpenId != -1)
				{
					var config:Json_function_open_setting = configList.getProperty(currenOpenId);
					if(int(config.type )==  ConstFunctionList.FUNCITON_ACTIVITY_BAG)
					{
						showList.unshift(currenOpenId);
					}
				}
			}
			
			var len:int = showList.length;
			for(var i:int = 0 ; i< len ; i++)
			{
				var functionId:int = showList[i];
				var funcConfig:Json_function_open_setting = configList.getProperty(functionId);
				if(funcConfig.icon == undefined)
				{
					continue;
				}
				
				var button:FeathersControl;
				
				//在线奖励
				if(int(functionId) == 9)
				{
					button = new CJOLRewardMenu();
				}
				else
				{
					button = new Button();
					(button as Button).defaultSkin = new SImage(SApplication.assets.getTexture(funcConfig.icon));
					(button as Button).downSkin = new SImage(SApplication.assets.getTexture(funcConfig.icon+"anxia"));
				}
				
				
				this.addChild(button);
				button.x = _beginX + int(i % 5) * _spanX;
				button.y = _beginY + int(i / 5) * _spanY;
				
				button.name = "" +funcConfig.modulename;
				button.addEventListener(Event.TRIGGERED , this._launchModule);
			}
		}
		
		private function _launchModule(e:Event):void
		{
			var button:Button = e.target as Button;
			var moduleName:String = button.name;
			SSoundEffectUtil.playTipSound();
			if(moduleName.indexOf("CJWorldModule") != -1)
			{
				(CJDataManager.o.getData("CJDataOfFuben") as CJDataOfFuben).gotos = ConstFuben.FUBEN_SUPER;
				var evt:Event = new Event(CJEvent.EVENT_SCENE_CITY_MOVETOENTER);
				CJEventDispatcher.o.dispatchEvent(evt);
//				CJLoaderMoudle.helper_enterWorld({"to":"superfb"});
				
				//处理指引
				if(CJDataManager.o.DataOfFuncList.isIndicating)
				{
					CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
				}
			}
			else
			{
				SApplication.moduleManager.enterModule(moduleName);
			}
			
			SApplication.moduleManager.exitModule("CJSplendidActivityModule");
		}
		
		private function _drawTitle():void
		{
			var title:CJPanelTitle = new CJPanelTitle(CJLang("FUNCTION_NAME_25"));
			this.addChild(title);
			title.x = 10;
			title.y = -15;
		}
		
		private function _drawBg():void
		{
			//底框
			var bgWrap:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_waikuangnew") , new Rectangle(15 , 15 , 1, 1)));
			bgWrap.width = 330;
			bgWrap.height = 190;
			this.addChildAt(bgWrap , 0);
			
			//滚珠
			var bgBall:CJPanelFrame = new CJPanelFrame(320 , 180);
			bgBall.width = 320;
			bgBall.height = 180;
			bgBall.x = 5;
			bgBall.y = 5;
			this.addChildAt(bgBall , 0 );
			
			//底
			var bg : Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_dinew") , new Rectangle(1 ,1 , 1, 1)));
			bg.width = 330;
			bg.height = 190;
			this.addChildAt(bg , 0);
		}
	}
}