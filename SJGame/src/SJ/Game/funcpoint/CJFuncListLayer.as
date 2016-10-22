package SJ.Game.funcpoint
{
	import flash.geom.Rectangle;
	
	import SJ.Common.Constants.ConstFunctionList;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfFunctionList;
	import SJ.Game.data.CJDataOfScene;
	import SJ.Game.data.config.CJDataOfFuncPropertyList;
	import SJ.Game.data.json.Json_function_open_setting;
	import SJ.Game.enhanceequip.CJEnhanceLayer;
	import SJ.Game.lang.CJLang;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	
	/**
	 +------------------------------------------------------------------------------
	 * 功能点面板
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-20 下午3:51:17  
	 +------------------------------------------------------------------------------
	 */
	public class CJFuncListLayer extends SLayer
	{
		private var _funcList:CJDataOfFunctionList;
		private var _buttonList:Array;
		private var _beginX:Number = 30;
		private var _beginY:Number = 20;
		private var _spanX:Number = 54;
		private var _spanY:Number = 55;
		private var _filter:ColorMatrixFilter;
		
		public function CJFuncListLayer()
		{
			super();
			_funcList = CJDataManager.o.DataOfFuncList
		}
		
		override protected function initialize():void
		{
			this._genDownSimulateFilter();
			this._drawContent();
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
				SApplication.moduleManager.exitModule("CJFuncListModule");
			});
			button.x = 308;
			button.y = -18;
			this.addChild(button);
		}
		
		private function _drawFuncListIcon():void
		{
			var configList:CJDataOfFuncPropertyList = CJDataOfFuncPropertyList.o;
			//不需要等级开启的整合列表
			var notNeedOpenIdList:Array = configList.getFunctionListNoNeedOpenByType(ConstFunctionList.FUNCITON_OPEN);
			//完成开启的整合列表
			var allCompletedFuncitonList:Array = this._funcList.getAllCompleteFunctionIdList(ConstFunctionList.FUNCITON_OPEN);
			
			var showList:Array = allCompletedFuncitonList.concat(notNeedOpenIdList);
			
			showList = sortList(showList);
			
			//如果正在指引，且该功能点需要放到整合里面的
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				var currenOpenId:int = this._funcList.getNextUnOpenFunctionId(int(CJDataManager.o.DataOfHeroList.getMainHero().level));
				if(currenOpenId != -1)
				{
					var config:Json_function_open_setting = configList.getProperty(currenOpenId);
					if(int(config.type )==  ConstFunctionList.FUNCITON_OPEN)
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
				var button:Button = new Button();
				button.defaultSkin = new SImage(SApplication.assets.getTexture(funcConfig.icon));
				var img:SImage = new SImage(SApplication.assets.getTexture(funcConfig.icon));
				img.filter = _filter;
				button.downSkin = img;
				this.addChild(button);
				button.x = _beginX + int(i % 5) * _spanX;
				button.y = _beginY + int(i / 5) * _spanY;
				
				button.name = "" +funcConfig.modulename;
				button.addEventListener(Event.TRIGGERED , this._launchModule);
			}
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
				return -1;
			}
			else if(int(ob1.index) < int(ob2.index) )
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
		
		
		private function _launchModule(e:Event):void
		{
			var button:Button = e.target as Button;
			var moduleName:String = button.name;
			SSoundEffectUtil.playTipSound();
			switch(moduleName)
			{
				case "CJEnhanceModule_0":
					SApplication.moduleManager.enterModule(moduleName.split("_")[0], {"pagetype":CJEnhanceLayer.BTN_TYPE_QIANGHUA});
					break;
				case "CJEnhanceModule_1":
					SApplication.moduleManager.enterModule(moduleName.split("_")[0], {"pagetype":CJEnhanceLayer.BTN_TYPE_ZHUZAO});
					break;
				case "CJEnhanceModule_2":
					SApplication.moduleManager.enterModule(moduleName.split("_")[0], {"pagetype":CJEnhanceLayer.BTN_TYPE_XILIAN});
					break;
				case "CJWinebarModule":
					SApplication.moduleManager.enterModule(moduleName , CJDataOfScene.o.sceneid);
					break;
				default:
					SApplication.moduleManager.enterModule(moduleName);
					
			}
	
			SApplication.moduleManager.exitModule("CJFuncListModule");
		}
		
		private function _drawTitle():void
		{
			var title:CJPanelTitle = new CJPanelTitle(CJLang("FUNCTION_NAME_10"));
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
		
		override public function dispose():void
		{
			super.dispose();
			_filter.dispose();
		}
	}
}