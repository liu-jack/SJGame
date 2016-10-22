package SJ.Game.formation
{
	import flash.filters.ConvolutionFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	import SJ.Common.Constants.ConstHero;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfFormation;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.json.Json_hero_battle_propertys;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.player.CJPlayerData;
	import SJ.Game.player.CJPlayerNpc;
	
	import engine_starling.SApplication;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SLayer;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	/**
	 +------------------------------------------------------------------------------
	 * @name 英雄Item
	 * @comment 画英雄的头像，显示动画
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-4-1 下午12:13:22  
	 +------------------------------------------------------------------------------
	 */
	public class CJItemHero extends DefaultListItemRenderer
	{
		/*武将头像*/
		private var _logo:ImageLoader;
		/*名字*/
		private var _nameTF:TextField;
		/*头像背景框*/
		private var _logoBG:ImageLoader;
		/*武将的配置id*/
		private var _templateId:String;
		/*武将的静态配置*/
		private var _heroConfig:CJDataHeroProperty;
		/*用户武将的唯一id*/
		private var _heroId:String;
		private var _placedText:TextField;
		private var _formationData:CJDataOfFormation;
		/*虚影*/
		private var _shadow:CJPlayerNpc = null;
		/*虚影层，防止引起重绘*/
		private var _shadowLayer:SLayer;
		//武将出征
		public const HERO_CALLED:String = "hero_called";
		
		private var _newHeroIcon:ImageLoader;
		
		/** 武将头像背景X坐标 **/
		private const CONST_HEAD_BG_X:int = 0;
		/** 武将头像背景Y坐标 **/
		private const CONST_HEAD_BG_Y:int = 10;
		/** 武将头像X坐标 **/
		private const CONST_HEAD_X:int = 35;
		/** 武将头像Y坐标 **/
		private const CONST_HEAD_Y:int = 62;
		/** 武将头像中心点X **/
		private const CONST_HEAD_PIVOT_X:int = 47;
		/** 武将头像中心点Y **/
		private const CONST_HEAD_PIVOT_Y:int = 73;
		/** 控件宽度 **/
		private const CONST_WIDTH:int = 66;
		/** 控件高度 **/
		private const CONST_HEIGHT:int = 65;

		private var _fire:SAnimate;
		
		
		public function CJItemHero()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			_formationData = CJDataManager.o.DataOfFormation;
			this.drawContent();
			//增加拖拽监听事件
			this.addEventListener(TouchEvent.TOUCH , this._startDrag);
		}
		
		/**
		 * 选中武将拖拽处理
		 * @comment : 1.初始选中显示方块  2.结束检测是否可以放置武将 
		 */		
		private function _startDrag(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(touch != null)
			{
				e.stopPropagation();
				if(touch.target.parent is CJItemHero)
				{
					//开始拖拽显示位置方块
					if(touch.phase == TouchPhase.BEGAN)
					{
						//检测该武将是否可以拖拽
						if(_formationData.isHeroPlaced(this._heroId))
						{
							return;
						}
						CJFormationSquareManager.o.showSquare();
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
						this._placeHero(e);
						CJFormationSquareManager.o.hideAllSquare();
					}
				}
			}
		}
		
		private function _removeShadow():void
		{
			if(this._shadowLayer && this._shadowLayer.parent)
			{
				this._shadowLayer.removeFromParent();
			}
			_allHideHitBg();
		}
		
		private function _createShadow(touch:Touch):void
		{
			this._shadow = this._formationData.getNpc(this._heroId);
			if(this._shadow == null)
			{
				var heroData:CJDataOfHero = CJDataManager.o.DataOfHeroList.getHero(this._heroId);
				var playerData:CJPlayerData = new CJPlayerData();
				playerData.heroId = heroData.heroid;
				playerData.templateId = heroData.templateid;
				_shadow = new CJPlayerNpc(playerData , null);
				_shadow.lodlevel = CJPlayerNpc.LEVEL_LOD_1;
				_formationData.addNpc(this._heroId , _shadow);
			}
			_shadow.alpha = 0.7;
			
			this._shadowLayer = new SLayer();
			this._shadowLayer.width = this.stage.width;
			this._shadowLayer.height = this.stage.height;
			this._shadowLayer.touchable = false;
			CJLayerManager.o.tipsLayer.addChild(this._shadowLayer);
			var localPoint:Point = this._shadowLayer.globalToLocal(new Point(touch.globalX , touch.globalY));
			this._shadowLayer.addChildTo(this._shadow , localPoint.x , localPoint.y);
			_shadow.hidebattleInfo();
		}
		
		private function _showShadow(touch:Touch):void
		{
			if(this._shadow)
			{
				var localPoint:Point = this._shadowLayer.globalToLocal(new Point(touch.globalX , touch.globalY));
				this._shadow.x = localPoint.x;
				this._shadow.y = localPoint.y;
			}
			this._checkAllShowHitBg(touch);
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
		 *  放置武将
		 */		
		private function _placeHero(e:TouchEvent):void
		{
			//移除虚影
			this._removeShadow();
			var touch:Touch = e.getTouch(this);
			//找出可放置的方块
			var touchedSquare:CJFormationSquare = this._getPlaceSquare(touch);
			
			//保存阵型信息 修改Model的数据
			if(!_formationData.dataIsEmpty && this._shadow != null && touchedSquare != null)
			{	
				_formationData.saveFormation(this._shadow.playerData.heroId,touchedSquare.id);
				
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
		}
		
		/**
		 * 找出可放置武将的方块 
		 * @param touch
		 * @return 
		 */		
		private function _getPlaceSquare(touch:Touch):CJFormationSquare
		{
			var list:Array = CJFormationSquareManager.o.getSquareList();
			for each(var square:CJFormationSquare in list)
			{
				if(square.checkHitMe(touch.getLocation(square)))
				{
					return square;
				}
			}
			return null;
		}
		
		private function _update(e:Event):void
		{
			this.invalidate(HERO_CALLED);
		}
		
		private function updateStatus():void
		{
			if(int(this._heroId) != 0)
			{
				_placedText.visible = this._formationData.isHeroPlaced(this._heroId);
			}
		}
		
		private function drawContent():void
		{
			this._itemHasIcon = false;
			this._itemHasLabel = false;
			
			this.width = CONST_WIDTH;
			this.height = CONST_HEIGHT;
			//框
			this._logoBG = new ImageLoader();
			this._logoBG.source = SApplication.assets.getTexture("common_wujiangkuang");
			_logoBG.x = CONST_HEAD_BG_X;
			_logoBG.y = CONST_HEAD_BG_Y;
			
			this.addChild(this._logoBG);
			
			//头像
			this._logo = new ImageLoader();
			this._logo.x = CONST_HEAD_X;
			this._logo.y = CONST_HEAD_Y;
			this._logo.pivotX = CONST_HEAD_PIVOT_X;
			this._logo.pivotY = CONST_HEAD_PIVOT_Y;
			this.addChild(this._logo);
			//文字
			_nameTF = new TextField(15 , 60 , "" ,"Verdana" , 12 , 0xEBF8B1 , false);
			_nameTF.x = 46;
			_nameTF.y = 5;
			_drawFlow(_nameTF);
			this.addChild(_nameTF);
			//是否已经放置
			_placedText = new TextField(40 , 18 , CJLang("FORMATION_BATTLE_1001") ,"Verdana" , 12 , 0xEBF8B1 ,false);
			_placedText.x = 0;
			_placedText.y = 4;
			_placedText.visible = false;
			_drawFlow(_placedText);
			this.addChild(_placedText);
			
			_newHeroIcon = new ImageLoader();
			_newHeroIcon.source = SApplication.assets.getTexture("NEW");
			_newHeroIcon.x = 8;
			_newHeroIcon.y = 50;
			_newHeroIcon.visible = true;
			this.addChild(_newHeroIcon);
			
			_fire = new SAnimate(SApplication.assets.getTextures("common_kaiqi"), 6);
			var texture:Texture = SApplication.assets.getTextures("common_kaiqi")[0];
			_fire.pivotX = texture.frame.width/2;
			_fire.pivotY = texture.frame.height/2;
			_fire.x = this.width/2;
			_fire.y = this.height/2 + 5;
			_fire.scaleX = _fire.scaleY = 2;
			this.addChild(_fire);
		}
		
		/**
		 * 字体描边
		 */		
		private function _drawFlow(tf:TextField):void
		{
			var matrix:Array = [0,1,0,
				1,1,1,
				0,1,0];
			tf.nativeFilters = [new ConvolutionFilter(3,3,matrix,3),
				new GlowFilter(0x000000,1.0,2.0,2.0,5,2)];
		}
		
		override protected function draw():void
		{
			const isTotalInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(isTotalInvalid)
			{
				this._heroId = this.data['heroId'];
				this._templateId = this.data['templeteid'];
				
				var isNewHero:Boolean = CJDataManager.o.DataOfHeroList.isNewHero(this._heroId);
				this._newHeroIcon.visible = isNewHero;
				this._fire.visible = isNewHero;
				if(isNewHero)
				{
					Starling.juggler.add(_fire);
				}
				
				this._heroConfig = CJDataOfHeroPropertyList.o.getProperty(int(_templateId));
				// 武将名字
				this._nameTF.text = CJLang(this._heroConfig.name);
				_nameTF.color = ConstHero.ConstHeroNameColor[int(_heroConfig.quality)];
				
				var resproperty:Json_hero_battle_propertys = CJDataOfHeroPropertyList.o.getBattlePropertyWithTemplateId(int(_templateId));
				this._logo.source = SApplication.assets.getTexture("touxiang_"+resproperty.texturename);
				
				//更新是否出征状态
				this.updateStatus();
			}
			const isStatusInvalid:Boolean = this.isInvalid(HERO_CALLED);
			if(isStatusInvalid)
			{
				//更新是否出征状态
				this.updateStatus();
			}
			super.draw();
		}
		
		public function get heroName():String
		{
			return this._heroConfig.name;
		}
		
		public function get templateId():String
		{
			return _templateId;
		}
		
		public function get heroId():String
		{
			return _heroId;
		}
	}
}