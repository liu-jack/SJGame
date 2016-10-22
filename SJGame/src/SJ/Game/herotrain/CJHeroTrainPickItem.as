package SJ.Game.herotrain
{
	import flash.text.TextFormat;
	
	import SJ.Common.Constants.ConstHeroTrain;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_heroTrain;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.config.CJDataOfVipFuncSetting;
	import SJ.Game.data.json.Json_vip_function_setting;
	import SJ.Game.enhanceequip.CJEnhanceLayerCheckbox;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	import SJ.Game.task.CJTaskFlowString;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale3Image;
	import feathers.textures.Scale3Textures;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.events.Event;
	
	/**
	 * 选择框内item
	 * @author longtao
	 * 
	 */
	public class CJHeroTrainPickItem extends CJItemTurnPageBase implements IAnimatable
	{
		private const ITEMWIDTH:int = 366;
		private const ITEMHEIGHT:int = 33;
		
		// 默认时间显示
		private const DEFAULT_TIME_SHOW:String = "00:00:00";
		
		// 时间
		private var _oldtime:Number = 0;
		private var _newtime:Number = 0;
		
		private var _btnhide:Button = new Button;
		
		// 复选框
		private var _checkbox:CJEnhanceLayerCheckbox;
		// 武将名称
		private var _heroname:Label;
		// 等级
		private var _herolevel:Label;
		// 冷却时间
		private var _cooltime:Label;
		// 状态
		private var _state:Label;
		// 立即完成
		private var _btnCleanCD:Button;
		// 选中底条
//		private var _pickBelt:ImageLoader;
		private var _pickBelt:Scale3Image;
		
		private var _markTime:int = 0;
		
		
		public function CJHeroTrainPickItem()
		{
			super("CJDataTrainPickItem", true);
		}
		
		override public function dispose():void
		{
			Starling.juggler.remove(this);
			
			super.dispose();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this.drawContent();
			
			Starling.juggler.add(this);
		}
		
		private function drawContent():void
		{
			this.width = ITEMWIDTH;
			this.height = ITEMHEIGHT;
			
			_btnhide.x = 0;
			_btnhide.y = 0;
			_btnhide.width = ITEMWIDTH;
			_btnhide.height = ITEMHEIGHT;
			addChild(_btnhide);
			
			const offsetY:int = 10;
			// 复选框
			_checkbox = new CJEnhanceLayerCheckbox;
			_checkbox.initLayer();
			_checkbox.x = 5;
			_checkbox.y = offsetY;
			_checkbox.checked = false;
			addChild(_checkbox);
			
			// 武将名称
			_heroname = new Label;
			_heroname.x = 20;
			_heroname.y =  offsetY;
			addChild(_heroname);
			
			
			var textFormat:TextFormat;
			// 武将等级
			_herolevel = new Label;
			_herolevel.x = 105;
			_herolevel.y = offsetY;
			textFormat = ConstTextFormat.textformatgreencenter;
			textFormat.size = 12
			_herolevel.textRendererProperties.textFormat = ConstTextFormat.textformatgreencenter;
			addChild(_herolevel);
			
			// 冷却时间
			_cooltime = new Label;
			_cooltime.x = 155;
			_cooltime.y = offsetY;
			_cooltime.width = 96;
			textFormat = ConstTextFormat.textformatlightbluecenter;
			textFormat.size = 12
			_cooltime.textRendererProperties.textFormat = textFormat;
			_cooltime.text = DEFAULT_TIME_SHOW;
			addChild(_cooltime);
			
			// 状态
			_state = new Label;
			_state.x = 262;
			_state.y = offsetY;
			textFormat = ConstTextFormat.textformatwhite;
			textFormat.size = 12
			_state.textRendererProperties.textFormat = textFormat;
			addChild(_state);
			
			// 立即完成按钮
			_btnCleanCD = new Button;
			_btnCleanCD.defaultSkin = new SImage( SApplication.assets.getTexture("common_tipanniu01") );
			_btnCleanCD.downSkin = new SImage( SApplication.assets.getTexture("common_tipanniu02") );
			_btnCleanCD.x = 305;
			_btnCleanCD.y = 5; 
			_btnCleanCD.width = 57;
			_btnCleanCD.height = 22;
			_btnCleanCD.defaultLabelProperties.textFormat = ConstTextFormat.textformatblackleft;
			_btnCleanCD.label = CJLang("HERO_TRAIN_CLEAN_CD");
			_btnCleanCD.addEventListener(Event.TRIGGERED, _onCleanCD);
			addChild(_btnCleanCD);
			
			// 底条
//			_pickBelt = new ImageLoader;
//			_pickBelt.source = SApplication.assets.getTexture("wujiangxunlian_xuanzhong");
			
			_pickBelt = new Scale3Image(new Scale3Textures(SApplication.assets.getTexture("common_liebiaoxuanzhong") , 5 , 5));
			_pickBelt.x = -5;
			_pickBelt.width = ITEMWIDTH;
			_pickBelt.height = ITEMHEIGHT;
			addChild(_pickBelt);
		}
		
		override protected function onSelected():void
		{
			
			CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_HERO_TRAIN_PICK_ITEM, false, data);
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
//				data.remaintime = trainData[heroInfo.heroid] == null ? 0 : int(trainData[heroInfo.heroid]);
//				data.isSelected = false;
				
				// checkbox
				if (data.state == ConstHeroTrain.HERO_STATE_IDLE) // 空闲中
				{
					_checkbox.visible = true;
					if (data.isSelected)
						_checkbox.checked = true;
					else
						_checkbox.checked = false;
				}
				else
					_checkbox.visible = false;
				
				// 武将名称
				var textFormat:TextFormat = ConstTextFormat.getFormatByQuality(int(data.quality));
				textFormat.size = 12;
				_heroname.textRendererProperties.textFormat = textFormat;
				_heroname.text = data.name;
				
				// 武将等级
				_herolevel.text = CJLang("HERO_TRAIN_LV") + " " + data.level;
				
				// 添加结束时间
				_cooltime.text = _formatTime(data.remaintime);
				
				// 复选框   消除冷却按钮
				_checkbox.visible = false;
				_btnCleanCD.visible = false;
				// 状态
				if (data.state == ConstHeroTrain.HERO_STATE_BUSY)
				{
					_state.text = CJLang("HERO_TRAIN_STATE_BUSY");
					_btnCleanCD.visible = true; // 设置取消冷却时间按钮的显示状态
				}
				else if (data.state == ConstHeroTrain.HERO_STATE_IDLE)
				{
					_state.text = CJLang("HERO_TRAIN_STATE_IDLE");
					_checkbox.visible = true;
				}
				else if (data.state == ConstHeroTrain.HERO_STATE_FULL)
					_state.text = CJLang("HERO_TRAIN_STATE_FULL");
				else if (data.state == ConstHeroTrain.HERO_STATE_LIMIT)
					_state.text = CJLang("HERO_TRAIN_STATE_LIMIT");
				
				// 选中底条
				_pickBelt.visible = false;
				if (data.state == ConstHeroTrain.HERO_STATE_IDLE && data.isSelected)
					_pickBelt.visible = true;
			}
		}
		
		/**
		 * 每隔一段时间添加一次
		 * @param time
		 */
		public function advanceTime(time:Number):void
		{
			// TODO Auto Generated method stub
			if (data == null || data.starttime == 0)
				return;
			
			_newtime += time;
			if ( _newtime - _oldtime < 1)
				return;
			_oldtime = _newtime;
			
			if (data.remaintime <= 0)
				return;
			
			// 为防止程序切入后台，进行的逻辑处理
			var date:Date = new Date();
			var nowTime:int = int(date.time/1000)
			if (_markTime == 0)
				_markTime = nowTime;
			
			var difference:int = nowTime - _markTime;
			if (difference > 0)
			{
				data.remaintime -= difference;
				_markTime = nowTime;
			}
			// 为防止程序切入后台，进行的逻辑处理 end
			
			// 冷却时间
			_cooltime.text = _formatTime(data.remaintime);
			
			if (data.remaintime == 0)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_HERO_TRAIN_TIME_UP);
			}
		}
		
		private function _formatTime(time:uint):String
		{
			var h:Number = Math.floor( time / 3600); 
			var m:Number = Math.floor( ( time - h * 3600 ) / 60 ); 
			var s:Number = time - h * 3600 - m * 60;
			
			var sh:String = h.toString()
			var sm:String = m.toString(); 
			var ss:String = s.toString();
			if (sh.length == 1)
				sh = "0" + sh;
			if (sm.length == 1)
				sm = "0" + sm;
			if (ss.length == 1)
				ss = "0" + ss;
			
			return sh + ":" + sm + ":" + ss;
		}
		
		// 点击清空冷却时间
		private function _onCleanCD(e:Event):void
		{
			var heroInfo:CJDataOfHero = CJDataManager.o.DataOfHeroList.getHero(String(data.heroid));
			if (heroInfo == null)
				return;
			
			// 判断该武将是否是主将
			if( heroInfo.isRole )
			{
				var viplevel:int = CJDataManager.o.DataOfRole.vipLevel;
				var vipFuncJs:Json_vip_function_setting = CJDataOfVipFuncSetting.o.getData(String(viplevel));
				var maxTrainCount:int = int(vipFuncJs.hero_traincount);
//				var maxTrainCount:int = int(CJDataOfGlobalConfigProperty.o.getData("MAX_TRAIN_COUNT"));
				var traincount:int = CJDataManager.o.DataOfHeroTrain.trainCount;
				if ( traincount >= maxTrainCount )
				{
					new CJTaskFlowString(CJLang("HERO_TRAIN_CAN_NOT_CLEAN_CD"), 1, 20).addToLayer();
					return;
				}
			}
			
			var baseGold:Number = Number(CJDataOfGlobalConfigProperty.o.getData("HERO_TRAIN_GOLD_BASE"));
			var cost:uint = Math.ceil(baseGold * data.remaintime);
			CJConfirmMessageBox(CJLang("HERO_TRAIN_CLEAN_CD_DES", {"cost":cost}), sendCleanCD);
		}
		
		private function sendCleanCD():void
		{
			SocketCommand_heroTrain.clean_cd(data.heroid);
		}
		
	}
}