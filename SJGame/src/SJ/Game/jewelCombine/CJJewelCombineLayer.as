package SJ.Game.jewelCombine
{
	import SJ.Common.Constants.ConstJewelCombine;
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.SocketServer.SocketCommand_item;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.activity.CJActivityEventKey;
	import SJ.Game.bag.CJBagItem;
	import SJ.Game.controls.CJFlyWordsUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfBag;
	import SJ.Game.data.CJDataOfItem;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.config.CJDataOfItemJewelProperty;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.config.CJDataOfJewelCombineProperty;
	import SJ.Game.data.config.CJDataOfVipFuncSetting;
	import SJ.Game.data.json.Json_item_jewel_config;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.data.json.Json_jewel_combine_config;
	import SJ.Game.data.json.Json_vip_function_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.Events.DataEvent;
	import engine_starling.SApplication;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	import engine_starling.utils.SStringUtils;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.TextInput;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * 宝石合成层
	 * @author zhengzheng
	 */	
	public class CJJewelCombineLayer extends SLayer
	{
		public function CJJewelCombineLayer()
		{
			super();
		}
		/**背包数据*/
		private var _bagData:CJDataOfBag;
		/**可铸造装备显示层-布局文件中*/
		private var _JewelShowLayer:CJJewelShowLayer;
		/**要合成的宝石对应的材料的分类线*/
		private var _imgMaterialLine:ImageLoader;
		/**要合成的宝石*/
		private var _combineJewel:CJBagItem;
		/**合成需要的材料0*/
		private var _needMaterialJewel0:CJBagItem;
		/**合成需要的材料1*/
		private var _needMaterialJewel1:CJBagItem;
		/**要合成的宝石名称 */
		private var _labelCombineJewelName:Label;
		/**要合成的宝石效果说明 */
		private var _labelCombineJewelEffect:Label;
		/**宝石合成说明 */
		private var _labelJewelCombineInfo:Label;
		/**数量减少按钮*/
		private var _btnDecrease:Button;
		/**合成数量输入框*/
		private var _tiCombineNum:TextInput;
		/**数量增加按钮*/
		private var _btnAdd:Button;
		/**合成按钮*/
		private var _btnCombine:Button;
		/** 一键合成说明 */
		private var _labelOneKeyCombineInfo:Label;
		/**一键合成按钮*/
		private var _btnOneKeyCombine:Button;
		/**被合成的宝石id*/
		private var _srcJewelId:int;
		/**要合成的宝石id*/
		private var _desJewelId:int;
		/**玩家的vip等级*/
		private var _vipLevel:int;
		/**一键合成需要的玩家的vip等级*/
		private var _needVipLevel:int;
		/**vip功能配置*/
		private var _vipFuncJs:Json_vip_function_setting
		/**判断是否已经装备上了宝石*/
		private var _isJewelEquiped:Boolean = false;
		/**返回合成宝石的数量*/
		private var _jewelNum:int;
		/**当前选中宝石的数量*/
		private var _selectJewelNum:int;
		/**宝石一键合成界面*/
		private var _jewelCombineOneKeyLayer:CJJewelCombineOneKeyLayer;
		/**主角信息*/
		private var _roleData:CJDataOfRole;
		/**宝石合成成功特效*/
		private var _starAnim:SAnimate;
		override protected function initialize():void
		{
			super.initialize();
			_initData();
			_drawContent();
			_addListener();
		}
		
		/**
		 * 初始化基本数据
		 */		
		private function _initData():void
		{
			_roleData = CJDataManager.o.DataOfRole;
			_bagData = CJDataManager.o.getData("CJDataOfBag");
			_btnCombine.label = CJLang("JEWEL_COMBINE_COMBINE");
			_btnOneKeyCombine.label = CJLang("JEWEL_COMBINE_ONE_KEY_COMBINE");
			_labelJewelCombineInfo.text = CJLang("JEWEL_COMBINE_COMBINE_TIP");
			_labelOneKeyCombineInfo.text = CJLang("JEWEL_COMBINE_ONE_KEY_COMBINE_TIP");
			
			//初始化合成宝石层显示道具
			_combineJewel = new CJBagItem();
			_combineJewel.x = 259;
			_combineJewel.y = 19;
			
			_labelCombineJewelName = new Label();
			_labelCombineJewelName.x = 314;
			_labelCombineJewelName.y = 29;
			
			_labelCombineJewelEffect = new Label();
			_labelCombineJewelEffect.x = 315;
			_labelCombineJewelEffect.y = 44;
			
			_needMaterialJewel0 = new CJBagItem();
			_needMaterialJewel0.x = 181;
			_needMaterialJewel0.y = 99;
			
			_needMaterialJewel1 = new CJBagItem();
			_needMaterialJewel1.x = 336;
			_needMaterialJewel1.y = 99;
			
			_setTextFormat();
			
			_vipLevel = _roleData.vipLevel;
			_needVipLevel = int(CJDataOfGlobalConfigProperty.o.getData("JEWEL_COMBINE_ONE_KEY_NEED_VIP_LEVEL"));
			_vipFuncJs = CJDataOfVipFuncSetting.o.getData(String(_vipLevel));
		}
		
		/**
		 * 设置控件的字体 
		 */		
		private function _setTextFormat():void
		{
			var fontFormat:TextFormat;
			//为材料信息设置字体格式
			fontFormat = new TextFormat( "黑体", 12, 0xFEFBC7,null,null,null,null,null,TextFormatAlign.CENTER);
			_btnCombine.defaultLabelProperties.textFormat = fontFormat;
			_btnOneKeyCombine.defaultLabelProperties.textFormat = fontFormat;
			//为属性加成设置字体格式
			fontFormat = new TextFormat( "黑体", 10, 0x96E538,null,null,null,null,null,TextFormatAlign.CENTER );
			_labelJewelCombineInfo.textRendererProperties.textFormat = fontFormat;
			_labelOneKeyCombineInfo.textRendererProperties.textFormat = fontFormat;
			
			fontFormat = new TextFormat( "Arial", 10, 0x89FE3A);
			_labelCombineJewelName.textRendererProperties.textFormat = fontFormat;
			
			fontFormat = new TextFormat( "Arial", 10, 0xFEE44B);
			_labelCombineJewelEffect.textRendererProperties.textFormat = fontFormat;
		}
		/**
		 * 绘制界面内容
		 */		
		private function _drawContent():void
		{
			//分割线
			var line:ImageLoader = new ImageLoader();
			line.source = SApplication.assets.getTexture("common_fengexian");
			line.pivotX = line.width / 2;
			line.pivotY = line.height / 2;
			line.rotation = Math.PI / 2;
			line.x = 155;
			line.y = 10;
			line.width = 258;
			line.height = 5;
			this.addChildAt(line, 0);
			
			//合成宝石显示区
			var texture:Texture = SApplication.assets.getTexture("baoshi_hechengyoucedi");
			var scale9Texture:Scale9Textures = new Scale9Textures(texture, new Rectangle(18,18 ,1,1));
			var bgCombineShow:Scale9Image = new Scale9Image(scale9Texture);
			bgCombineShow.x = 155;
			bgCombineShow.y = 9;
			bgCombineShow.width = 254;
			bgCombineShow.height = 177;
			this.addChildAt(bgCombineShow , 0);
			//合成宝石选择数量底图
			texture = SApplication.assets.getTexture("common_hechengwenzidi");
			scale9Texture = new Scale9Textures(texture, new Rectangle(3,3 ,3,3));
			var bgSelectNum:Scale9Image = new Scale9Image(scale9Texture);
			bgSelectNum.alpha = 0.9;
			bgSelectNum.x = 160;
			bgSelectNum.y = 196;
			bgSelectNum.width = 150;
			bgSelectNum.height = 28;
			this.addChildAt(bgSelectNum , 0);
			//一键合成宝石提示底图
			texture = SApplication.assets.getTexture("common_hechengwenzidi");
			scale9Texture = new Scale9Textures(texture, new Rectangle(3,3 ,3,3));
			var bgOneKeyCombineInfo:Scale9Image = new Scale9Image(scale9Texture);
			bgOneKeyCombineInfo.x = 160;
			bgOneKeyCombineInfo.y = 229;
			bgOneKeyCombineInfo.width = 150;
			bgOneKeyCombineInfo.height = 33;
			this.addChildAt(bgOneKeyCombineInfo , 0);
			//右侧区域底图
			var imgRightBg:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_dinewzhezhao", 1 ,1 , 1, 1);
			imgRightBg.x = 153;
			imgRightBg.y = 10;
			imgRightBg.width = 258;
			imgRightBg.height = this.height - 17;
			this.addChildAt(imgRightBg, 0);
			
			//初始化合成宝石显示层显示道具
			this.addChild(_combineJewel);
			this.addChild(_labelCombineJewelName);
			this.addChild(_labelCombineJewelEffect);
			this.addChild(_needMaterialJewel0);
			this.addChild(_needMaterialJewel1);
			
			// 设置合成宝石数量输入框字体格式
			_tiCombineNum.backgroundSkin = new SImage(SApplication.assets.getTexture("common_shurukuagn"));
			var fontFormat:Object = _tiCombineNum.textEditorProperties;
			fontFormat.fontSize = 10;
			fontFormat.autoSizeIfNeeded = true;
			fontFormat.textAlign = "center";
			_tiCombineNum.paddingTop = 1;
			_tiCombineNum.text = "1";
		}
		/**
		 * 为控件添加监听 
		 * 
		 */	
		private function _addListener():void
		{
			_btnDecrease.defaultSkin = new SImage(SApplication.assets.getTexture("common_jiananniu"));
			//为减少数量按钮添加监听
			_btnDecrease.addEventListener(starling.events.Event.TRIGGERED, function (e:*):void{
				SSoundEffectUtil.playButtonNormalSound();
				if(_isJewelEquiped)
				{
					var combineNum:int = parseInt(_tiCombineNum.text);
					if (combineNum > 1)
					{
						_tiCombineNum.text = (parseInt(_tiCombineNum.text) - 1).toString();
					}
				}
			});
			_btnAdd.defaultSkin = new SImage(SApplication.assets.getTexture("common_jiaanniu"));
			//为增加数量按钮添添加监听
			_btnAdd.addEventListener(starling.events.Event.TRIGGERED, function (e:*):void{
				SSoundEffectUtil.playButtonNormalSound();
				if(_isJewelEquiped)
				{
					var combineNum:int = parseInt(_tiCombineNum.text);
					var canCombineJewelNum:int = _bagData.getItemCountByTmplId(_srcJewelId);
					if (combineNum >= canCombineJewelNum)
					{
						if (canCombineJewelNum <= 0)
						{
							_tiCombineNum.text = "1";
						}
						else
						{
							combineNum = canCombineJewelNum;
							_tiCombineNum.text = combineNum.toString();
						}
					}
					else
					{
						_tiCombineNum.text = (parseInt(_tiCombineNum.text) + 1).toString();
					}
				}
			});
			_btnCombine.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniuda01new"));
			_btnCombine.downSkin = new SImage(SApplication.assets.getTexture("common_anniuda02new"));
			//为合成按钮添加监听
			_btnCombine.addEventListener(starling.events.Event.TRIGGERED, function (e:*):void{
				SSoundEffectUtil.playButtonNormalSound();
				if(_isJewelEquiped && _srcJewelId != 0)
				{
					var canCombineJewelNum:int = _bagData.getItemCountByTmplId(_srcJewelId);
					if (canCombineJewelNum <= 1)
					{
						CJFlyWordsUtil(CJLang("JEWEL_COMBINE_RESULT_MATERIAL_LACK"));
					}
					else
					{
						//添加宝石合成数据到达监听 
						SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadJewelCombineInfo);
						//请求宝石合成
						SocketCommand_item.jewelCombine(_srcJewelId, parseInt(_tiCombineNum.text));
					}
				}
				else
				{
					CJFlyWordsUtil(CJLang("JEWEL_COMBINE_RESULT_NOT_PUT_JEWEL_IN"));
				}
			});
			_btnOneKeyCombine.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniuda01new"));
			_btnOneKeyCombine.downSkin = new SImage(SApplication.assets.getTexture("common_anniuda02new"));
			//为一键合成按钮添加监听
			_btnOneKeyCombine.addEventListener(starling.events.Event.TRIGGERED, function (e:*):void{
				if (_vipFuncJs)
				{
					var isCanBatMake:Boolean = Boolean(int(_vipFuncJs.jewel_batmake));
					if (isCanBatMake)
					{
						SSoundEffectUtil.playTipSound();
						var tooltipXml:XML = AssetManagerUtil.o.getObject(ConstResource.sResSxmlJewelCombineOneKeyConfig) as XML;
						
						if (_jewelCombineOneKeyLayer && _jewelCombineOneKeyLayer.parent)
						{
							_jewelCombineOneKeyLayer.removeFromParent();
						}
						_jewelCombineOneKeyLayer = SFeatherControlUtils.o.genLayoutFromXML(tooltipXml, CJJewelCombineOneKeyLayer) as CJJewelCombineOneKeyLayer;
						CJLayerManager.o.addToModal(_jewelCombineOneKeyLayer);
					}
					else
					{
						SSoundEffectUtil.playButtonNormalSound();
						var resultStr:String = "VIP" + _needVipLevel + CJLang("JEWEL_COMBINE_ONE_KEY_RETSTATE_VIP_NOT_ENOUGH");
						CJFlyWordsUtil(resultStr);
					}
				}
			});
			//为选择合成宝石数量添加监听
			_tiCombineNum.addEventListener(starling.events.Event.CHANGE,function (e:*):void{
				if(!_isJewelEquiped)
				{
					_tiCombineNum.text = "1";
					return;
				} 
				else 
				{
					//正整数正则表达式
					var pattern:RegExp = /^[0-9]*[1-9][0-9]*$/;
					var combineNumStr:String = _tiCombineNum.text;
					if (pattern.test(combineNumStr))
					{
						var combineNum:int = parseInt(combineNumStr);
						var maxNum:int = _getCanCombineJewelNum();
						if (combineNum >= maxNum)
						{
							if (maxNum <= 0)
							{
								_tiCombineNum.text = "1";
							}
							else
							{
								combineNum = maxNum;
								_tiCombineNum.text = combineNum.toString();
							}
						}
					}
					else
					{
						_tiCombineNum.text = "1";
						CJFlyWordsUtil(CJLang("JEWEL_ONLY_NUMERAL"));
					}
				}
			});
			
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_JEWEL_COMBINE_SHOW_INFO_CHANGED,_updateCombineShowInfo);
			_combineJewel.addEventListener(starling.events.TouchEvent.TOUCH, _onClickCombineJewel);
			_needMaterialJewel0.addEventListener(starling.events.TouchEvent.TOUCH, _onClickMaterialJewel);
			_needMaterialJewel1.addEventListener(starling.events.TouchEvent.TOUCH, _onClickMaterialJewel);
			
		}
		
		override public function dispose():void
		{
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_JEWEL_COMBINE_SHOW_INFO_CHANGED,_updateCombineShowInfo);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadJewelCombineInfo);
			if (_bagData)
			{
				_bagData.removeEventListener(DataEvent.DataLoadedFromRemote, _refreshRightJewelCount);
			}
			super.dispose();
		}
		
		
		/**
		 * 显示合成宝石材料的tips信息
		 * @param e
		 * 
		 */		
		private function _onClickMaterialJewel(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if (!touch || touch.phase != TouchPhase.ENDED)
				return;
			if (_srcJewelId != 0)
			{
				CJJewelCombineUtil.o.showJeweltip(_srcJewelId);
			}
		}
		/**
		 * 显示要合成宝石的tips信息
		 * @param e
		 * 
		 */		
		private function _onClickCombineJewel(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if (!touch || touch.phase != TouchPhase.ENDED)
				return;
			if (_desJewelId != 0)
			{
				CJJewelCombineUtil.o.showJeweltip(_desJewelId);
			}
		}
		/**
		 * 得到可以合成的最大宝石数量
		 * 
		 */		
		private function _getCanCombineJewelNum():int
		{
			return _selectJewelNum / 2;
		}
		/**
		 * 更新宝石合成显示的信息
		 * 
		 */	
		private function _updateCombineShowInfo(e:Event):void
		{
			
			_isJewelEquiped = true;
			//点击宝石的模板ID
			_srcJewelId = e.data.jewelId;
			_selectJewelNum = e.data.selectJewelNum;
			//初始化合成宝石的数量
			_tiCombineNum.text = "1";
			var canCombineJewelNum:int = _getCanCombineJewelNum();
			//设置被合成宝石的图标和数量
			var templateItemSettingSrc:Json_item_setting = CJDataOfItemProperty.o.getTemplate(_srcJewelId);
			this._needMaterialJewel0.setBagGoodsItem(templateItemSettingSrc.picture);
			this._needMaterialJewel1.setBagGoodsItem(templateItemSettingSrc.picture);
			//设置要合成宝石的图标 和数量、名称
			var templateJewelCombineSetting:Json_jewel_combine_config = CJDataOfJewelCombineProperty.o.getJewelCombineInfo(_srcJewelId);
			if (templateJewelCombineSetting == null)
			{
				this._combineJewel.setBagGoodsItem("");
				_labelCombineJewelName.text = "";
				_labelCombineJewelEffect.text = "";
				_desJewelId = 0;
			}
			else
			{
				_desJewelId = templateJewelCombineSetting.desjewelid;
				var templateItemSettingDes:Json_item_setting = CJDataOfItemProperty.o.getTemplate(_desJewelId);
				this._combineJewel.setBagGoodsItem(templateItemSettingDes.picture);
				this._combineJewel.setBagGoodsCount(String(canCombineJewelNum));
				_labelCombineJewelName.text = CJLang(templateItemSettingDes.itemname);
				var templateItemJewelConfig:Json_item_jewel_config = CJDataOfItemJewelProperty.o.getItemJewelConfigById(_desJewelId);
				var propertyValue:int = CJJewelCombineUtil.o.getJewelPropertyBySubtype(templateItemSettingDes.subtype, templateItemJewelConfig);
				_labelCombineJewelEffect.text = CJLang(templateItemJewelConfig.type) + "  +" + propertyValue;
			}
		}
		
		/**
		 * 刷新右侧宝石显示数量
		 * 
		 */		
		public function _refreshRightJewelCount():void
		{
			_bagData.removeEventListener(DataEvent.DataLoadedFromRemote, _refreshRightJewelCount);
			_selectJewelNum = _bagData.getItemCountByTmplId(_srcJewelId);
			var canCombineJewelNum:int = _getCanCombineJewelNum();
			this._combineJewel.setBagGoodsCount(String(canCombineJewelNum));
			var combineNumStr:String = _tiCombineNum.text;
			var combineNum:int = parseInt(combineNumStr);
			if (combineNum >= canCombineJewelNum)
			{
				if (canCombineJewelNum <= 0)
				{
					_tiCombineNum.text = "1";
				}
				else
				{
					combineNum = canCombineJewelNum;
					_tiCombineNum.text = combineNum.toString();
				}
			}
			
		}
		/**
		 * 加载宝石合成服务器返回数据 
		 * @param e Event
		 * 
		 */		
		private function _onloadJewelCombineInfo(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() != ConstNetCommand.CS_JEWEL_COMBINE_COMBINE)
				return;
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadJewelCombineInfo);
			if (message.retcode == 0)
			{
				var retParams:Array = message.retparams;
				_desJewelId = int(retParams[0]);
				_jewelNum = int(retParams[1]);
				var retState:int = int(retParams[2]);
				_showJewelCombineResult(retState);
			}
		}
		
		/**
		 * 显示宝石合成结果
		 * @param retState 宝石合成服务端的返回值
		 * 
		 */		
		private function _showJewelCombineResult(retState:int):void
		{
			switch (retState)
			{
				case ConstJewelCombine.JEWEL_COMBINE_RESULT_SUCCESS:
					var templateItemSettingDes:Json_item_setting = CJDataOfItemProperty.o.getTemplate(_desJewelId);
					//					var level:int = templateItemSettingDes.level;
					var resultStr:String = CJLang("JEWEL_COMBINE_RESULT_SUCCESS") +
					"," + CJLang("JEWEL_COMBINE_RESULT_GET") + _jewelNum +
					CJLang("JEWEL_COMBINE_RESULT_COUNT") + CJLang(templateItemSettingDes.itemname);
					
					CJFlyWordsUtil(resultStr);
					// 监听背包数据获取成功
					_bagData.addEventListener(DataEvent.DataLoadedFromRemote, _refreshRightJewelCount);
					//请求更新背包数据
					_bagData.loadFromRemote();
					CJDataManager.o.activityManager.dispatchEventWith(CJEvent.EVENT_ACTIVITY_HAPPEN , false, {"key":CJActivityEventKey.ACTIVITY_JEWELCOMBINE});
					_playSuccessAnim();
					break;
				case ConstJewelCombine.JEWEL_COMBINE_RESULT_ALREADY_MAX_LEVEL:
					CJFlyWordsUtil(CJLang("JEWEL_COMBINE_RESULT_ALREADY_MAX_LEVEL"));
					break;
				case ConstJewelCombine.JEWEL_COMBINE_RESULT_BAG_SPACE_LACK:
					CJFlyWordsUtil(CJLang("JEWEL_COMBINE_RESULT_BAG_SPACE_LACK"));
					break;
				case ConstJewelCombine.JEWEL_COMBINE_RESULT_MATERIAL_LACK:
					CJFlyWordsUtil(CJLang("JEWEL_COMBINE_RESULT_MATERIAL_LACK"));
					break;
				case ConstJewelCombine.JEWEL_COMBINE_RESULT_NOT_PUT_JEWEL_IN:
					CJFlyWordsUtil(CJLang("JEWEL_COMBINE_RESULT_NOT_PUT_JEWEL_IN"));
					break;
				case ConstJewelCombine.JEWEL_COMBINE_RETSTATE_DESNUM_INVALID:
					CJFlyWordsUtil(CJLang("JEWEL_COMBINE_RETSTATE_DESNUM_INVALID"));
					break;
				default:
					Assert(false,"宝石合成返回数据错误！");
					break;
			}
		}
		/**
		 * 播放宝石合成成功动画
		 * 
		 */		
		private function _playSuccessAnim():void
		{
			var imgStars:Vector.<Texture> = SApplication.assets.getTextures("xiangqiankaikong_");
			_starAnim = new SAnimate(imgStars, 10);
			//设置动画的坐标
			_starAnim.x = _combineJewel.x - 30;
			_starAnim.y = _combineJewel.y - 33;
			_starAnim.touchable = false;
			this.addChild(_starAnim);
			Starling.juggler.add(_starAnim);
			_starAnim.play();
			_starAnim.addEventListener(Event.COMPLETE, _onCombineAnimComplete);
		}
		
		/**
		 * 宝石合成完成动画播放结束
		 * 
		 */
		private function _onCombineAnimComplete(e:Event):void
		{
			if (e.target is SAnimate)
			{
				_starAnim.removeEventListener(Event.COMPLETE, _onCombineAnimComplete);
				_starAnim.removeFromJuggler();
				_starAnim.removeFromParent(true);
				_starAnim = null;
			}
		}
		/**可铸造装备显示层-布局文件中*/
		public function get JewelShowLayer():CJJewelShowLayer
		{
			return _JewelShowLayer;
		}
		
		/**
		 * @private
		 */
		public function set JewelShowLayer(value:CJJewelShowLayer):void
		{
			_JewelShowLayer = value;
		}
		
		/**要合成的宝石对应的材料的分类线*/
		public function get imgMaterialLine():ImageLoader
		{
			return _imgMaterialLine;
		}
		
		/**
		 * @private
		 */
		public function set imgMaterialLine(value:ImageLoader):void
		{
			_imgMaterialLine = value;
		}
		
		/**宝石合成说明 */
		public function get labelJewelCombineInfo():Label
		{
			return _labelJewelCombineInfo;
		}
		
		/**
		 * @private
		 */
		public function set labelJewelCombineInfo(value:Label):void
		{
			_labelJewelCombineInfo = value;
		}
		
		/**数量减少按钮*/
		public function get btnDecrease():Button
		{
			return _btnDecrease;
		}
		
		/**
		 * @private
		 */
		public function set btnDecrease(value:Button):void
		{
			_btnDecrease = value;
		}
		
		/**合成数量输入框*/
		public function get tiCombineNum():TextInput
		{
			return _tiCombineNum;
		}
		
		/**
		 * @private
		 */
		public function set tiCombineNum(value:TextInput):void
		{
			_tiCombineNum = value;
		}
		
		/**数量增加按钮*/
		public function get btnAdd():Button
		{
			return _btnAdd;
		}
		
		/**
		 * @private
		 */
		public function set btnAdd(value:Button):void
		{
			_btnAdd = value;
		}
		
		/**合成按钮*/
		public function get btnCombine():Button
		{
			return _btnCombine;
		}
		
		/**
		 * @private
		 */
		public function set btnCombine(value:Button):void
		{
			_btnCombine = value;
		}
		
		/** 一键合成说明 */
		public function get labelOneKeyCombineInfo():Label
		{
			return _labelOneKeyCombineInfo;
		}
		
		/**
		 * @private
		 */
		public function set labelOneKeyCombineInfo(value:Label):void
		{
			_labelOneKeyCombineInfo = value;
		}
		
		/**一键合成按钮*/
		public function get btnOneKeyCombine():Button
		{
			return _btnOneKeyCombine;
		}
		
		/**
		 * @private
		 */
		public function set btnOneKeyCombine(value:Button):void
		{
			_btnOneKeyCombine = value;
		}
		
		
	}
}