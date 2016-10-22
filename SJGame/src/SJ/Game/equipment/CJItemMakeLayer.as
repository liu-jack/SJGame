package SJ.Game.equipment
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstItem;
	import SJ.Common.Constants.ConstItemMake;
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_item;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.activity.CJActivityEventKey;
	import SJ.Game.bag.CJBagItem;
	import SJ.Game.controls.CJFlyWordsUtil;
	import SJ.Game.controls.CJHeartbeatEffectUtil;
	import SJ.Game.controls.CJItemUtil;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfBag;
	import SJ.Game.data.config.CJDataOfItemEquipProperty;
	import SJ.Game.data.config.CJDataOfItemMakeProperty;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_item_equip_config;
	import SJ.Game.data.json.Json_item_make;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.Events.DataEvent;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.ColorMatrixFilter;
	import starling.textures.Texture;
	
	/**
	 * @author zhengzheng
	 * 创建时间：Apr 20, 2013 6:42:24 PM
	 * 装备铸造类
	 */
	public class CJItemMakeLayer extends SLayer
	{
		/**装备模板id*/		
		private var _itemTemplateId:int;
		/**铸造装备个数*/
		private var _itemsNum:int;
		/**装备铸造返回状态*/
		private var _retState:int;
		/**可铸造装备显示层-布局文件中*/
		private var _itemShowLayer:CJItemMakeItemShowLayer;
		/**铸造显示层-布局文件中*/
		private var  _makeShowLayer:SLayer;
		/**铸造装备子类型-全部*/
		private var _btnSubType0:Button;
		/**铸造装备子类型-武器*/
		private var _btnSubType1:Button;
		/**铸造装备子类型-头盔*/
		private var _btnSubType2:Button;
		/**铸造装备子类型-盔甲*/
		private var _btnSubType3:Button;
		/**铸造装备子类型-披风*/
		private var _btnSubType4:Button;
		/**铸造装备子类型-腰带*/
		private var _btnSubType5:Button;
		/**铸造装备子类型-靴子*/
		private var _btnSubType6:Button;
		/**初始化上次选中的铸造装备分类按钮*/
		private var _oldBtn:Button = null;
		
		/**待铸造的装备*/
		private var _btnMakeItem:CJBagItem;
		/**待铸造的装备对应的材料的分类线*/
		private var _imgMaterialLine:ImageLoader
		/**铸造需要的材料0*/
		private var _needMaterialItem0:CJItemMakeMaterialInfoItem;
		/**铸造需要的材料1*/
		private var _needMaterialItem1:CJItemMakeMaterialInfoItem;
		/**铸造需要的材料2*/
		private var _needMaterialItem2:CJItemMakeMaterialInfoItem;
		/**铸造按钮*/
		private var _btnMake:Button;
		/**拥有和需要材料的数量0*/
		private var _labelMaterialInfo0:Label;
		/**拥有和需要材料的数量1*/
		private var _labelMaterialInfo1:Label;
		/**拥有和需要材料的数量2*/
		private var _labelMaterialInfo2:Label;
		/**属性加成-生命*/
		private var _labelProperty0:Label;
		/**属性加成值-生命*/
		private var _labelPropertyValue0:Label;
		/**属性加成-物攻*/
		private var _labelProperty1:Label;
		/**属性加成值-物攻*/
		private var _labelPropertyValue1:Label;
		/**属性加成-物防*/
		private var _labelProperty2:Label;
		/**属性加成值-物防*/
		private var _labelPropertyValue2:Label;
		/**属性加成-法攻*/
		private var _labelProperty3:Label;
		/**属性加成值-法攻*/
		private var _labelPropertyValue3:Label;
		/**属性加成-法防*/
		private var _labelProperty4:Label;
		/**属性加成值-法防*/
		private var _labelPropertyValue4:Label;
		/**铸造情况提示信息*/
		private var _tipsLabel:Label;
		/**铸造装备钱币类型*/
		private var _moneyType:int;
		/**背包数据*/
		private var _bagData:CJDataOfBag;
		/**装备分类子类型*/
		private var _itemSubType:int;
		/**铸造成功特效*/
		private var _starAnim:SAnimate
		
		private var _filter:ColorMatrixFilter;


		public function CJItemMakeLayer()
		{
			super();
		}
		override protected function initialize():void
		{
			super.initialize();
			_initData();
			_drawContent();
			_addListener();
		}
		
		
		private function _drawContent():void
		{
			_filter = new ColorMatrixFilter();
			_filter.adjustSaturation(-1);
			
			//背景底图
			var imgOperateBg:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_dinew", 1 ,1 , 1, 1);
			imgOperateBg.width = this.width;
			imgOperateBg.height = this.height;
			this.addChildAt(imgOperateBg, 0);
			//合成装备显示底图
			var texture:Texture = SApplication.assets.getTexture("common_dinewzhezhao");
			var scale9Texture:Scale9Textures = new Scale9Textures(texture, new Rectangle(40,40 ,3,3));
			var bgItemShow:Scale9Image = new Scale9Image(scale9Texture);
			bgItemShow.x = 180
			bgItemShow.y = 10;
			bgItemShow.width = 230;
			bgItemShow.height = this.height - 20;
			this.addChildAt(bgItemShow, 1);
			
			//滚珠
			var bgBall:CJPanelFrame = new CJPanelFrame(this.width - 8 , this.height - 8);
			bgBall.x = 4;
			bgBall.y = 4;
			this.addChildAt(bgBall, 2);
			
			//操作层 - 外边框图
			var imgOutFrame:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_waikuangnew", 15 , 15 , 1, 1);
			imgOutFrame.width = this.width;
			imgOutFrame.height = this.height;
			this.addChildAt(imgOutFrame, 3);
			
			//属性加成底图
			texture = SApplication.assets.getTexture("common_quanbingdise");
			scale9Texture = new Scale9Textures(texture, new Rectangle(2,2 ,2,2));
			var bgPropertyText:Scale9Image = new Scale9Image(scale9Texture);
			bgPropertyText.alpha = 0.9;
			bgPropertyText.x = 180;
			bgPropertyText.y = 182;
			bgPropertyText.width = 230;
			bgPropertyText.height = 87;
			this.addChildAt(bgPropertyText, 4);
			
			//分割线
			var line:ImageLoader = new ImageLoader();
			line.source = SApplication.assets.getTexture("common_fengexian");
			line.pivotX = line.width / 2;
			line.pivotY = line.height / 2;
			line.rotation = Math.PI / 2;
			line.x = 183;
			line.y = 10;
			line.width = 272;
			line.height = 5;
			this.addChildAt(line, 5);
			
			//默认第一个被选中
			_btnSubType0.isSelected = true;
			//初始化装备铸造插页按钮的默认图片和默认选中图片
			var itemMakeBtns:Vector.<Button> = new Vector.<Button>(ConstItemMake.ITEM_MAKE_ITEMS_NUM);
			for(var i:uint = 0; i < itemMakeBtns.length; i++)
			{
				itemMakeBtns[i] = this["btnSubType" + i] as Button;
				if(null == itemMakeBtns[i]) continue;
				//设置后六个分类的皮肤
				if(i > 0)
				{
					itemMakeBtns[i].defaultSkin = new SImage(SApplication.assets.getTexture("zhuzao_leixing_xuanzhong" + i));
					itemMakeBtns[i].filter = _filter;
				}
				//为每个铸造装备分类按钮添加监听
				itemMakeBtns[i].addEventListener(starling.events.Event.TRIGGERED, _buttonChangeHandler);
			}
			//初始化装备铸造显示层显示道具
			this.addChild(_btnMakeItem);
			this.addChild(_needMaterialItem0);
			this.addChild(_needMaterialItem1);
			this.addChild(_needMaterialItem2);
			this.addChild(_tipsLabel);
		}
		/**
		 * 初始化基本数据
		 */		
		private function _initData():void
		{
			_itemSubType = ConstItem.SCONST_ITEM_SUBTYPE_ALL;
			_bagData = CJDataManager.o.getData("CJDataOfBag");
			_btnSubType0.label = CJLang("ITEM_ALL");
			_labelProperty0.text = CJLang("ITEM_ADD_SHENGMING");
			_labelProperty1.text = CJLang("ITEM_ADD_WUGONG");
			_labelProperty2.text = CJLang("ITEM_ADD_WUFANG");
			_labelProperty3.text = CJLang("ITEM_ADD_FAGONG");
			_labelProperty4.text = CJLang("ITEM_ADD_FAFANG");
			_btnMake.label = CJLang("ITEM_MAKE");
			_btnMake.name = "CJFoundry_0";
			
			//初始化装备铸造显示层显示道具
			_btnMakeItem = new CJBagItem();
			_btnMakeItem.x = ConstItemMake.ITEM_MAKE_SHOW_MAKE_ITEM_X;
			_btnMakeItem.y = ConstItemMake.ITEM_MAKE_SHOW_MAKE_ITEM_Y;
			
			_needMaterialItem0 = new CJItemMakeMaterialInfoItem();
			_needMaterialItem0.x = _labelMaterialInfo0.x + 2;
			_needMaterialItem0.y = ConstItemMake.ITEM_MAKE_SHOW_MATERIAL_INFO_Y;
			 
			_needMaterialItem1 = new CJItemMakeMaterialInfoItem();
			_needMaterialItem1.x = _labelMaterialInfo1.x;
			_needMaterialItem1.y = ConstItemMake.ITEM_MAKE_SHOW_MATERIAL_INFO_Y;
			
			_needMaterialItem2 = new CJItemMakeMaterialInfoItem();
			_needMaterialItem2.x = _labelMaterialInfo2.x;
			_needMaterialItem2.y = ConstItemMake.ITEM_MAKE_SHOW_MATERIAL_INFO_Y;
			
			//初始隐藏铸造提示信息
			_tipsLabel = new Label();
			_tipsLabel.visible = false;
			this.addChild(_tipsLabel);
			_tipsLabel.x = ConstItemMake.ITEM_MAKE_SHOW_TIPS_LABEL_X;
			_tipsLabel.y = ConstItemMake.ITEM_MAKE_SHOW_TIPS_LABEL_Y;
			_tipsLabel.text = CJLang("ITEM_MAKE_TIPS");
			_setTextFormat();
			
		}
		/**
		 * 设置控件的字体 
		 */		
		private function _setTextFormat():void
		{
			var fontFormat:TextFormat;
			//为“全部”分类按钮设置字体
			fontFormat = new TextFormat("Arial", 13, 0xE1DB8A );
			_btnSubType0.defaultLabelProperties.textFormat = fontFormat;
			//为材料信息设置字体格式
			fontFormat = new TextFormat( "Arial", 10, 0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_labelMaterialInfo0.textRendererProperties.textFormat = fontFormat;
			_labelMaterialInfo1.textRendererProperties.textFormat = fontFormat;
			_labelMaterialInfo2.textRendererProperties.textFormat = fontFormat;
			//为属性加成设置字体格式
			fontFormat = new TextFormat( "Arial", 10, 0xFFCF3B );
			_labelProperty0.textRendererProperties.textFormat = fontFormat;
			_labelProperty1.textRendererProperties.textFormat = fontFormat;
			_labelProperty2.textRendererProperties.textFormat = fontFormat;
			_labelProperty3.textRendererProperties.textFormat = fontFormat;
			_labelProperty4.textRendererProperties.textFormat = fontFormat;
			//为属性加成值设置字体格式
			fontFormat = new TextFormat( "Arial", 10, 0xFF6000 );
			_labelPropertyValue0.textRendererProperties.textFormat = fontFormat;
			_labelPropertyValue1.textRendererProperties.textFormat = fontFormat;
			_labelPropertyValue2.textRendererProperties.textFormat = fontFormat;
			_labelPropertyValue3.textRendererProperties.textFormat = fontFormat;
			_labelPropertyValue4.textRendererProperties.textFormat = fontFormat;
			//为铸造按钮设置字体格式
			fontFormat = new TextFormat( "Arial", 13, 0xFFC69D);
			_btnMake.defaultLabelProperties.textFormat = fontFormat;
			//为铸造情况提示信息设置字体格式
			fontFormat = new TextFormat( "Arial", 13, 0xCB3F3B);
			_tipsLabel.textRendererProperties.textFormat = fontFormat;
		}
		
		/**
		 * 为控件添加监听 
		 * 
		 */	
		private function _addListener():void
		{
			//添加背包数据改变监听
			_bagData.addEventListener(DataEvent.DataLoadedFromRemote , _bagDataChangeHandler);
			
			_itemShowLayer.addEventListener(ConstItemMake.ITEM_MAKE_CHANGED,_showItemMakeInfo);
			
			_btnMake.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniuda01new"));
			_btnMake.downSkin = new SImage(SApplication.assets.getTexture("common_anniuda02new"));
			//为铸造按钮添加监听
			_btnMake.addEventListener(starling.events.Event.TRIGGERED, _btnItemMakeTriggered);
			
			//为待铸造的装备添加监听
			_btnMakeItem.addEventListener(starling.events.TouchEvent.TOUCH, _onClickMakeItemTips);
			_needMaterialItem0.addEventListener(starling.events.TouchEvent.TOUCH, _onClickItemTips);
			_needMaterialItem1.addEventListener(starling.events.TouchEvent.TOUCH, _onClickItemTips);
			_needMaterialItem2.addEventListener(starling.events.TouchEvent.TOUCH, _onClickItemTips);
		}
		
		override public function dispose():void
		{
			if (_bagData)
			{
				_bagData.removeEventListener(DataEvent.DataLoadedFromRemote , _bagDataChangeHandler);
			}
			if (_itemShowLayer)
			{
				_itemShowLayer.removeEventListener(ConstItemMake.ITEM_MAKE_CHANGED,_showItemMakeInfo);
			}
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadItemMakeInfo);
			super.dispose();
			_filter.dispose();
		}
		/**
		 * 显示铸造装备的tips信息
		 * @param e
		 * 
		 */		
		private function _onClickMakeItemTips(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if (!touch || touch.phase != TouchPhase.ENDED)
				return;
			if (_itemTemplateId > 0 && e.target is ImageLoader && (e.target as ImageLoader).parent is CJBagItem)
			{
				CJItemUtil.showItemTooltipsWithTemplateId(_itemTemplateId);
			}
		}
		/**
		 * 显示铸造材料的tips信息
		 * @param e
		 * 
		 */		
		private function _onClickItemTips(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if (!touch || touch.phase != TouchPhase.ENDED)
				return;
			if (e.target is ImageLoader && (e.target as ImageLoader).parent.parent is CJItemMakeMaterialInfoItem)
			{
				var clickedMaterialItem:CJItemMakeMaterialInfoItem = (e.target as ImageLoader).parent.parent as CJItemMakeMaterialInfoItem;
				var materialId:int = clickedMaterialItem.materialId;
				if (materialId > 0)
				{
					CJItemUtil.showItemTooltipsWithTemplateId(materialId);
				}
			}
		}
		/**
		 * 触发铸造事件
		 * @param e
		 * 
		 */		
		private function _btnItemMakeTriggered(e:Event):void
		{
			SSoundEffectUtil.playButtonNormalSound();
			//处理指引
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
			
			var makeItem:Json_item_make = CJDataOfItemMakeProperty.o.getItemMakeInfo(_itemTemplateId);
			if (null == makeItem)
			{
				Assert(false, "没有获得要铸造装备的信息！");
				return;
			}
			var needgoldnum:int = makeItem.needgoldnum;
			//判断使用钱币类型
			if (needgoldnum > 0)
			{
				_moneyType = 1;
			}
			else 
			{
				_moneyType = 0;
			}
			var template:Json_item_setting = CJDataOfItemProperty.o.getTemplate(_itemTemplateId);
			var canDoCount:int = CJItemMakeUtil.o.getItemCanDoCount(parseInt(template.id));
			if (canDoCount > 0)
			{
				var canPutInBag:Boolean = CJItemUtil.canPutItemInBag(_bagData, _itemTemplateId, 1);
				if (canPutInBag)
				{
//					SocketLockManager.KeyLock(ConstNetCommand.CS_ITEM_MAKE);
					//添加铸造数据到达监听 
					SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadItemMakeInfo);
					SocketCommand_item.itemMake(_itemTemplateId, _moneyType);
				}
				else
				{
					CJFlyWordsUtil(CJLang("ITEM_MAKE_RESULT_STATE_BAG_FULL"));
				}
			}
			else
			{
				CJFlyWordsUtil(CJLang("ITEM_MAKE_RESULT_STATE_LACK_MATERIAL"));
			}
		}
		/**
		 * 背包数据改变处理
		 * 
		 */		
		private function _bagDataChangeHandler():void
		{
			//更新能铸造装备的个数
			var canDoCount:int = CJItemMakeUtil.o.getItemCanDoCount(_itemTemplateId);
			_btnMakeItem.setBagGoodsCount(canDoCount.toString());
			//更新拥有材料的个数
			var materialInfo:Array = CJItemMakeUtil.o.getMaterialInfo(_itemTemplateId);
			_itemMaterialShow(materialInfo);
			//更新铸造装备层能铸造装备的个数
			ConstItemMake.isMakingItem = true;
			_setDataProvider(_itemSubType);
		}
			
		/**
		 * 显示要铸造装备及材料的信息
		 * @param e
		 * 
		 */		
		private function _showItemMakeInfo(e:Event):void
		{
			//要铸造装备的模板ID
			var makeItemTemplateId:int = e.data.templateId;
			//没有可铸造的装备
			if (makeItemTemplateId == 0)
			{
				_makeShowLayer.visible = false;
				_btnMakeItem.visible = false;
				_needMaterialItem0.visible = false;
				_needMaterialItem1.visible = false;
				_needMaterialItem2.visible = false;
				_tipsLabel.visible = true;
			} 
			else
			{
				_btnMakeItem.visible = true;
				var template:Json_item_setting = CJDataOfItemProperty.o.getTemplate(makeItemTemplateId);
				var itemPictrueName:String = template.picture;
				_btnMakeItem.setBagGoodsItem(itemPictrueName);
				var itemEquipTemplate:Json_item_equip_config = CJDataOfItemEquipProperty.o.getItemEquipConfigById(makeItemTemplateId);
				//设置要铸造装备的属性加成
				_labelPropertyValue0.text = "+" + itemEquipTemplate.shengmingadd;
				_labelPropertyValue1.text = "+" + itemEquipTemplate.wugongadd;	
				_labelPropertyValue2.text = "+" + itemEquipTemplate.wufangadd;
				_labelPropertyValue3.text = "+" + itemEquipTemplate.fagongadd;
				_labelPropertyValue4.text = "+" + itemEquipTemplate.fafangadd;
				
				var canDoCount:int = CJItemMakeUtil.o.getItemCanDoCount(makeItemTemplateId);
				_btnMakeItem.setBagGoodsCount(canDoCount.toString());
				_makeShowLayer.visible = true;
				_tipsLabel.visible = false;
				var materialInfo:Array = CJItemMakeUtil.o.getMaterialInfo(makeItemTemplateId);
				_itemMaterialShow(materialInfo);
				//得到要铸造装备的模板Id 
				_itemTemplateId = makeItemTemplateId;
			}
		}
		
		/**
		 * 设置要铸造装备材料的显示
		 * @param materialInfo 可铸造装备材料信息
		 * 
		 */		
		private function _itemMaterialShow(materialInfo:Array):void
		{
			var materialInfo0:CJItemCanDoUtil;
			var materialInfo1:CJItemCanDoUtil;
			var materialInfo2:CJItemCanDoUtil;
			var materialNum:int = 0;
			for (var i:int = 0; i < materialInfo.length; i++) 
			{
				if (materialInfo[i].itemId != 0)
				{
					materialNum ++;
				}
			}
			
			switch (materialNum)
			{
				case 1:
					_imgMaterialLine.source = SApplication.assets.getTexture("zhuzao_luxianqietu03");
					materialInfo0 = materialInfo[0] as CJItemCanDoUtil;
					_needMaterialItem1.visible = true;
					_needMaterialItem1.materialId = materialInfo0.itemId;
					_labelMaterialInfo1.visible = true;
					_labelMaterialInfo1.text = materialInfo0.itemOwn + "/" + materialInfo0.itemNeed;
					_labelMaterialInfo0.visible = false;
					_labelMaterialInfo2.visible = false;
					_needMaterialItem0.visible = false;
					_needMaterialItem2.visible = false;
					break;
				case 2:
					_imgMaterialLine.source = SApplication.assets.getTexture("zhuzao_luxianqietu02");
					materialInfo0 = materialInfo[0] as CJItemCanDoUtil;
					materialInfo1 = materialInfo[1] as CJItemCanDoUtil;
					_needMaterialItem0.visible = true;
					_needMaterialItem2.visible = true;
					_needMaterialItem0.materialId = materialInfo0.itemId;
					_needMaterialItem2.materialId = materialInfo1.itemId;
					_labelMaterialInfo0.visible = true;
					_labelMaterialInfo2.visible = true;
					_labelMaterialInfo0.text = materialInfo0.itemOwn + "/" + materialInfo0.itemNeed;
					_labelMaterialInfo2.text = materialInfo1.itemOwn + "/" + materialInfo1.itemNeed;
					_needMaterialItem1.visible = false;
					_labelMaterialInfo1.visible = false;
					break;
				case 3:
					_imgMaterialLine.source = SApplication.assets.getTexture("zhuzao_luxianqietu01");
					materialInfo0 = materialInfo[0] as CJItemCanDoUtil;
					materialInfo1 = materialInfo[1] as CJItemCanDoUtil;
					materialInfo2 = materialInfo[2] as CJItemCanDoUtil;
					_needMaterialItem0.visible = true;
					_needMaterialItem1.visible = true;
					_needMaterialItem2.visible = true;
					_needMaterialItem0.materialId = materialInfo0.itemId;
					_needMaterialItem1.materialId = materialInfo1.itemId;
					_needMaterialItem2.materialId = materialInfo2.itemId;
					_labelMaterialInfo0.visible = true;
					_labelMaterialInfo1.visible = true;
					_labelMaterialInfo2.visible = true;
					_labelMaterialInfo0.text = materialInfo0.itemOwn + "/" + materialInfo0.itemNeed;
					_labelMaterialInfo1.text = materialInfo1.itemOwn + "/" + materialInfo1.itemNeed;
					_labelMaterialInfo2.text = materialInfo2.itemOwn + "/" + materialInfo2.itemNeed;
					break;
				default:
					Assert(false,"材料数据错误！");
					break;
			}
		}
		/**
		 *铸造装备分类按钮点击事件处理 
		 * @param event Event
		 * 
		 */		
		private function _buttonChangeHandler(event:Event):void
		{
			SSoundEffectUtil.playButtonNormalSound();
			//获得当前点击的背包物品栏按钮
			var currentBtn:Button = event.currentTarget as Button;
			//如果当前点击的按钮不是默认的选中按钮，则把默认选中按钮的选中状态改为未选中
			if (_btnSubType0 != currentBtn)
			{
				_btnSubType0.isSelected = false;
				_btnSubType0.defaultLabelProperties.textFormat = new TextFormat("Arial", 13, 0x8D9090);
			}
			else
			{
				_btnSubType0.isSelected = true;
				_btnSubType0.defaultLabelProperties.textFormat = new TextFormat("Arial", 13, 0xE1DB8A);
			}
			if (_oldBtn == currentBtn) return;
			//把当前点击的按钮设置为选中状态，上次选中的按钮设置为未选中状态
			if (null != _oldBtn)
			{
				_oldBtn.isSelected = false;
				_oldBtn.filter = _filter;
			}
			currentBtn.isSelected = true;
			currentBtn.filter = null;
			//把当前点击的按钮设置为上次选中的按钮
			_oldBtn = currentBtn;
			switch (currentBtn)
			{
				case btnSubType0:
					_setDataProvider(ConstItem.SCONST_ITEM_SUBTYPE_ALL);
					_itemSubType = ConstItem.SCONST_ITEM_SUBTYPE_ALL;
					break;
				case btnSubType1:
					_setDataProvider(ConstItem.SCONST_ITEM_SUBTYPE_WEAPON);
					_itemSubType = ConstItem.SCONST_ITEM_SUBTYPE_WEAPON;
					break;
				case btnSubType2:
					_setDataProvider(ConstItem.SCONST_ITEM_SUBTYPE_HELMET);
					_itemSubType = ConstItem.SCONST_ITEM_SUBTYPE_HELMET;
					break;
				case btnSubType3:
					_setDataProvider(ConstItem.SCONST_ITEM_SUBTYPE_ARMOUR);
					_itemSubType = ConstItem.SCONST_ITEM_SUBTYPE_ARMOUR;
					break;
				case btnSubType4:
					_setDataProvider(ConstItem.SCONST_ITEM_SUBTYPE_CLOAK);
					_itemSubType = ConstItem.SCONST_ITEM_SUBTYPE_CLOAK;
					break;
				case btnSubType5:
					_setDataProvider(ConstItem.SCONST_ITEM_SUBTYPE_BELT);
					_itemSubType = ConstItem.SCONST_ITEM_SUBTYPE_BELT;
					break;
				case btnSubType6:
					_setDataProvider(ConstItem.SCONST_ITEM_SUBTYPE_SHOES);
					_itemSubType = ConstItem.SCONST_ITEM_SUBTYPE_SHOES;
					break;
				default:
					Assert(false,"材料数据错误！");
					break;
			}
		}
		/**
		 * 设置显示数据
		 * @param itemSubType 铸造装备子类型
		 */		
		private function _setDataProvider(itemSubType:int):void
		{
			_itemShowLayer.dispatchEventWith(ConstItemMake.ITEM_SHOW_CHANGED, false, {"itemSubType":itemSubType, "itemTemplateId":_itemTemplateId});
		}
		/**
		 * 加载铸造服务器返回数据 
		 * @param e Event
		 * 
		 */		
		private function _onloadItemMakeInfo(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() != ConstNetCommand.CS_ITEM_MAKE)
				return;
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadItemMakeInfo);
			// 去除网络锁
