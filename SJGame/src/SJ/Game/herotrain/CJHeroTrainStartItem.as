package SJ.Game.herotrain
{
	import SJ.Common.Constants.ConstHeroTrain;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.config.CJDataOfHeroTrainProperty;
	import SJ.Game.data.json.Json_hero_train_setting;
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.lang.CJLang;
	
	import feathers.controls.Label;
	
	public class CJHeroTrainStartItem extends CJItemTurnPageBase
	{
		private const ITEMWIDTH:int = 366;
		private const ITEMHEIGHT:int = 20;
		
		// 武将名称
		private var _heroname:Label;
		// 等级
		private var _herolevel:Label;
		// 冷却时间
		private var _cooltime:Label;
		// 获得经验
		private var _exp:Label;
		
		public function CJHeroTrainStartItem()
		{
			super("CJHeroTrainStartItem", true);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this.drawContent();
		}
		
		private function drawContent():void
		{
			this.width = ITEMWIDTH;
			this.height = ITEMHEIGHT;
			
			// 武将名称
			_heroname = new Label;
			_heroname.x = 20;
			_heroname.y =  2;
			addChild(_heroname);
			
			// 武将等级
			_herolevel = new Label;
			_herolevel.x = 105;
			_herolevel.y = 2;
			_herolevel.textRendererProperties.textFormat = ConstTextFormat.textformatgreencenter;
			addChild(_herolevel);
			
			// 冷却时间
			_cooltime = new Label;
			_cooltime.x = 183;
			_cooltime.y = 2;
			_cooltime.textRendererProperties.textFormat = ConstTextFormat.textformatlightbluecenter;
			addChild(_cooltime);
			
			// 状态
			_exp = new Label;
			_exp.x = 268;
			_exp.y = 2;
			_exp.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			addChild(_exp);
		}
		
		override protected function onSelected():void
		{
		}
		
		override protected function draw():void
		{
			super.draw();
			
			if(data == null)
			{
				return;
			}
			const isAllInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(isAllInvalid)
			{
//				传入属性
//				data.index = i;
//				data.heroid = heroInfo.heroid;
//				data.name = heroInfo.heroProperty.name;
//				data.quality = heroInfo.heroProperty.quality;
//				data.level = heroInfo.level;
//				data.state = ConstHeroTrain.HERO_STATE_FULL; // 满级
//				data.weight
//				data.starttime = trainData[heroInfo.heroid] == null ? 0 : int(trainData[heroInfo.heroid]);
//				data.isSelected = false;
//				data.traintype 训练类型
//				新加属性
//				data.endtime
				
				// 武将名称
				_heroname.textRendererProperties.textFormat = ConstTextFormat.getFormatByQuality(int(data.quality));
				_heroname.text = data.name;
				
				// 武将等级
				_herolevel.text = CJLang("HERO_TRAIN_LV") + " " + data.level;
				
				// 冷却时间
				_cooltime.text = CJLang("HERO_TRAIN_CD_DES");
				// 获得经验
				// 武将信息
				var exp:int = 0;
				var js:Json_hero_train_setting = CJDataOfHeroTrainProperty.o.getData(String(data.level));
				if (data.traintype == ConstHeroTrain.HERO_TRAIN_TYPE_COMMON) // 普通训练
					exp += int(js.exp);
				else if (data.traintype == ConstHeroTrain.HERO_TRAIN_TYPE_2) // 双倍训练
					exp += int(js.exp) * int(CJDataOfGlobalConfigProperty.o.getData("HERO_TRAIN_EXP_2"));
				else // 五倍训练
					exp += int(js.exp) * int(CJDataOfGlobalConfigProperty.o.getData("HERO_TRAIN_EXP_5"));
				_exp.text = exp.toString();
			}
		}
		
	}
	
}