package SJ.Game.transferAbility
{
	import SJ.Common.Constants.ConstHero;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.CJDataOfTransferAbility;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.player.CJPlayerData;
	import SJ.Game.player.CJPlayerNpc;
	
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	
	import feathers.controls.ImageLoader;
	
	import flash.filters.ConvolutionFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	/**
	 * 传功武将头像单元
	 * @author zhengzheng
	 * 
	 */	
	public class CJTransferAbilityHeroHeadItem extends CJItemTurnPageBase
	{
		/** 控件宽度 **/
		private const CONST_WIDTH:int = 66;
		/** 控件高度 **/
		private const CONST_HEIGHT:int = 70;
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
		

		private var _templateId:int;
		private var _heroId:String;
		
		// 武将头像底框
		private var _imgHeroIconBG:ImageLoader;
		// 武将头像
		private var _imgHeroIcon:ImageLoader;
		// 出战标志
		private var _imgInFormation:ImageLoader;
		// 武将名称
		private var _heroName:TextField;
		//角色数据
		private var _dataRole:CJDataOfRole;
		/** 拖动武将的虚影 **/
		private var _shadow:CJPlayerNpc = null;
		/*虚影层，防止引起重绘*/
		private var _shadowLayer:SLayer;
		//传功阵型信息
		private var _transferAbilityData:CJDataOfTransferAbility;
		public function CJTransferAbilityHeroHeadItem()
		{
			super("CJTransferAbilityHeroHeadItem");
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this._initData();
			this._initControls();
			_addListeners();
		}
		/**
		 * 添加监听
		 * 
		 */		
		private function _addListeners():void
		{
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
				if(touch.target.parent is CJTransferAbilityHeroHeadItem)
				{
					//开始拖拽显示虚影
					if(touch.phase == TouchPhase.BEGAN)
					{
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
						this._placeHero(touch);
					}
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
			this._shadow = this._transferAbilityData.getNpc(this._heroId);
			if(this._shadow == null)
			{
				var playerData:CJPlayerData = new CJPlayerData();
				playerData.heroId = this._heroId;
				playerData.templateId = this._templateId;
				_shadow = new CJPlayerNpc(playerData , null);
				_shadow.scaleX = 1.2;
				_shadow.scaleY = 1.2;
				_shadow.lodlevel = CJPlayerNpc.LEVEL_LOD_1;
//				_shadow.lodlevel = CJPlayerNpc.LEVEL_LOD_1 | CJPlayerNpc.LEVEL_LOD_2;
				_transferAbilityData.addNpc(this._heroId , _shadow);
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
				this._shadow.x = localPoint.x;
				this._shadow.y = localPoint.y;
			}
		}
		
		/**
		 *  放置武将
		 */		
		private function _placeHero(touch:Touch):void
		{
			//移除虚影
			this._removeShadow();
			//找出可放置的方块
			var touchedSquare:CJTransferAbilityHeroItemLayer = this._getPlaceSquare(touch);
			
			//保存阵型信息 修改Model的数据
			if(_transferAbilityData && this._shadow != null && touchedSquare != null)
			{	
				_transferAbilityData.saveFormation(this._shadow.playerData.heroId,touchedSquare.id);
				
			}
		}
		/**
		 * 找出可放置武将的方块 
		 * @param touch
		 * @return 
		 */		
		private function _getPlaceSquare(touch:Touch):CJTransferAbilityHeroItemLayer
		{
			var transferAbilityLayer:CJTransferAbilityLayer = this.owner.parent.parent as CJTransferAbilityLayer;
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
		 * 移除虚影
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
		 * 初始化数据
		 * 
		 */		
		private function _initData():void
		{
			this._dataRole = CJDataManager.o.getData("CJDataOfRole") as CJDataOfRole;
			_transferAbilityData = CJDataOfTransferAbility.o;
		}
		/**
		 * 初始化控件
		 * 
		 */		
		private function _initControls():void
		{
			width = CONST_WIDTH;
			height = CONST_HEIGHT;
			
			// 武将头像底框
			_imgHeroIconBG = new ImageLoader();
			_imgHeroIconBG.source = SApplication.assets.getTexture("common_wujiangkuang");
			_imgHeroIconBG.x = CONST_HEAD_BG_X;
			_imgHeroIconBG.y = CONST_HEAD_BG_Y;
			addChild(_imgHeroIconBG);
			// 武将头像
			_imgHeroIcon = new ImageLoader();
			_imgHeroIcon.x = CONST_HEAD_X;
			_imgHeroIcon.y = CONST_HEAD_Y;
			_imgHeroIcon.pivotX = CONST_HEAD_PIVOT_X;
			_imgHeroIcon.pivotY = CONST_HEAD_PIVOT_Y;
			addChild(_imgHeroIcon);
			
			// 出战标志
			_imgInFormation = new ImageLoader();
			_imgInFormation.x = 6;
			_imgInFormation.y = 55;
			addChild(_imgInFormation);
			
			// 武将名称
			_heroName = new TextField(15, 75, "");
			_heroName.x = 46;
			_heroName.y = 5;
			_textStroke(_heroName);
			addChild(_heroName);
		}
		
		override protected function draw():void
		{
			super.draw();
			
			const isSelectInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(isSelectInvalid) // 判断是否应该刷新
			{
				_heroId = this.data["heroid"];
				_templateId = this.data["templateid"];
				
				var heroProperty:CJDataHeroProperty = CJDataOfHeroPropertyList.o.getProperty(int(_templateId));
				Assert( heroProperty!=null, "CJItemRecastHeroHeadItem--> heroProperty==null" );
				if (heroProperty)
				{
					// 武将头像
					_imgHeroIcon.source = SApplication.assets.getTexture(heroProperty.headicon);
					// 武将名字
					_heroName.text = CJLang(heroProperty.name);
					_heroName.color = ConstHero.ConstHeroNameColor[int(heroProperty.quality)];
					
					_imgHeroIconBG.source = SApplication.assets.getTexture("common_wujiangkuang");
					var isInFormation:Boolean = CJDataManager.o.DataOfFormation.isHeroPlaced(_heroId);
					if (isInFormation)
					{
						_imgInFormation.source = SApplication.assets.getTexture("chuangong_chuzhan");
					}
					else
					{
						_imgInFormation.source = null;
					}
				}
			}
		}
		
		/**
		 * 点击事件
		 * @param selectedIndex
		 * @param item
		 * 
		 */		
		override protected function onSelected():void
		{
			
		}
		
		
		private function _textStroke(tf:TextField):void
		{
			var matrix:Array = [0,1,0,
				1,1,1,
				0,1,0];
			tf.nativeFilters = [new ConvolutionFilter(3,3,matrix,3),
				new GlowFilter(0x000000,1.0,2.0,2.0,5,2)];
		}
		
		public function get templateId():int
		{
			return _templateId;
		}
		
		public function get heroId():String
		{
			return _heroId;
		}
		
		override public function set isSelected(value:Boolean):void
		{
		}
	}
}