package SJ.Game.formation
{
	import flash.geom.Point;
	
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfFormation;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.config.CJDataFormationPositionProperty;
	import SJ.Game.data.config.CJDataFormationPropertyList;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.player.CJPlayerData;
	import SJ.Game.player.CJPlayerNpc;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.Logger;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 +------------------------------------------------------------------------------
	 * @name  表示阵型武将位置的方块
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-4-3 下午1:57:46  
	 +------------------------------------------------------------------------------
	 */
	public class CJFormationSquare extends SLayer
	{
		public const WIDTH:int = 100;
		public const HEIGHT:int = 36;
		/*方块的id ，对应武将位置的id*/
		private var _id:int = 0;
		/*方块的前后排*/
		private var _postiontype:int = 0;
		/*方块放置的武将*/
		private var _npc:CJPlayerNpc = null;
		/*武将的信息*/
		private var _playerData:CJPlayerData = null;
		/*底下的棱形*/
		private var _bg:SImage;
		private var _shadowLayer:SLayer;
		private var _shadow:CJPlayerNpc;
		private var _formationData:CJDataOfFormation;
		private var _touchPoint:Point;
		/*选中红色底*/
		private var _hitBg:SImage;
		
		/**
		 * @params posid:int 方块的标号
		 */		
		public function CJFormationSquare(posid:int)
		{
			this._id = posid;
			var config:CJDataFormationPositionProperty = CJDataFormationPropertyList.o.getFormationByPosid(posid);
			this._postiontype = config.postiontype;
			this.x = config.postionx;
			this.y = config.postiony;
			//init bg
			this._bg =  new SImage(SApplication.assets.getTexture("zhenxing_jiazai"));
			this._bg.visible = false;
			this.addChild(this._bg);
			
			this._hitBg =  new SImage(SApplication.assets.getTexture("xuanzhongdi"));
			this._hitBg.visible = false;
			this._hitBg.x -= 6;
			this._hitBg.y -= 5;
			this.addChild(this._hitBg);
			
			this.addEventListener(TouchEvent.TOUCH , this._touchHandler);
			this._formationData = CJDataManager.o.DataOfFormation;
		}
		
		public function updateStatus(changeData:Object):void
		{
			if (changeData == null)
				return;
			if(changeData.posTo == this._id || changeData.posFrom == this._id)
			{
				this.showHero();
			}
		}
		
		private function _touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(touch != null)
			{
				//开始拖拽武将移除，武将跟随鼠标  先造阴影，然后修改数据
				if(touch.phase == TouchPhase.BEGAN)
				{
					//正在指引，发出下一步事件
					if(CJDataManager.o.DataOfFuncList.isIndicating)
					{
						CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
					}
					
					if(this._npc == null)
					{
						return;
					}
					
					_touchPoint = touch.getLocation(this._npc);
					
					this.removeHero();
					this._createShadow(touch);
					CJFormationSquareManager.o.showSquare();
				}
				
				//拖拽显示虚影
				else if(touch.phase == TouchPhase.MOVED)
				{
					this._showShadow(touch);
				}
				//控制拖拽武将放置
				else if(touch.phase == TouchPhase.ENDED)
				{
					this._removeShadow();
					this._placeHero(touch);
					CJFormationSquareManager.o.hideAllSquare();
				}
			}
		}
		
		private function _createShadow(touch:Touch):void
		{
			var heroId:String = this._formationData.getHeroIdByPos(this._id);
			if(int(heroId) == 0)
			{
				return;
			}
			
			this._shadow = this._formationData.getNpc(heroId);
			if(this._shadow == null)
			{
				var heroData:CJDataOfHero = CJDataManager.o.DataOfHeroList.getHero(heroId);
				var playerData:CJPlayerData = new CJPlayerData();
				playerData.heroId = heroData.heroid;
				playerData.templateId = heroData.templateid;
				_shadow = new CJPlayerNpc(playerData , null) ;
				_shadow.lodlevel = CJPlayerNpc.LEVEL_LOD_1;
				_formationData.addNpc(heroId , _shadow);
			}
			
			_shadow.alpha = 0.7;
			
			this._shadow.mouseQuickEventEnable = false;
			
			this._shadowLayer = new SLayer();
			this._shadowLayer.width = this.stage.width;
			this._shadowLayer.height = this.stage.height;
			this._shadowLayer.touchable = false;
			CJLayerManager.o.tipsLayer.addChild(this._shadowLayer);
			var localPoint:Point = this._shadowLayer.globalToLocal(new Point(touch.globalX , touch.globalY));
			this._shadowLayer.addChildTo(this._shadow , localPoint.x - _touchPoint.x , localPoint.y - _touchPoint.y);
			this._shadow.hidebattleInfo();
		}
		
		private function _showShadow(touch:Touch):void
		{
			if(this._shadow)
			{
				var localPoint:Point = this._shadowLayer.globalToLocal(new Point(touch.globalX , touch.globalY));
				this._shadow.x = localPoint.x - _touchPoint.x;
				this._shadow.y = localPoint.y - _touchPoint.y;
				this._checkAllShowHitBg(touch);
			}
		}
		
		/**
		 *  放置武将
		 */		
		private function _placeHero(touch:Touch):void
		{
			//找出可放置的方块
			var touchedSquare:CJFormationSquare = this._getPlaceSquare(touch);
			//保存阵型信息 修改Model的数据
			if(!_formationData.dataIsEmpty && this._shadow != null)
			{
				//正在指引，发出下一步事件
				if(CJDataManager.o.DataOfFuncList.isIndicating)
				{
					//如果正在指引 ,如果不是放到 1号位置，或者不是从4号位置来的
					if(touchedSquare == null || touchedSquare.id != 1 || this.id != 4)
					{
						CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
//						CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_PRE_STEP);
						//角色归位
						_formationData.saveFormation(this._shadow.playerData.heroId,this._id ,this._id);
						return;
					}
					else
					{
						CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
					}
				}
				
				//为空，移除
				if(touchedSquare == null)
				{
					_formationData.saveFormation(this._shadow.playerData.heroId ,-1 , this._id);
					return;
				}
				else
				{
					_formationData.saveFormation(this._shadow.playerData.heroId,touchedSquare.id ,this._id);
				}
			}
		}
		
		private function _removeShadow():void
		{
			if(_shadow)
			{
				_shadow.removeFromParent();
			}
			if(this._shadowLayer && this._shadowLayer.parent)
			{
				this._shadowLayer.removeFromParent();
			}
			_allHideHitBg();
		}
		
		private function _getPlaceSquare(touch:Touch):CJFormationSquare
		{
			var list:Array = CJFormationSquareManager.o.getSquareList();
			var length:int = list.length;
			
			for each(var square:CJFormationSquare in list)
			{
				if(square.checkHitMe(touch.getLocation(square)))
				{
					return square;
				}
			}
			return null;
		}
		
		/**
		 * 显示武将 
		 */		
		public function showHero():void
		{
			var imgAssistant:SImage = new SImage(SApplication.assets.getTexture("haoyouxitong_zhuzhantubiao"));
			imgAssistant.width = 20;
			imgAssistant.height = 20;
			if(this._npc != null && this._npc.parent == this)
			{
				this.removeHero();
				this._npc = null;
			}
			var currentHeroId:String = this._formationData.getHeroIdByPos(this._id);
			//被移除
			if(int(currentHeroId) == 0 || int(currentHeroId) == -1)
			{
				return;
			}
			_npc = this._formationData.getNpc(currentHeroId);
			if(_npc == null)
			{
				var playerData:CJPlayerData = new CJPlayerData();
				
				//夺宝雇佣武将
				if (CJDataManager.o.DataOfFormation.formationKey == CJDataOfFormation.ENTER_FROM_DUOBAO && currentHeroId == CJDataManager.o.DataOfDuoBaoEmploy.employHeroId)
				{
					playerData.heroId = currentHeroId;
					playerData.templateId = int(CJDataManager.o.DataOfDuoBaoEmploy.employheroTemplateId);
					playerData.formationId = this._id;
					_npc = new CJPlayerNpc(playerData , null);
					_npc.lodlevel = CJPlayerNpc.LEVEL_LOD_1;
					_npc.addChild(imgAssistant);
				}
				//判断是不是助战武将
				else if (currentHeroId == this._formationData.assistantHeroId)
				{
					playerData.heroId = currentHeroId;
					playerData.templateId = int(this._formationData.dataAssistant.assistantHeroTemplateId);
					playerData.formationId = this._id;
					this._formationData.dataAssistant.assistantHeroPos = this._id;
					_npc = new CJPlayerNpc(playerData , null);
					_npc.lodlevel = CJPlayerNpc.LEVEL_LOD_1;
					_npc.addChild(imgAssistant);
				}
				else
				{
					var heroData:CJDataOfHero = CJDataManager.o.DataOfHeroList.getHero(currentHeroId);
					playerData.heroId = heroData.heroid;
					playerData.templateId = heroData.templateid;
					playerData.formationId = this._id;
					_npc = new CJPlayerNpc(playerData , null);
					_npc.lodlevel = CJPlayerNpc.LEVEL_LOD_1;
				}
				_npc.hidebattleInfo();
				_formationData.addNpc(currentHeroId , _npc);
			}
			_npc.alpha = 1;
			
			_npc.x = this.pivotX;
			_npc.y = this.pivotY;
			this.addChildTo(_npc , WIDTH / 2 , HEIGHT/2);
			imgAssistant.x = _npc.x - 50;
			imgAssistant.y = _npc.y - 20;
			Logger.log("add npc to :------>" , "npc :"+_npc.playerData.heroId + " parent:"+_npc.parent+" pos:"+this._id)
		}
		
		private function _checkAllShowHitBg(touch:Touch):void
		{
			var list:Array = CJFormationSquareManager.o.getSquareList();
			var length:int = list.length;
			
			for each(var square:CJFormationSquare in list)
			{
				if(square.checkHitMe(touch.getLocation(square)))
				{
					square.showHit();
				}
				else
				{
					square.hideHit();
				}
			}
		}
		
		private function _allHideHitBg():void
		{
			var list:Array = CJFormationSquareManager.o.getSquareList();
			var length:int = list.length;
			
			for each(var square:CJFormationSquare in list)
			{
				square.hideHit();
			}
		}
		
		/**
		 *  移除武将
		 */		
		public function removeHero():void
		{
			if(this._npc != null)
			{
				this._npc.removeFromParent();
			}
		}
		
		/**
		 * 显示菱形
		 */		
		public function showSquare():void
		{
			this._bg.visible = true;
		}
		
		public function hideSquare():void
		{
			this._bg.visible = false;
		}
		
		/**
		 * 检测坐标和方块是否碰撞 
		 * @param touch ended时坐标
		 */		
		public function checkHitMe(p:Point):Boolean
		{
			return this.hitTest(p , true) != null;
		}
			
		/**
		 *方块销毁 
		 */		
		override public function dispose():void
		{
			super.dispose();
			if(this.parent)
			{
				this.removeFromParent(true);
			}
			this.removeEventListener(TouchEvent.TOUCH , this._touchHandler);
		}
		
		/**
		 *  取得方块的中心坐标
		 */		
		public function getPosition():Point
		{
			return new Point(this.pivotX , this.pivotY);
		}

		public function get postiontype():int
		{
			return _postiontype;
		}
		
		public function get id():int
		{
			return _id;
		}


		public function get formationData():CJDataOfFormation
		{
			return _formationData;
		}

		public function set formationData(value:CJDataOfFormation):void
		{
			_formationData = value;
		}


		public function showHit():void
		{
			this._hitBg.visible = true;
		}
		
		public function hideHit():void
		{
			this._hitBg.visible = false;
		}
	}
}