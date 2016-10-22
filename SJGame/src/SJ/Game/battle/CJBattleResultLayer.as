package SJ.Game.battle
{
	import SJ.Game.map.CJBattleMapManager;
	
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	
	import starling.animation.Juggler;
	import SJ.Common.Constants.ConstBattle;
	import starling.events.Event;
	
	/**
	 * 
	 * @author zhengzheng
	 * 战斗结果层
	 * 
	 */	
	public class CJBattleResultLayer extends SLayer
	{
		private var _imageShengLi:ImageLoader;
		private var _imageShiBai:ImageLoader;
		private var _juggler:Juggler;
		private var _tongguanParams:Object = null;
		private var _btnBattleResultProp0:Button;
		private var _btnBattleResultProp1:Button;
		private var _btnBattleResultProp2:Button;
		private var _btnBattleResultProp3:Button;
		
		public function CJBattleResultLayer()
		{
			super();
		}
		
		/**
		 * 通关参数属性
		 * 
		 */
		public function get tongguanParams():Object
		{
			return _tongguanParams;
		}
		
		public function set tongguanParams(value:Object):void
		{
			_tongguanParams = value;
		}
		/**
		 * 定时器
		 */
		public function get juggler():Juggler
		{
			return _juggler;
		}

		/**
		 * @private
		 */
		public function set juggler(value:Juggler):void
		{
			_juggler = value;
		}

		public function get imageShengLi():ImageLoader
		{
			return _imageShengLi;
		}
		
		public function set imageShengLi(value:ImageLoader):void
		{
			_imageShengLi = value;
		}
		
		public function get imageShiBai():ImageLoader
		{
			return _imageShiBai;
		}
		
		public function set imageShiBai(value:ImageLoader):void
		{
			_imageShiBai = value;
		}
		
		/**
		 * 战斗结束奖励道具图标0
		 * 
		 */		
		public function get btnBattleResultProp0():Button
		{
			return _btnBattleResultProp0;
		}
		
		public function set btnBattleResultProp0(value:Button):void
		{
			_btnBattleResultProp0 = value;
		}
		
		/**
		 * 战斗结束奖励道具图标1
		 * 
		 */		
		public function get btnBattleResultProp1():Button
		{
			return _btnBattleResultProp1;
		}
		
		public function set btnBattleResultProp1(value:Button):void
		{
			_btnBattleResultProp1 = value;
		}
		
		/**
		 * 战斗结束奖励道具图标2
		 * 
		 */		
		public function get btnBattleResultProp2():Button
		{
			return _btnBattleResultProp2;
		}
		
		public function set btnBattleResultProp2(value:Button):void
		{
			_btnBattleResultProp2 = value;
		}
		
		/**
		 * 战斗结束奖励道具图标3
		 * 
		 */		
		public function get btnBattleResultProp3():Button
		{
			return _btnBattleResultProp3;
		}
		
		public function set btnBattleResultProp3(value:Button):void
		{
			_btnBattleResultProp3 = value;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			//用向量管理战斗结果道具按钮
			var battleResultPropBtns:Vector.<Button> = new Vector.<Button>(ConstBattle.ConstBattleResultPropItems);
			for(var i:uint = 0; i < battleResultPropBtns.length; i++)
			{
				battleResultPropBtns[i] = this["btnBattleResultProp" + i] as Button;
				if(battleResultPropBtns[i] == null)
				{
					continue;
				}
				
				//为每个战斗结果道具按钮添加监听
				battleResultPropBtns[i].addEventListener(starling.events.Event.TRIGGERED, function (e:Event):void{
					//获得战斗结果道具按钮的名称
					var btnName:String = (e.currentTarget as Button).name;
					//获得战斗结果道具按钮的索引
					var index:int = parseInt(btnName.substr(btnName.length - 1, 1));
					//此处添加提示层
				});
			}
		}
		
		
		/**
		 * 判断选择显示输赢图片
		 * @param isWin
		 * 
		 */		
		public function showBattleResult(isWin:Boolean,isTongguan:Boolean):void
		{
			if (isWin)
			{
				_imageShengLi.visible = true;
				_imageShiBai.visible = false;
				//通关条件满足时，会显示通关动画
				if(isTongguan)
				{
					showTongguanAnim();
				}
			}
			else 
			{
				_imageShengLi.visible = false;
				_imageShiBai.visible = true;
			}
		}
		
		
		/**
		 * 通关条件满足时，会显示通关动画
		 * 
		 */		
		public function showTongguanAnim():void
			
		{
			CJBattleTongguanLayer.createTonggaunLayer(this);
		}
	}
}