//			SocketLockManager.KeyUnLock(ConstNetCommand.CS_ITEM_MAKE);
			if (message.retcode == 0)
			{
				var retParams:Array = message.retparams;
				_itemsNum = int(retParams[0]);
				_retState = int(retParams[1]);
				_showItemMakeResult(_retState);
			}
		}
		
		/**
		 * 显示装备铸造结果
		 * @param _retState 铸造的返回值
		 * 
		 */		
		private function _showItemMakeResult(_retState:int):void
		{
			switch (_retState)
			{
				case ConstItemMake.ITEM_MAKE_RESULT_STATE_SUCCESS:
					//设置铸造成功动画
//					new CJTaskFlowImage("texiaozi_zhuzaochenggong").addToLayer();
					CJHeartbeatEffectUtil("texiaozi_zhuzaochenggong");
					var imgStars:Vector.<Texture> = SApplication.assets.getTextures("xiangqiankaikong_");
					_starAnim = new SAnimate(imgStars, 10);
					//设置动画的坐标
					_starAnim.x = ConstItemMake.ITEM_MAKE_SHOW_MAKE_ITEM_X - 30;
					_starAnim.y = ConstItemMake.ITEM_MAKE_SHOW_MAKE_ITEM_Y - 33;
					_starAnim.touchable = false;
					this.addChild(_starAnim);
					Starling.juggler.add(_starAnim);
					_starAnim.play();
					_starAnim.addEventListener(Event.COMPLETE, _onZhuzaoTexiaoComplete);
					//请求更新背包数据
					_bagData.loadFromRemote();
					CJDataManager.o.activityManager.dispatchEventWith(CJEvent.EVENT_ACTIVITY_HAPPEN , false, {"key":CJActivityEventKey.ACTIVITY_EQUIPMAKE});
					break;
				case ConstItemMake.ITEM_MAKE_RESULT_STATE_BAG_FULL:
					CJFlyWordsUtil(CJLang("ITEM_MAKE_RESULT_STATE_BAG_FULL"));
					break;
				case ConstItemMake.ITEM_MAKE_RESULT_STATE_LACK_SILVER:
					CJFlyWordsUtil(CJLang("ITEM_MAKE_RESULT_STATE_LACK_SILVER"));
					break;
				case ConstItemMake.ITEM_MAKE_RESULT_STATE_LACK_GOLD:
					CJFlyWordsUtil(CJLang("ITEM_MAKE_RESULT_STATE_LACK_GOLD"));
					break;
				case ConstItemMake.ITEM_MAKE_RESULT_STATE_LACK_MATERIAL:
					CJFlyWordsUtil(CJLang("ITEM_MAKE_RESULT_STATE_LACK_MATERIAL"));
					break;
				default:
					Assert(false,"铸造返回数据错误！");
					break;
			}
		}
		/**
		 * 铸造完成动画播放结束
		 * 
		 */
		private function _onZhuzaoTexiaoComplete(e:Event):void
		{
			if(e.target is SAnimate && _starAnim)
			{
				_starAnim.removeEventListener(Event.COMPLETE, _onZhuzaoTexiaoComplete);
				_starAnim.removeFromJuggler();
				_starAnim.removeFromParent(true);
				_starAnim = null;
			}
		}
		/**属性加成-物防*/
		public function get labelProperty2():Label
		{
			return _labelProperty2;
		}

		/**
		 * @private
		 */
		public function set labelProperty2(value:Label):void
		{
			_labelProperty2 = value;
		}

		/**属性加成值-物防*/
		public function get labelPropertyValue2():Label
		{
			return _labelPropertyValue2;
		}

		/**
		 * @private
		 */
		public function set labelPropertyValue2(value:Label):void
		{
			_labelPropertyValue2 = value;
		}

		/**属性加成-法攻*/
		public function get labelProperty3():Label
		{
			return _labelProperty3;
		}

		/**
		 * @private
		 */
		public function set labelProperty3(value:Label):void
		{
			_labelProperty3 = value;
		}

		/**属性加成值-法攻*/
		public function get labelPropertyValue3():Label
		{
			return _labelPropertyValue3;
		}

		/**
		 * @private
		 */
		public function set labelPropertyValue3(value:Label):void
		{
			_labelPropertyValue3 = value;
		}

		/**属性加成-法防*/
		public function get labelProperty4():Label
		{
			return _labelProperty4;
		}

		/**
		 * @private
		 */
		public function set labelProperty4(value:Label):void
		{
			_labelProperty4 = value;
		}

		/**属性加成值-法防*/
		public function get labelPropertyValue4():Label
		{
			return _labelPropertyValue4;
		}

		/**
		 * @private
		 */
		public function set labelPropertyValue4(value:Label):void
		{
			_labelPropertyValue4 = value;
		}
		/**铸造装备子类型-全部*/
		public function get btnSubType0():Button
		{
			return _btnSubType0;
		}
		
		public function set btnSubType0(value:Button):void
		{
			_btnSubType0 = value;
		}
		
		/**铸造装备子类型-武器*/
		public function get btnSubType1():Button
		{
			return _btnSubType1;
		}
		
		public function set btnSubType1(value:Button):void
		{
			_btnSubType1 = value;
		}
		
		/**铸造装备子类型-头盔*/
		public function get btnSubType2():Button
		{
			return _btnSubType2;
		}
		
		public function set btnSubType2(value:Button):void
		{
			_btnSubType2 = value;
		}
		
		/**铸造装备子类型-盔甲*/
		public function get btnSubType3():Button
		{
			return _btnSubType3;
		}
		
		public function set btnSubType3(value:Button):void
		{
			_btnSubType3 = value;
		}
		
		/**铸造装备子类型-披风*/
		public function get btnSubType4():Button
		{
			return _btnSubType4;
		}
		
		public function set btnSubType4(value:Button):void
		{
			_btnSubType4 = value;
		}
		
		/**铸造装备子类型-腰带*/
		public function get btnSubType5():Button
		{
			return _btnSubType5;
		}
		
		public function set btnSubType5(value:Button):void
		{
			_btnSubType5 = value;
		}
		
		/**铸造装备子类型-靴子*/
		public function get btnSubType6():Button
		{
			return _btnSubType6;
		}
		
		public function set btnSubType6(value:Button):void
		{
			_btnSubType6 = value;
		}
		
		/**铸造显示层*/
		public function get makeShowLayer():SLayer
		{
			return _makeShowLayer;
		}
		
		public function set makeShowLayer(value:SLayer):void
		{
			_makeShowLayer = value;
		}
		
		/**可铸造装备显示层*/
		public function get itemShowLayer():CJItemMakeItemShowLayer
		{
			return _itemShowLayer;
		}
		
		public function set itemShowLayer(value:CJItemMakeItemShowLayer):void
		{
			_itemShowLayer = value;
		}
		/**待铸造的装备对应的材料的分类线*/
		public function get imgMaterialLine():ImageLoader
		{
			return _imgMaterialLine;
		}
		
		public function set imgMaterialLine(value:ImageLoader):void
		{
			_imgMaterialLine = value;
		}
		/**拥有和需要材料的数量0*/
		public function get labelMaterialInfo0():Label
		{
			return _labelMaterialInfo0;
		}
		
		public function set labelMaterialInfo0(value:Label):void
		{
			_labelMaterialInfo0 = value;
		}
		/**拥有和需要材料的数量1*/
		public function get labelMaterialInfo1():Label
		{
			return _labelMaterialInfo1;
		}
		
		public function set labelMaterialInfo1(value:Label):void
		{
			_labelMaterialInfo1 = value;
		}
		/**拥有和需要材料的数量2*/
		public function get labelMaterialInfo2():Label
		{
			return _labelMaterialInfo2;
		}
		
		public function set labelMaterialInfo2(value:Label):void
		{
			_labelMaterialInfo2 = value;
		}
		/**属性加成0*/
		public function get labelProperty0():Label
		{
			return _labelProperty0;
		}
		
		public function set labelProperty0(value:Label):void
		{
			_labelProperty0 = value;
		}
		
		/**属性加成1*/
		public function get labelProperty1():Label
		{
			return _labelProperty1;
		}
		
		public function set labelProperty1(value:Label):void
		{
			_labelProperty1 = value;
		}
		
		/**属性加成值0*/
		public function get labelPropertyValue0():Label
		{
			return _labelPropertyValue0;
		}
		
		public function set labelPropertyValue0(value:Label):void
		{
			_labelPropertyValue0 = value;
		}
		
		/**属性加成值1*/
		public function get labelPropertyValue1():Label
		{
			return _labelPropertyValue1;
		}
		
		public function set labelPropertyValue1(value:Label):void
		{
			_labelPropertyValue1 = value;
		}
		
		/**铸造按钮*/
		public function get btnMake():Button
		{
			return _btnMake;
		}
		
		public function set btnMake(value:Button):void
		{
			_btnMake = value;
		}

	}
}