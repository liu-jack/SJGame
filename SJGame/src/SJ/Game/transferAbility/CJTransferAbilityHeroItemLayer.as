package SJ.Game.transferAbility
{
	import SJ.Common.Constants.ConstHero;
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTransferAbility;
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketCommand_transferAbility;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJFlyWordsUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfEnhanceEquip;
	import SJ.Game.data.CJDataOfEnhanceHero;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfTransferAbility;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.enhanceequip.CJEnhanceLayerStar;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.player.CJPlayerData;
	import SJ.Game.player.CJPlayerNpc;
	
	import engine_starling.Events.DataEvent;
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	import engine_starling.utils.SStringUtils;
	import engine_starling.utils.STween;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	
	import flash.filters.ConvolutionFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	/**
	 * 武将界面
	 * @author zhengzheng
	 * 
	 */	
	public class CJTransferAbilityHeroItemLayer extends SLayer
	{
		/** 星级*/
		private var _labStarLv:Label;
		/** 等级*/
		private var _labLv:Label;
		/** 强化*/
		private var _labEnhance:Label;
		/** 武器*/
		private var _labWeapon:Label;
		/** 披风*/
		private var _labCloak:Label;
		/** 鞋子*/
		private var _labShoes:Label;
		/** 头盔 */
		private var _labHelmet:Label;
		/** 盔甲*/
		private var _labArmour:Label;
		/** 腰带*/
		private var _labBelt:Label;
		/** 是否已经添加武将*/
		private var _isAddHero:Boolean;
		/** 武将星级 **/
		protected var _heroStarPanel:CJEnhanceLayerStar;
		/** 方块的id*/
		private var _id:int = 0;
		/*方块放置的武将*/
		private var _npc:CJPlayerNpc = null;
		//传功阵型信息
		private var _transferAbilityData:CJDataOfTransferAbility;
		/** 武将名称 */
		private var _heroName:TextField;
		/** 服务器装备强化数据 */
		private var _enhanceEquipData:CJDataOfEnhanceEquip;
		/** 当前选中武将强化数据 */
		private var _curHeroEnhanceData:CJDataOfEnhanceHero;
		/** 当前武将数据 */
		private var _curHeroData:CJDataOfHero;
		/** 点击的点 */
		private var _touchPoint:Point;
		/** 拖动武将的虚影 **/
		private var _shadow:CJPlayerNpc = null;
		/*虚影层，防止引起重绘*/
		private var _shadowLayer:SLayer;
		/** 武将背景旋转动画*/
		private var _heroRotateTween:STween;
		
		public function CJTransferAbilityHeroItemLayer()
		{
			super();
		}
		
		
		override protected function initialize():void
		{
			super.initialize();
			_initData();
		}
		
		private function _init():void
		{
			_drawContent();
			_addListeners();
		}
		/**
		 * 添加监听 
		 * 
		 */		
		private function _addListeners():void
		{
			this.addEventListener(TouchEvent.TOUCH , _touchHandler);
			_transferAbilityData.addEventListener(CJDataOfTransferAbility.TRANS_FORMATION_DATA_CHANGED , this._updateSquare);
		}
		
		override public function dispose():void
		{
			this.removeEventListener(TouchEvent.TOUCH , _touchHandler);
			if (_enhanceEquipData)
			{
				_enhanceEquipData.removeEventListener(DataEvent.DataLoadedFromRemote , _init);
			}
			if (_transferAbilityData)
			{
				_transferAbilityData.removeEventListener(CJDataOfTransferAbility.TRANS_FORMATION_DATA_CHANGED , this._updateSquare);
			}
			
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadTransInfo);
			if (_heroRotateTween)
			{
				Starling.juggler.remove(_heroRotateTween);
			}
			super.dispose();
		}
		private function _touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(touch != null && touch.target.parent.parent is CJPlayerNpc)
			{
				//开始拖拽武将移除，武将跟随鼠标  先造阴影，然后修改数据
				if(touch.phase == TouchPhase.BEGAN)
				{
					_touchPoint = touch.getLocation(this._npc);
					
					this.removeHero();
					this._createShadow(touch);
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
				}
			}
		}
		/**
		 * 创建武将虚影
		 * @param touch
		 * 
		 */
		private function _createShadow(touch:Touch):void
		{
			var heroId:String = this._transferAbilityData.getHeroIdByPos(this._id);
			if(int(heroId) == 0)
			{
				return;
			}
			
			this._shadow = this._transferAbilityData.getNpc(heroId);
			if(this._shadow == null)
			{
				var heroData:CJDataOfHero = CJDataManager.o.DataOfHeroList.getHero(heroId);
				var playerData:CJPlayerData = new CJPlayerData();
				playerData.heroId = heroData.heroid;
				playerData.templateId = heroData.templateid;
				_shadow = new CJPlayerNpc(playerData , null) ;
				_shadow.lodlevel = CJPlayerNpc.LEVEL_LOD_1;
				_transferAbilityData.addNpc(heroId , _shadow);
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
		/**
		 * 显示拖拽虚影
		 * @param touch
		 * 
		 */
		private function _showShadow(touch:Touch):void
		{
			if(this._shadow)
			{
				var localPoint:Point = this._shadowLayer.globalToLocal(new Point(touch.globalX , touch.globalY));
				this._shadow.x = localPoint.x - _touchPoint.x;
				this._shadow.y = localPoint.y - _touchPoint.y;
			}
		}
		/**
		 * 移除虚影层
		 * 
		 */		
		private function _removeShadow():void
		{
			if(this._shadowLayer && this._shadowLayer.parent)
			{
				this._shadowLayer.removeFromParent();
			}
		}
		
		/**
		 *  放置武将
		 */		
		private function _placeHero(touch:Touch):void
		{
			//找出可放置的方块
			var touchedSquare:CJTransferAbilityHeroItemLayer = this._getPlaceSquare(touch);
			//保存阵型信息 修改Model的数据
			if(this._shadow != null)
			{
				//为空，移除
				if(touchedSquare == null)
				{
					_transferAbilityData.saveFormation(this._shadow.playerData.heroId ,-1 , this._id);
					return;
				}
				else
				{
					_transferAbilityData.saveFormation(this._shadow.playerData.heroId,touchedSquare.id ,this._id);
				}
			}
		}
		
		/**
		 * 找出可放置武将的方块 
		 * @param touch
		 * @return 
		 */		
		private function _getPlaceSquare(touch:Touch):CJTransferAbilityHeroItemLayer
		{
			var transferAbilityLayer:CJTransferAbilityLayer = this.parent.parent as CJTransferAbilityLayer;
			var list:Array = transferAbilityLayer.arrayHero;
			for each(var square:CJTransferAbilityHeroItemLayer in list)
			{
				if(square.checkHitMe(touch.getLocation(square)))
				{
					return square;
				}
			}
			return null;
		}
		/**
		 * 更新武将动画显示
		 * @param e
		 * 
		 */		
		private function _updateSquare(e:Event):void
		{
			if(e.target is CJDataOfTransferAbility)
			{
				var list:Array = (this.parent.parent as CJTransferAbilityLayer).arrayHero;
				for(var i:int = 0 ; i< list.length ; i++)
				{
					var square:CJTransferAbilityHeroItemLayer = list[i] as CJTransferAbilityHeroItemLayer;
					var changeData:Object = e.data;
					square._updateStatus(changeData);
				}
				//当左边有武将，右边没有武将的时候，重新设置左边武将的显示信息
				var leftHeroId:String = _transferAbilityData.getHeroIdByPos(0);
				var rightHeroId:String = _transferAbilityData.getHeroIdByPos(1);
				if (ConstTransferAbility.leftHeroData && !SStringUtils.isEmpty(leftHeroId) && SStringUtils.isEmpty(rightHeroId))
				{
					_setLeftHeroInfo();
				}
			}
		}
		
		private function _updateStatus(changeData:Object):void
		{
			if (changeData == null)
				return;
			if(changeData.posTo == this._id || changeData.posFrom == this._id)
			{
				this._showHeroInfo();
			}
			
		}
		
		/**
		 * 显示武将 
		 */		
		private function _showHeroInfo():void
		{
			if(this._npc != null && this._npc.parent == this)
			{
				this.removeHero();
				this._npc = null;
			}
			var currentHeroId:String = this._transferAbilityData.getHeroIdByPos(this._id);
			if(int(currentHeroId) == 0 || int(currentHeroId) == -1)
			{
				diposeShowData(this._id);
				return;
			}
			_npc = this._transferAbilityData.getNpc(currentHeroId);
			_curHeroData = CJDataManager.o.DataOfHeroList.getHero(currentHeroId);
			if (_curHeroData == null)
				return;
			//保存左侧武将数据
			if (this._id == 0)
			{
				ConstTransferAbility.leftHeroData = _curHeroData;
				ConstTransferAbility.leftHeroEnhanceData = this._enhanceEquipData.getHeroEnhanceInfo(currentHeroId)
			}
			if(_npc == null)
			{
				var playerData:CJPlayerData = new CJPlayerData();
				playerData.heroId = _curHeroData.heroid;
				playerData.templateId = _curHeroData.templateid;
				playerData.formationId = this._id;
				_npc = new CJPlayerNpc(playerData , null);
				_npc.scaleX = 1.2;
				_npc.scaleY = 1.2;
				_npc.lodlevel = CJPlayerNpc.LEVEL_LOD_1;
//				_npc.lodlevel = CJPlayerNpc.LEVEL_LOD_1 | CJPlayerNpc.LEVEL_LOD_2;
				_npc.hidebattleInfo();
				_transferAbilityData.addNpc(currentHeroId , _npc);
			}
			_npc.alpha = 1;
			_npc.x = 83;
			_npc.y = 120;
			this.addChild(_npc);
			
			// 武将名称
			var heroProperty:CJDataHeroProperty = CJDataOfHeroPropertyList.o.getProperty(_curHeroData.templateid);
			_heroName.text = CJLang(heroProperty.name);
			_heroName.color = ConstHero.ConstHeroNameColor[int(heroProperty.quality)];
			//当武将已经放满，并且再次把武将拖放到左侧时，不走此逻辑
			if (_transferAbilityData.hasAddHeroNum != ConstTransferAbility.TRANSFER_ABILITY_HERO_NUM || this._id != 0)
			{
				setCurHeroInfo(_curHeroData);
			}
			
			//判断是不是显示左边传功后的武将数值
			if (_transferAbilityData.hasAddHeroNum == ConstTransferAbility.TRANSFER_ABILITY_HERO_NUM)
			{
				var heroidnew:String = _transferAbilityData.getHeroIdByPos(0);
				var heroidold:String = _transferAbilityData.getHeroIdByPos(1);
				//添加数据到达监听 
				SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadTransInfo);
				SocketCommand_transferAbility.getTransInfo(heroidnew, heroidold);
			}
		}
		
		/**
		 * 加载服务器传功相关数据
		 * @param e Event
		 * 
		 */		
		private function _onloadTransInfo(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() == ConstNetCommand.CS_TRANS_GET_TRANS_INFO)
			{
				SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadTransInfo);
				ConstTransferAbility.loadTransInfoRetCode = message.retcode;
				switch(ConstTransferAbility.loadTransInfoRetCode)
				{
					case ConstTransferAbility.TRANSFER_ABILITY_SUCCESS:
						ConstTransferAbility.isLvReach = true;
						ConstTransferAbility.transInfo = message.retparams;
						CJEventDispatcher.o.dispatchEventWith(ConstTransferAbility.TRANSFER_ABILITY_NEED_MYAX_NUM , false , {"count":ConstTransferAbility.transInfo.count});
						updateDataIsUseMyax();
						break;
					case ConstTransferAbility.TRANSFER_ABILITY_HERO_NEW_NOT_EXIST:
						CJFlyWordsUtil(CJLang("TRANSFER_ABILITY_HERO_NEW_NOT_EXIST"));
						_refreshCurData();
						break;
					case ConstTransferAbility.TRANSFER_ABILITY_HERO_OLD_NOT_EXIST:
						CJFlyWordsUtil(CJLang("TRANSFER_ABILITY_HERO_OLD_NOT_EXIST"));
						_refreshCurData();
						break;
					case ConstTransferAbility.TRANSFER_ABILITY_HERO_NEW_IS_MAIN_HERO:
						CJFlyWordsUtil(CJLang("TRANSFER_ABILITY_HERO_NEW_IS_MAIN_HERO"));
						_refreshCurData();
						break;
					case ConstTransferAbility.TRANSFER_ABILITY_HERO_OLD_IS_MAIN_HERO:
						CJFlyWordsUtil(CJLang("TRANSFER_ABILITY_HERO_OLD_IS_MAIN_HERO"));
						_refreshCurData();
						break;
					case ConstTransferAbility.TRANSFER_ABILITY_HERO_OLD_LV_NOT_REACH:
						ConstTransferAbility.isLvReach = false;
						CJFlyWordsUtil(CJLang("TRANSFER_ABILITY_HERO_OLD_LV_NOT_REACH"));
						_refreshCurData();
						break;
					default:
						Assert(false, "传功返回码错误");
						break;
				}
			}
		}
		/**
		 * 设置当前左侧武将显示信息
		 * 
		 */		
		private function _setLeftHeroInfo():void
		{
			var list:Array = (this.parent.parent as CJTransferAbilityLayer).arrayHero;
			var leftHeroItem:CJTransferAbilityHeroItemLayer = list[0] as CJTransferAbilityHeroItemLayer;
			var heroDict:Dictionary = CJDataManager.o.DataOfHeroList.herolist;
			var curHeroId:String = ConstTransferAbility.leftHeroData.heroid;
			for each(var hero:CJDataOfHero in heroDict) 
			{
				if (hero.heroid == curHeroId)
				{
					//武将星级
					leftHeroItem.heroStarPanel.level = int(hero.starlevel);
					leftHeroItem.heroStarPanel.redrawLayer();
					leftHeroItem.heroStarPanel.visible = true;
					//武将等级
					leftHeroItem.labLv.text = CJLang("TRANSFER_ABILITY_LV").replace("{heroLevel}", ("LV" + hero.level));
					break;
				}
			}
			if (ConstTransferAbility.leftHeroEnhanceData)
			{
				leftHeroItem.labWeapon.text = CJLang("TRANSFER_ABILITY_WEAPON").replace("{enchanceNum}", String(ConstTransferAbility.leftHeroEnhanceData.weapon));
				leftHeroItem.labCloak.text = CJLang("TRANSFER_ABILITY_CLOAK").replace("{enchanceNum}", String(ConstTransferAbility.leftHeroEnhanceData.cloak));
				leftHeroItem.labShoes.text = CJLang("TRANSFER_ABILITY_SHOES").replace("{enchanceNum}", String(ConstTransferAbility.leftHeroEnhanceData.shoe));
				leftHeroItem.labHelmet.text = CJLang("TRANSFER_ABILITY_HELMET").replace("{enchanceNum}", String(ConstTransferAbility.leftHeroEnhanceData.head));
				leftHeroItem.labArmour.text = CJLang("TRANSFER_ABILITY_ARMOUR").replace("{enchanceNum}", String(ConstTransferAbility.leftHeroEnhanceData.armour));
				leftHeroItem.labBelt.text = CJLang("TRANSFER_ABILITY_BELT").replace("{enchanceNum}", String(ConstTransferAbility.leftHeroEnhanceData.belt));
			}
			else
			{
				_setInitEnhanceData(leftHeroItem);
			}
		}
		/**
		 * 设置强化装备位初始数据
		 * 
		 */		
		private function _setInitEnhanceData(heroItem:CJTransferAbilityHeroItemLayer):void
		{
			heroItem.labWeapon.text = CJLang("TRANSFER_ABILITY_WEAPON").replace("{enchanceNum}", "0");
			heroItem.labCloak.text = CJLang("TRANSFER_ABILITY_CLOAK").replace("{enchanceNum}", "0");
			heroItem.labShoes.text = CJLang("TRANSFER_ABILITY_SHOES").replace("{enchanceNum}", "0");
			heroItem.labHelmet.text = CJLang("TRANSFER_ABILITY_HELMET").replace("{enchanceNum}", "0");
			heroItem.labArmour.text = CJLang("TRANSFER_ABILITY_ARMOUR").replace("{enchanceNum}", "0");
			heroItem.labBelt.text = CJLang("TRANSFER_ABILITY_BELT").replace("{enchanceNum}", "0");
		}
		/**
		 * 刷新当前显示数据
		 * 
		 */		
		private function _refreshCurData():void
		{
			setCurHeroInfo(_curHeroData);
			_setLeftHeroInfo();
			CJEventDispatcher.o.dispatchEventWith(ConstTransferAbility.TRANSFER_ABILITY_NEED_MYAX_NUM , false , {"count":0});
		}
		/**
		 * 设置当前拖动武将显示信息
		 * 
		 */		
		public function setCurHeroInfo(heroData:CJDataOfHero):void
		{
			var heroDict:Dictionary = CJDataManager.o.DataOfHeroList.herolist;
			var curHeroId:String = heroData.heroid;
			for each(var hero:CJDataOfHero in heroDict) 
			{
				if (hero.heroid == curHeroId)
				{
					//武将星级
					this.heroStarPanel.level = int(hero.starlevel);
					this.heroStarPanel.redrawLayer();
					this.heroStarPanel.visible = true;
					//武将等级
					this.labLv.text = CJLang("TRANSFER_ABILITY_LV").replace("{heroLevel}", ("LV" + hero.level));
					break;
				}
			}
			//强化等级
			this._curHeroEnhanceData = this._enhanceEquipData.getHeroEnhanceInfo(curHeroId);
			if (_curHeroEnhanceData)
			{
				this.labWeapon.text = CJLang("TRANSFER_ABILITY_WEAPON").replace("{enchanceNum}", String(_curHeroEnhanceData.weapon));
				this.labCloak.text = CJLang("TRANSFER_ABILITY_CLOAK").replace("{enchanceNum}", String(_curHeroEnhanceData.cloak));
				this.labShoes.text = CJLang("TRANSFER_ABILITY_SHOES").replace("{enchanceNum}", String(_curHeroEnhanceData.shoe));
				this.labHelmet.text = CJLang("TRANSFER_ABILITY_HELMET").replace("{enchanceNum}", String(_curHeroEnhanceData.head));
				this.labArmour.text = CJLang("TRANSFER_ABILITY_ARMOUR").replace("{enchanceNum}", String(_curHeroEnhanceData.armour));
				this.labBelt.text = CJLang("TRANSFER_ABILITY_BELT").replace("{enchanceNum}", String(_curHeroEnhanceData.belt));
			}
			else
			{
				_setInitEnhanceData(this);
			}
		}
		/**
		 * 在选择是否使用传功丹时刷新左侧武将单元数据
		 */		
		public function updateDataIsUseMyax():void
		{
			if (ConstTransferAbility.transInfo && ConstTransferAbility.loadTransInfoRetCode == ConstTransferAbility.TRANSFER_ABILITY_SUCCESS)
			{
				var data:Object;
				var isUseMyax:Boolean = (this.parent.parent as CJTransferAbilityLayer).checkbox.isChecked;
				//判断是否使用传功丹
				if (isUseMyax)
				{
					data = ConstTransferAbility.transInfo["use"];
				}
				else
				{
					data = ConstTransferAbility.transInfo["notuse"];
				}
				var list:Array = (this.parent.parent as CJTransferAbilityLayer).arrayHero;
				var leftHeroItem:CJTransferAbilityHeroItemLayer = list[0] as CJTransferAbilityHeroItemLayer;
				//武将星级
				leftHeroItem.heroStarPanel.level = data.star;
				leftHeroItem.heroStarPanel.redrawLayer();
				leftHeroItem.heroStarPanel.visible = true;
				//武将等级
				ConstTransferAbility.leftHeroLvAfterTrans = int(data.level);
				leftHeroItem.labLv.text = CJLang("TRANSFER_ABILITY_LV").replace("{heroLevel}", ("LV" + data.level));
				//强化等级
				var enhanceData:Object = data.enhance;
				leftHeroItem.labWeapon.text = CJLang("TRANSFER_ABILITY_WEAPON").replace("{enchanceNum}", String(enhanceData.weapon));
				leftHeroItem.labCloak.text = CJLang("TRANSFER_ABILITY_CLOAK").replace("{enchanceNum}", String(enhanceData.cloak));
				leftHeroItem.labShoes.text = CJLang("TRANSFER_ABILITY_SHOES").replace("{enchanceNum}", String(enhanceData.shoes));
				leftHeroItem.labHelmet.text = CJLang("TRANSFER_ABILITY_HELMET").replace("{enchanceNum}", String(enhanceData.helmet));
				leftHeroItem.labArmour.text = CJLang("TRANSFER_ABILITY_ARMOUR").replace("{enchanceNum}", String(enhanceData.armour));
				leftHeroItem.labBelt.text = CJLang("TRANSFER_ABILITY_BELT").replace("{enchanceNum}", String(enhanceData.belt));
			}
		}
		//文字滤镜效果
		private function _textStroke(tf:TextField):void
		{
			var matrix:Array = [0,1,0,
				1,1,1,
				0,1,0];
			tf.nativeFilters = [new ConvolutionFilter(3,3,matrix,3),
				new GlowFilter(0x000000,1.0,2.0,2.0,5,2)];
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
		 * 初始化数据
		 * 
		 */		
		private function _initData():void
		{
			_transferAbilityData = CJDataOfTransferAbility.o;
			this._enhanceEquipData = CJDataManager.o.getData("CJDataOfEnhanceEquip");
			//强化装备位数据
			if(_enhanceEquipData.dataIsEmpty)
			{
				_enhanceEquipData.addEventListener(DataEvent.DataLoadedFromRemote , _init);
				_enhanceEquipData.loadFromRemote();
			}
			else 
			{
				_init();
			}
		}
		
		/**
		 * 绘制内容
		 * 
		 */		
		private function _drawContent():void
		{
			this.setSize(172, 214);
			// 武将背景底图
			var imgBg:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_hechengwenzidi", 10, 10,1,1);
			imgBg.width = this.width;
			imgBg.height = 143;
			this.addChildAt(imgBg, 0);
			
			// 武将旋转符文背景图
			var heroRotateBg:ImageLoader = new ImageLoader();
			heroRotateBg.source = SApplication.assets.getTexture("zuoqi_dibuyuanquan");
			heroRotateBg.x = 85;
			heroRotateBg.y = 70;
			heroRotateBg.width = 130;
			heroRotateBg.height = heroRotateBg.width;
			heroRotateBg.pivotX = heroRotateBg.width / 2;
			heroRotateBg.pivotY = heroRotateBg.height / 2;
			this.addChildAt(heroRotateBg, 1);
			// 武将背景旋转动画
			_heroRotateTween = new STween( heroRotateBg, 20, Transitions.LINEAR);
			_heroRotateTween.animate("rotation", 2*Math.PI);
			_heroRotateTween.loop = 1;
			Starling.juggler.add(_heroRotateTween);
			
			// 武将底盘
			var heroUnderpan:ImageLoader = new ImageLoader;
			heroUnderpan.source = SApplication.assets.getTexture("common_dizuo");
			heroUnderpan.x = 15;
			heroUnderpan.y = 105;
			this.addChildAt(heroUnderpan, 2);
			
			// 文字底图
			var imgWordsBg:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_tankuangwenzidi", 11, 11,1,1);
			imgWordsBg.width = 173;
			imgWordsBg.height = 68;
			imgWordsBg.y = 146;
			this.addChildAt(imgWordsBg, 3);
			
			_heroStarPanel = new CJEnhanceLayerStar();
			_heroStarPanel.count = ConstHero.ConstMaxHeroStarLevel;
			_heroStarPanel.initLayer();
			_heroStarPanel.x = 31;
			_heroStarPanel.y = 150;
			_heroStarPanel.width = 80;
			_heroStarPanel.height = 15;
			_heroStarPanel.visible = false;
			this.addChildAt(_heroStarPanel, 4);
			
			// 武将名称
			_heroName = new TextField(15, 60, "");
			_heroName.x = 14;
			_heroName.y = 0;
			_textStroke(_heroName);
			this.addChildAt(_heroName, 5);
			
			// 名称左右修饰缝隙
			var nameLeftLine:ImageLoader = new ImageLoader;
			nameLeftLine.source = SApplication.assets.getTexture("common_fengexian02");
			nameLeftLine.x = _heroName.x-3;
			nameLeftLine.y = _heroName.y;
			nameLeftLine.height = heroName.height;
			this.addChildAt(nameLeftLine, 6);
			
			var nameRightLine:ImageLoader = new ImageLoader;
			nameRightLine.source = SApplication.assets.getTexture("common_fengexian02");
			nameRightLine.x = _heroName.x+_heroName.width;
			nameRightLine.y = _heroName.y;
			nameRightLine.height = heroName.height;
			this.addChildAt(nameRightLine, 7);
			
			
			_setTextShow();
		}
		/**
		 * 设置文本显示
		 */		
		private function _setTextShow():void
		{
			var fontFormat:TextFormat = new TextFormat( "黑体", 10, 0xFEEE8D);
			_labStarLv.textRendererProperties.textFormat = fontFormat;
			_labStarLv.text = CJLang("TRANSFER_ABILITY_STAR_LV");
			
			_labLv.textRendererProperties.textFormat = fontFormat;
			_labLv.textRendererFactory = textRender.htmlTextRender;
			_labLv.text = CJLang("TRANSFER_ABILITY_LV").replace("{heroLevel}", "");
			
			_labEnhance.textRendererProperties.textFormat = fontFormat;
			_labEnhance.text = CJLang("TRANSFER_ABILITY_ENHANCE");
			
			_labWeapon.textRendererProperties.textFormat = fontFormat;
			_labWeapon.textRendererFactory = textRender.htmlTextRender;
			_labWeapon.text = CJLang("TRANSFER_ABILITY_WEAPON").replace("{enchanceNum}", "");
			
			_labCloak.textRendererProperties.textFormat = fontFormat;
			_labCloak.textRendererFactory = textRender.htmlTextRender;
			_labCloak.text = CJLang("TRANSFER_ABILITY_CLOAK").replace("{enchanceNum}", "");
			
			_labShoes.textRendererProperties.textFormat = fontFormat;
			_labShoes.textRendererFactory = textRender.htmlTextRender;
			_labShoes.text = CJLang("TRANSFER_ABILITY_SHOES").replace("{enchanceNum}", "");
			
			_labHelmet.textRendererProperties.textFormat = fontFormat;
			_labHelmet.textRendererFactory = textRender.htmlTextRender;
			_labHelmet.text = CJLang("TRANSFER_ABILITY_HELMET").replace("{enchanceNum}", "");
			
			_labArmour.textRendererProperties.textFormat = fontFormat;
			_labArmour.textRendererFactory = textRender.htmlTextRender;
			_labArmour.text = CJLang("TRANSFER_ABILITY_ARMOUR").replace("{enchanceNum}", "");
			
			_labBelt.textRendererProperties.textFormat = fontFormat;
			_labBelt.textRendererFactory = textRender.htmlTextRender;
			_labBelt.text = CJLang("TRANSFER_ABILITY_BELT").replace("{enchanceNum}", "");
		}
		/**
		 * 清除指定武将单元显示数据
		 * 
		 */		
		public function diposeShowData(heroItemId:int):void
		{
			_heroName.text = null;
			var list:Array = (this.parent.parent as CJTransferAbilityLayer).arrayHero;
			var heroItem:CJTransferAbilityHeroItemLayer = list[heroItemId] as CJTransferAbilityHeroItemLayer;
			if (heroItem)
			{
				//武将星级
				heroItem.heroStarPanel.visible = false;
				heroItem.labLv.text = CJLang("TRANSFER_ABILITY_LV").replace("{heroLevel}", "");
				heroItem.labWeapon.text = CJLang("TRANSFER_ABILITY_WEAPON").replace("{enchanceNum}", "");
				heroItem.labCloak.text = CJLang("TRANSFER_ABILITY_CLOAK").replace("{enchanceNum}", "");
				heroItem.labShoes.text = CJLang("TRANSFER_ABILITY_SHOES").replace("{enchanceNum}", "");
				heroItem.labHelmet.text = CJLang("TRANSFER_ABILITY_HELMET").replace("{enchanceNum}", "");
				heroItem.labArmour.text = CJLang("TRANSFER_ABILITY_ARMOUR").replace("{enchanceNum}", "");
				heroItem.labBelt.text = CJLang("TRANSFER_ABILITY_BELT").replace("{enchanceNum}", "");
			}
		}

		
		/**
		 * 检测坐标和方块是否碰撞 
		 * @param touch ended时坐标
		 */		
		public function checkHitMe(p:Point):Boolean
		{
			return this.hitTest(p , true) != null;
		}
		
		
		/** 星级*/
		public function get labStarLv():Label
		{
			return _labStarLv;
		}

		public function set labStarLv(value:Label):void
		{
			_labStarLv = value;
		}

		/** 等级*/
		public function get labLv():Label
		{
			return _labLv;
		}

		public function set labLv(value:Label):void
		{
			_labLv = value;
		}

		/** 强化*/
		public function get labEnhance():Label
		{
			return _labEnhance;
		}

		public function set labEnhance(value:Label):void
		{
			_labEnhance = value;
		}

		/** 武器*/
		public function get labWeapon():Label
		{
			return _labWeapon;
		}

		public function set labWeapon(value:Label):void
		{
			_labWeapon = value;
		}

		/** 披风*/
		public function get labCloak():Label
		{
			return _labCloak;
		}

		public function set labCloak(value:Label):void
		{
			_labCloak = value;
		}

		/** 鞋子*/
		public function get labShoes():Label
		{
			return _labShoes;
		}

		public function set labShoes(value:Label):void
		{
			_labShoes = value;
		}

		/** 头盔 */
		public function get labHelmet():Label
		{
			return _labHelmet;
		}

		public function set labHelmet(value:Label):void
		{
			_labHelmet = value;
		}

		/** 盔甲*/
		public function get labArmour():Label
		{
			return _labArmour;
		}

		public function set labArmour(value:Label):void
		{
			_labArmour = value;
		}

		/** 腰带*/
		public function get labBelt():Label
		{
			return _labBelt;
		}

		public function set labBelt(value:Label):void
		{
			_labBelt = value;
		}

		/** 是否已经添加武将*/
		public function get isAddHero():Boolean
		{
			return _isAddHero;
		}

		public function set isAddHero(value:Boolean):void
		{
			_isAddHero = value;
		}

		/** 武将星级 **/
		public function get heroStarPanel():CJEnhanceLayerStar
		{
			return _heroStarPanel;
		}

		/**
		 * @private
		 */
		public function set heroStarPanel(value:CJEnhanceLayerStar):void
		{
			_heroStarPanel = value;
		}

		/** 方块的id*/
		public function get id():int
		{
			return _id;
		}

		/**
		 * @private
		 */
		public function set id(value:int):void
		{
			_id = value;
		}

		public function get npc():CJPlayerNpc
		{
			return _npc;
		}

		/** 武将名称 */
		public function get heroName():TextField
		{
			return _heroName;
		}

		/**
		 * @private
		 */
		public function set heroName(value:TextField):void
		{
			_heroName = value;
		}
	}
}