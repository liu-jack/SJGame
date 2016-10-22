package SJ.Game.heroPropertyUI
{
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfHeroList;
	import SJ.Game.data.CJDataOfKFContend;
	import SJ.Game.enhanceequip.CJEnhanceLayer;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;

	public class CJHeroQuickLink extends SLayer
	{
		private var vec:Vector.<Button>;
		private var _filter:ColorMatrixFilter;
		
		public function CJHeroQuickLink()
		{
			
		}
		
		override protected function initialize():void
		{
			super.initialize();
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
		
		public function resflushBt(heroid:String):void
		{
			while(numChildren)removeChildAt(0, true);
			vec = new Vector.<Button>();
			
			var heroInfo:CJDataOfHeroList = CJDataManager.o.getData("CJDataOfHeroList");
			var mainHero:CJDataOfHero = heroInfo.getMainHero();
			var  roleLv:int = int(mainHero.level);
			
			var bool:Boolean = mainHero.userid == heroid;
			
			var layY:int=0;
			for(var i:int=1; i<=6; i++)
			{
				var openlv:int = getOpenLevel(i);
				if(roleLv >= openlv)
				{
					if(i==1 && bool)continue;
					if(i==2 && bool==false)continue;
						
					var skins:Array = getSkin(i);
					//按钮
					var t_bt:Button = new Button();
					t_bt.defaultSkin = new SImage(SApplication.assets.getTexture(skins[0]));
					var img:SImage = new SImage(SApplication.assets.getTexture(skins[0]));
					img.filter = _filter;
					t_bt.downSkin = img;
					t_bt.y = layY*38;
					this.addChild(t_bt);
					t_bt.name = i+"";
					t_bt.addEventListener(Event.TRIGGERED, _btClick);
					vec.push(t_bt);
					
					layY++;
				}
			}
		}
		
		//获得对应功能的开启等级
		private function getOpenLevel(index:int):int
		{
			var func:int=0;
			switch(index)
			{
				case 1://升星
					func = 15;
					break;
				case 2://升阶
					func = 16;
					break;
				case 3://训练
					func = 18;
					break;
				case 4://强化
					func = 20;
					break;
				case 5://铸造
					func = 21;
					break;
				case 6://传功
					func = 24;
					break;
			}
			var openLv:int = CJDataOfKFContend.o.getModuleOpenLv(func);
			return openLv;
		}
		
		private function _btClick(e:Event):void
		{
			var index:int = int((e.target as Button).name);
			
			var module:String = "";
			
			switch(index)
			{
				case 1://升星
					module = "CJHeroStarModule";
					break;
				case 2://升阶
					module = "CJStageLevelModule";
					break;
				case 3://训练
					module = "CJHeroTrainModule";
					break;
				case 4://强化
					module = "CJEnhanceModule";
					break;
				case 5://铸造
					module = "CJEnhanceModule";
					break;
				case 6://传功
					module = "CJTransferAbilityModule";
					break;
			}
			
			if(module != "")
			{
				SApplication.moduleManager.exitModule("CJHeroPropertyUIModule");
				
				var param:Object=null;
				if(index==4){
					param = {"pagetype":CJEnhanceLayer.BTN_TYPE_QIANGHUA};
				}else if(index==5){
					param = {"pagetype":CJEnhanceLayer.BTN_TYPE_ZHUZAO};
				}
				SApplication.moduleManager.enterModule(module, param);
			}
		}
		
		/*
		gongnengzhenghe_shenxing 升星  1
		gongnengzhenghe_shengjie 升阶  2
		gongnengzhenghe_xunlian 训练  3
		gongnengzhenghe_qianghua 强化  4
		gongnengzhenghe_zhuzao 铸造  5
		gongnengzhenghe_chuangong 传功  6
		获得对应按钮皮肤
		*/
		private function getSkin(_index:int):Array
		{
			var arr:Array = [];
			switch(_index)
			{
				case 1:
					arr = ["gongnengzhenghe_shenxing"];
					break;
				case 2:
					arr = ["gongnengzhenghe_shengjie"];
					break;
				case 3:
					arr = ["gongnengzhenghe_xunlian"];
					break;
				case 4:
					arr = ["gongnengzhenghe_qianghua"];
					break;
				case 5:
					arr = ["gongnengzhenghe_zhuzao"];
					break;
				case 6:
					arr = ["gongnengzhenghe_chuangong"];
					break;
			}
			return arr;
		}
		
		override public function dispose():void
		{
			for(var i:int=0; i<vec.length; i++)
			{
				vec[0].removeEventListener(Event.TRIGGERED, _btClick);
			}
			
			vec = null;
			_filter.dispose();
		}
	}
}