package SJ.Game.formation
{
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfAssistantInFormation;
	import SJ.Game.data.CJDataOfFormation;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import starling.events.Event;

	/**
	 +------------------------------------------------------------------------------
	 * @name 放置所有的方块
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-4-13 下午4:39:24  
	 +------------------------------------------------------------------------------
	 */
	public class CJFormationSquarePanel extends SLayer
	{
		/*当前阵型数据*/
		private var _formationData:CJDataOfFormation = null;
		
		public function CJFormationSquarePanel()
		{
			super();
		}
		
		override protected function initialize():void
		{
			this._drawContent();
			this._initData();
			super.initialize();
		}
		
		private function _initData():void
		{
			_formationData = CJDataManager.o.DataOfFormation;
			if(_formationData.dataIsEmpty)
			{
				return;
			}
			else
			{
				//处理夺宝雇佣武将位置
				if(CJDataManager.o.DataOfFormation.formationKey == CJDataOfFormation.ENTER_FROM_DUOBAO)
				{
					this._dealDuoBaoEmployHero();
				}
				
				this._formationData.addEventListener(CJDataOfFormation.FORMATION_DATA_CHANGED , this._updateSquare);
				this._showHero();
			}
		}
		
		/**
		 * 默认给第一个空位
		 */ 
		private function _dealDuoBaoEmployHero():void
		{
			var pos:int = CJDataManager.o.DataOfFormation.getFirstEmptyPos();
//			SocketCommand_duobao.saveEmployHeroFormation(pos);
			
			CJDataManager.o.DataOfDuoBaoEmploy.formationIndex = pos;
			CJDataManager.o.DataOfFormation['pos'+pos] = CJDataManager.o.DataOfDuoBaoEmploy.employHeroId;
		}
		
		private function _updateSquare(e:Event):void
		{
			if(e.target is CJDataOfFormation)
			{
				var list:Array = CJFormationSquareManager.o.getSquareList();
				for(var i:int = 0 ; i< CJFormationSquareManager.SQUARE_NUM ; i++)
				{
					var square:CJFormationSquare = list[i] as CJFormationSquare;
					//已经设置了助战武将的位置
					var isAssistantPosSet:Boolean;
					if (!isAssistantPosSet && e.data && e.data.posTo >= 0 && e.data.posTo <= 5)
					{
						var dataAssistantInFormation:CJDataOfAssistantInFormation = CJDataManager.o.DataOfAssistantInFormation;
						var currentHeroId:String = this._formationData.getHeroIdByPos(e.data.posTo);
						if (e.data.posFrom >= 0 && e.data.posFrom <= 5)
						{
							var replacedHeroId:String = this._formationData.getHeroIdByPos(e.data.posFrom);
						}
						if (this._formationData.assistantHeroId && this._formationData.dataAssistant)
						{
							if (this._formationData.assistantHeroId == currentHeroId)
							{
								this._formationData.dataAssistant.assistantHeroPos = e.data.posTo;
								CJDataManager.o.DataOfAssistantInFormation.assistantHeroPos = e.data.posTo;
								dataAssistantInFormation.saveToCache();
								isAssistantPosSet = true;
							}
							else if (replacedHeroId && this._formationData.assistantHeroId == replacedHeroId)
							{
								this._formationData.dataAssistant.assistantHeroPos = e.data.posFrom;
								CJDataManager.o.DataOfAssistantInFormation.assistantHeroPos = e.data.posFrom;
								dataAssistantInFormation.saveToCache();
								isAssistantPosSet = true;
							}
						}
					}
					square.updateStatus(e.data);
				}
			}
		}
		
		/**
		 *  显示武将
		 */		
		private function _showHero():void
		{
			var list:Array = CJFormationSquareManager.o.getSquareList();
			for(var i:int = 0 ; i< CJFormationSquareManager.SQUARE_NUM ; i++)
			{
				var square:CJFormationSquare = list[i] as CJFormationSquare;
				square.showHero();
			}
		}
		
		private function _drawContent():void
		{
			//画底
			this._setBackGround();
			//画方块 ，前后景问题
			var squareList:Array = CJFormationSquareManager.o.getSquareList();
			this.addChild(squareList[3]);
			this.addChild(squareList[0]);
			this.addChild(squareList[4]);
			this.addChild(squareList[1]);
			this.addChild(squareList[5]);
			this.addChild(squareList[2]);
		}
		
		private function _setBackGround():void
		{
			var image:SImage
			var initx:Number = 65;
			var inity:Number = 108;
			for(var i:int =0 ; i < 3 ; i++)
			{
				image = new SImage(SApplication.assets.getTexture("zhenxing_liugekuang"));
				image.x = initx - i*30;
				image.y = inity + i*42;
				image.alpha = 0.8;
				this.addChild(image);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(this._formationData)
			{
				this._formationData.removeEventListeners();
				this._formationData = null;
				this.removeFromParent(true);
			}
		}
	}
}