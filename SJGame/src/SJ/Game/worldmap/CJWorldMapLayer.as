package SJ.Game.worldmap
{
	import flash.geom.Rectangle;
	
	import SJ.Common.Constants.ConstDynamic;
	import SJ.Common.Constants.ConstFuben;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstResource;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJButtonUtil;
	import SJ.Game.controls.CJFlyWordsUtil;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfActFb;
	import SJ.Game.data.CJDataOfEnterGuanqia;
	import SJ.Game.data.CJDataOfFuben;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.CJDataOfScene;
	import SJ.Game.data.config.CJDataOfActiveFbProperty;
	import SJ.Game.data.config.CJDataOfFubenProperty;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.config.CJDataOfGuankaProperty;
	import SJ.Game.data.config.CJDataOfMainSceneProperty;
	import SJ.Game.data.config.CJDataOfVipFuncSetting;
	import SJ.Game.data.json.Json_activefuben;
	import SJ.Game.data.json.Json_fuben_config;
	import SJ.Game.data.json.Json_fuben_guanka_config;
	import SJ.Game.data.json.Json_vip_function_setting;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.fuben.CJActGuankaItem;
	import SJ.Game.fuben.CJActiveFbItem;
	import SJ.Game.fuben.CJFbUtil;
	import SJ.Game.fuben.CJFubenEnterLayer;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJMessageBox;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.display.TiledImage;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.textures.Scale9Textures;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class CJWorldMapLayer extends SLayer
	{
		private var btnTextList:Array =new Array({"name":"maincity","cn":CJLang("WORLDMAP_MAINCITY")},
										{"name":"commonfb","cn":CJLang("WORLDMAP_COMMONFUBEN")});
		private var tabButtonList:Vector.<Button>
		private var contentLayer:SLayer;
		private var _fubenEnterLayer:CJFubenEnterLayer;
		private var _list:List;
		private var _listLayout:VerticalLayout;
		private var _groceryList:ListCollection;
		private var _actionHandler:CJWorldMapAction;
		private var _initData:Object;
		private var _vitlabel:Label;
		
		public function CJWorldMapLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			_init();
			//处理任务引导图标
			if(this._initData && this._initData.hasOwnProperty("fid"))
			{
				
				var dataOfFuben:CJDataOfFuben = CJDataManager.o.getData("CJDataOfFuben") as CJDataOfFuben;
				if(this._initData['fid'] < ConstFuben.COMMOMFUBEN_MAX_ID)
				{
					if(dataOfFuben.lastfid != this._initData['fid'])
					{
						_switchTabContent(tabButtonList[1],this._initData['fid']);
					}
					else
					{
						_switchTabContent(tabButtonList[1]);
						var renderer:CJFubenItem = new CJFubenItem("commonfb",false);
						renderer.data = {'id':this._initData['fid']};
						this._invokeHandler(renderer,this._initData['gid']);
					}
				}
				else
				{
					if(dataOfFuben.lastfid != this._initData['fid'])
					{
						_switchTabContent(tabButtonList[2],this._initData['fid']);
					}
					else
					{
						_switchTabContent(tabButtonList[2]);
						var superRenderer:CJFubenItem = new CJFubenItem("superfb",false);
						superRenderer.data = {'id':this._initData['fid']};
						this._invokeHandler(superRenderer,this._initData['gid']);
					}
				}
				return;
			}
			if(_initData && _initData.hasOwnProperty("cityid"))
			{
				_switchTabContent(tabButtonList[0],_initData['cityid']);
			}
			else if(_initData && _initData.hasOwnProperty("superfb"))
			{
				_switchTabContent(tabButtonList[2]);
			}
			else
			{
				_switchTabContent(tabButtonList[0]);
			}
		}
		
		override protected function draw():void
		{
			super.draw();
		}
		/**
		 * 初始化外部传入的数据 
		 * @param data
		 * 
		 */		
		public function initData(data:Object):void
		{
			_initData = data;
		}
		/**
		 * 清除外部传入的数据 
		 * 
		 */		
		private function clearInitData():void
		{
			_initData = null;
		}
		
		private function _init():void
		{
			//界面底图
			var bgFrame:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_quanpingzhuangshidi"),new Rectangle(15,14,2,2)));
			bgFrame.width = Starling.current.stage.stageWidth
			bgFrame.height = Starling.current.stage.stageHeight;
			this.addChildAt(bgFrame,0);
			this.setSize(bgFrame.width,bgFrame.height);
			var topImage:TiledImage = new TiledImage(SApplication.assets.getTexture("common_quanpingtoubudi"));
			topImage.width = SApplicationConfig.o.stageWidth;
			this.addChildAt(topImage,1);
			
			var title:CJPanelTitle = new CJPanelTitle(CJLang("WORLDMAP_MAP"));
			title.x = 100;
			this.addChild(title);
			
			var vitlabeltxt:Label = new Label;
			vitlabeltxt.textRendererProperties.textFormat = ConstTextFormat.textformat;
			vitlabeltxt.x= 44;
			vitlabeltxt.y = 26;
			vitlabeltxt.text = CJLang("FUBEN_VITTEXT");
			this.addChild(vitlabeltxt);
			
			_vitlabel = new Label;
			_vitlabel.textRendererProperties.textFormat = ConstTextFormat.textformat;
			_vitlabel.x = 84;
			_vitlabel.y = 26;
			_vitlabel.text = String(CJDataManager.o.DataOfRole.vit)+"/"+CJDataOfGlobalConfigProperty.o.getData("VIT_MAX");
			this.addChild(_vitlabel);
				
			var _buyBtn:Button = CJButtonUtil.createCommonButton(CJLang("WORLDMAP_BUCHONGTILI"));
			_buyBtn.addEventListener(Event.TRIGGERED,function(e:*):void{
				CJFbUtil.buyvitUtil();
			});
			_buyBtn.x = 124;
			_buyBtn.y = 19;
			this.addChild(_buyBtn);
			
			var btnClose:Button = new Button;
			var btntxture:Texture = SApplication.assets.getTexture("common_quanpingguanbianniu01");
			btnClose.defaultSkin = new SImage(btntxture);
			btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_quanpingguanbianniu02"));
			btnClose.addEventListener(Event.TRIGGERED,function(e:*):void{
				exit();
			});
			btnClose.x = Starling.current.stage.stageWidth-btntxture.width
			this.addChild(btnClose);
			
			tabButtonList = new Vector.<Button>;
			var j:int = 0
			
				//精英副本如果开启，则显示精英副本标签 
			if(CJDataManager.o.DataOfFuncList.isFunctionOpen("CJWorldMapModule"))
			{
				this.btnTextList.push({"name":"superfb","cn":CJLang("WORLDMAP_SUPERFUBEN")});
			}
			if(CJDataManager.o.DataOfFuncList.isFunctionOpen("CJActiveFbModule"))
			{
				this.btnTextList.push({"name":"actfb","cn":CJLang("WORLDMAP_ACTFUBEN")});
			}
			for(var i:String in this.btnTextList)
			{
				var tabBtn:Button = new Button
				tabBtn.defaultSkin = new SImage(SApplication.assets.getTexture("common_xuanxiangka02"));
				tabBtn.defaultSelectedSkin = new SImage(SApplication.assets.getTexture("common_xuanxiangka01"));
				tabBtn.defaultLabelProperties.textFormat = ConstTextFormat.textformat;
				tabBtn.label = btnTextList[i]["cn"];
				tabBtn.name = btnTextList[i]["name"];
				tabBtn.x = 2;
				tabBtn.y = 50 + j* (34 + 32)
				tabBtn.addEventListener(Event.TRIGGERED,tabClickHandler);
				this.addChild(tabBtn);
				tabButtonList.push(tabBtn);
				j++;
			}
			contentLayer = new SLayer;
			contentLayer.x = 66;
			contentLayer.y = 43;
			this.addChild(contentLayer)
			
			_actionHandler = new CJWorldMapAction();
			this.addChild(_actionHandler);
			
			initContent();
			initList();
			initListener();
		}
		
		private function initListener():void
		{
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, buyVitRet);
		}
		
		private function initContent():void
		{
			var bg : Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_dinew") , new Rectangle(2 , 2 , 1, 1)));
			bg.width = 412;
			bg.height = 276;
			contentLayer.addChild(bg);
			
			//滚珠
			var bgBall:CJPanelFrame = new CJPanelFrame(405 , 270);
			bgBall.x = 5;
			bgBall.y = 5;
			contentLayer.addChild(bgBall);
			
			//底框
			var bgWrap:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_waikuangnew") , new Rectangle(15 , 15 , 1, 1)));
			bgWrap.width = 412;
			bgWrap.height = 276;
			contentLayer.addChild(bgWrap);	

		}
		
		private function initList():void
		{
			_list = new List;
			_list.addEventListener("click",clickHandler);
			_list.addEventListener("showGuankaTip",openGuankaTips);
			_list.width = 376
			_list.height = 250;
			_list.x = 17
			_list.y = 15
			_listLayout = new VerticalLayout();
			_listLayout.gap = 4;
			_listLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_TOP;
			_list.layout = _listLayout;
			contentLayer.addChild(_list);
		}

		private function clickHandler(e:Event):void
		{
			var item:IListItemRenderer = e.target as IListItemRenderer;
			_invokeHandler(item);
		}
		
		private function _invokeHandler(item:IListItemRenderer,taskgid:int = 0):void
		{
			switch(item.name)
			{
				case "CJMainCityItem":
					if(CJDataOfScene.o.sceneid == item.data['id'])
					{
						SApplication.moduleManager.exitModule("CJWorldMapModule");
						return;
					}
					_actionHandler.changeScene(item.data['id'],function():void
					{
						SApplication.moduleManager.exitModule("CJWorldMapModule");
					});
					break;
				case "commonfb":
				case "superfb":
					var dataOfFuben:CJDataOfFuben = CJDataManager.o.getData("CJDataOfFuben") as CJDataOfFuben;
					dataOfFuben.lastfid = item.data['id'];
					SocketManager.o.callwithRtn(ConstNetCommand.CS_FUBEN_GETFUBENINFO,function(message:SocketMessage):void
					{
						showGuankaItem(message.retparams["list"],item.data,taskgid);
					},false,item.data['id']);
					break;
				case "CJGuankaItem":
					var _dataEnterGuanqia:CJDataOfEnterGuanqia = CJDataOfEnterGuanqia.o;
					var guankaProperty:Json_fuben_guanka_config = CJDataOfGuankaProperty.o.getPropertyById(item.data['id']);
					_dataEnterGuanqia.fubenId = item.data['fid'];
					_dataEnterGuanqia.guanqiaId = item.data['id'];
					_dataEnterGuanqia.firstFightId = guankaProperty.zid1;
					ConstDynamic.isEnterFromFuben = ConstDynamic.ENTER_FROM_FB;
					CJFbUtil.enterFb()
					break;
				case "CJActiveFbItem":
					var aid:int = int(item.data['id'])
					var conf:Json_activefuben = CJDataOfActiveFbProperty.o.getPropertyById(aid)
					var actdata:CJDataOfActFb = CJDataManager.o.getData("CJDataOfActFb") as CJDataOfActFb;
					var itemdata:Object = getUserActInfo(actdata.fbdata,aid)
					itemdata['fid'] = aid;
					var listData:Array = this.getActGuankaData(itemdata);
					_list.itemRendererFactory = actGuankaItemRendererFactory;
					setDataToList(listData)
					break;
			}
		}
		
		private function getUserActInfo(dataList:Object,fid:int):Object
		{
			var obj:Object = {}
			for(var i:String in dataList)
			{
				if(int(dataList[i].fid) == fid)
				{
					obj = dataList[i]
					break;
				}
			}
			return obj;
		}
		
		private function getActGuankaData(data:Object):Array
		{
			var _aid:int = data['fid'];
			var actConfig:Json_activefuben = CJDataOfActiveFbProperty.o.getPropertyById(_aid)
			var listData:Array = new Array
			
			var role:CJDataOfRole = CJDataManager.o.getData("CJDataOfRole") as CJDataOfRole
			var vip:int = role.vipLevel;
			var vipConf:Json_vip_function_setting = CJDataOfVipFuncSetting.o.getData(String(vip));
			
			for(var i:int = 1;i<=12;i++)
			{
				var key:String = "gids"+String(i)
				if(actConfig.hasOwnProperty(key) && actConfig[key])
				{
					var guankaProperty:Json_fuben_guanka_config = CJDataOfGuankaProperty.o.getPropertyById(actConfig[key]);
					var totalNum:int = guankaProperty.totalnum;
					totalNum = totalNum + int(vipConf.actfb_extracount);
					var useritem:Object = {}
					var actdata:CJDataOfActFb = CJDataManager.o.getData("CJDataOfActFb") as CJDataOfActFb;
					var itemdata:Object = actdata.getfbdetail(_aid,actConfig[key]);
					var num:int = 0;
					if(itemdata)
					{
						num = itemdata['num'];
					}
					num = Math.max(0,totalNum - num);
					useritem['fid'] = _aid
					useritem['gvit'] = guankaProperty.needvit;
					useritem['vit'] = role.vit
					useritem['fzid'] = guankaProperty.zid1
					useritem['gid'] = actConfig[key];
					useritem['num'] = num;
					useritem['name'] = guankaProperty.name;
					useritem['desc'] = guankaProperty.desc;
					listData.push(useritem)
				}
			}
			return listData;
		}
		private function setDataToList(data:Array):void
		{
			_groceryList = new ListCollection(data);
			_list.dataProvider = _groceryList;

		}
		/**
		 * 主城ITEM 
		 * @return 
		 * 
		 */		
		private function listItemRendererFactory():IListItemRenderer
		{
			const renderer:CJMainCityItem = new CJMainCityItem();
			return renderer;
		}
		/**
		 * 普通副本ITEM 
		 * @return 
		 * 
		 */		
		private function commfbItemRendererFactory():IListItemRenderer
		{
			const renderer:CJFubenItem = new CJFubenItem("commonfb",false);
			return renderer;
		}
		/**
		 * 精英副本ITEM 
		 * @return 
		 * 
		 */		
		private function superfbItemRendererFactory():IListItemRenderer
		{
			const renderer:CJFubenItem = new CJFubenItem("superfb",false);
			return renderer;
		}
		/**
		 * 关卡ITEM 
		 * @return 
		 * 
		 */		
		private function guankaItemRendererFactory():IListItemRenderer
		{
			const renderer:CJGuankaItem = new CJGuankaItem();
			return renderer;
		}
		/**
		 *  活动副本ITEM
		 * @return 
		 * 
		 */
		private function actfubenItemRendererFactory():IListItemRenderer
		{
			const renderer:CJActiveFbItem = new CJActiveFbItem();
			return renderer;
		}
		
		private function actGuankaItemRendererFactory():IListItemRenderer
		{
			const renderer:CJActGuankaItem = new CJActGuankaItem();
			return renderer;	
		}
		
		/**
		 * TAB 点击事件 
		 * @param e
		 * 
		 */		
		private function tabClickHandler(e:Event):void
		{
			var currObj:Button = e.currentTarget as Button;
			clearInitData();
			_switchTabContent(currObj);
		}
		
		private function _switchTabContent(buttonObj:Button,taskgid:int = 0):void
		{
			_switchTabButton(buttonObj);
			var level:String = CJDataManager.o.DataOfHeroList.getMainHero().level;
			var mainCityOpendata:Vector.<Object>;
			mainCityOpendata = CJDataOfMainSceneProperty.o.getList(level);
			var mainOpenCityIds:Vector.<int> = CJDataOfMainSceneProperty.o.getIdsByList(mainCityOpendata);
			switch(buttonObj.name)
			{
				case "maincity":
					var arr:Array = new Array;
					for(var i:String in mainCityOpendata)
					{
						var item:Object = new Object;
						item['name'] = CJLang(mainCityOpendata[i]['name']);
						item['barname'] = CJLang(mainCityOpendata[i]['barname']);
						item['openlevel'] = mainCityOpendata[i]['openlevel'];
						item['id'] = mainCityOpendata[i]['id'];
						item['taskid'] = taskgid;
						item['barnamecolor'] = mainCityOpendata[i]['bartextcolor'];
						arr.push(item);
					}
					_list.itemRendererFactory = listItemRendererFactory;
					setDataToList(arr);
					break;
				case "commonfb":
				case "superfb":
					SocketManager.o.callwithRtn(ConstNetCommand.CS_FUBEN_GETALL_FUBENINFO,function(message:SocketMessage):void
					{
						var fubenData:Array = getProcessFubenData(message.retparams,buttonObj.name);
						var superArr:Array = new Array;
//						var data:Vector.<Object> = CJDataOfFubenProperty.o.getFubenInfos(mainOpenCityIds,level,false);
						for(var k:String in fubenData)
						{
							var itemSup:Object = new Object;
							var fubenConf:Json_fuben_config = CJDataOfFubenProperty.o.getPropertyById(fubenData[k]['id']);
							itemSup['name'] = CJLang(fubenConf.name);
							itemSup['desc'] = CJLang(fubenConf.desc);
							itemSup['ret'] = fubenData[k]['ret'];
							itemSup['ispass'] = fubenData[k]['ispass'];
							itemSup['taskid'] = taskgid;
							itemSup['id'] = fubenConf.id;
							superArr.push(itemSup);
						}
						_list.itemRendererFactory = superfbItemRendererFactory;
						superArr.sort(sortOnId);
						setDataToList(superArr);
						
						if(taskgid>0)
						{
							if(!isIdIn(superArr,taskgid))
							{
								CJFlyWordsUtil(CJLang("WORLDMAP_GUANKAUNOPEN"));
							}
						}
					});
					break;
				case "actfb":
					SocketManager.o.callwithRtn(ConstNetCommand.CS_ACTFUBEN_GETALL_FUBENINFO,function(message:SocketMessage):void
					{
						var data:Object = message.retparams;
						var actdata:CJDataOfActFb = CJDataManager.o.getData("CJDataOfActFb") as CJDataOfActFb;
						actdata.fbdata = data["datalist"];
						actdata.actdata = data["actList"];
//						_data = message["datalist"]
						var actList:Object = data["actList"]
						var listData:Array = new Array
						for(var i:String in actList)
						{
							var conf:Json_activefuben = CJDataOfActiveFbProperty.o.getPropertyById(actList[i]['fid'])
							var detail:Object = actList[i];
							detail['icon'] = conf.icon;
							detail['decs'] = conf.decs;
							detail['name'] = conf.name;
							detail['id'] = actList[i]['fid'];
							listData.push(detail)
						}
						_list.itemRendererFactory = actfubenItemRendererFactory;
						setDataToList(listData);
					});
					break;
			}
		}
		
		private function _switchTabButton(buttonObj:Button):void
		{
			for(var i:String in this.tabButtonList)
			{
				if(this.tabButtonList[i] == buttonObj)
				{
					this.tabButtonList[i].isSelected = true;
				}
				else
				{
					this.tabButtonList[i].isSelected = false;
				}
			}
		}
		
		private function showGuankaItem(data:Object,itemdata:Object,taskgid:int):void
		{
			var guankaArr:Array = new Array;
			var fid:int = itemdata['id'];
			var guankaList:Vector.<Object> = CJDataOfFubenProperty.o.getGuankaInfos(fid);
			var guankaData:Array = this.getProcessGuankaData(data);
			//如果此任务关卡是从副本进入的，而不是直接进入关卡的。则需修正任务关卡ID
			if(itemdata['taskid']>0)
			{
				taskgid = this._initData['gid'];
			}
			
			for(var i:String in guankaData)
			{
				var guankaConf:Object = CJDataOfGuankaProperty.o.getPropertyById(guankaData[i]['id']);
				var itemGuanka:Object = new Object;
				itemGuanka['name'] = CJLang(guankaConf['name']);
				itemGuanka['code'] = guankaData[i]['code'];
				itemGuanka['reason'] = guankaData[i]['reason'];
				itemGuanka['needvit'] = guankaConf['needvit'];
				itemGuanka['id'] = guankaConf['id'];
				itemGuanka['taskgid'] = taskgid;
				itemGuanka['fid'] = fid;
				itemGuanka['level'] = guankaConf['openvalue'];
				itemGuanka['desc'] = CJLang(guankaConf['desc']);
				guankaArr.push(itemGuanka);
			}
			_list.itemRendererFactory = guankaItemRendererFactory;
			guankaArr.sort(sortOnId);
			setDataToList(guankaArr);
			//日常任务引导到副本界面，可能此关卡还未开启，增加飘字提示
			if(taskgid>0 && !isIdIn(guankaArr,taskgid))
			{
				CJFlyWordsUtil(CJLang("WORLDMAP_GUANKAUNOPEN"));
			}
		}
		
		private function isIdIn(dataArr:Array,gid:int):Boolean
		{
			var isIn:Boolean = false;
			for(var i:String in dataArr)
			{
				if(dataArr[i]['id'] == gid)
				{
					isIn = true;
					break;
				}
			}
			return isIn;
		}
		
		private function sortOnId(a:Object,b:Object):Number
		{
			if(int(a.id)>int(b.id))
			{
				return -1;
			}
			else if(int(a.id)<int(b.id))
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
		
		private function openGuankaTips(e:Event):void
		{
			var fid:int = e.data['fid'];
			var gid:int = e.data['id'];
			if(!_fubenEnterLayer)
			{
				//初始化副本进入界面
				var fubenEnterXml:XML = AssetManagerUtil.o.getObject(ConstResource.sResSxmlFubenEnterLayOut) as XML;
				_fubenEnterLayer = SFeatherControlUtils.o.genLayoutFromXML(fubenEnterXml, CJFubenEnterLayer) as CJFubenEnterLayer;
				_fubenEnterLayer.addEventListener(Event.REMOVED_FROM_STAGE,function():void
				{
					_fubenEnterLayer.removeEventListeners(Event.REMOVED_FROM_STAGE);
					_fubenEnterLayer = null;
				})
			}
			_fubenEnterLayer.data = {fid:fid,gid:gid};
			CJLayerManager.o.addModuleLayer(_fubenEnterLayer);
		}
		
		private function getProcessFubenData(data:Object,type:String):Array
		{
			var passList:Array = new Array;
			var newOpenList:Array = new Array;
			var unOpenList:Array = new Array;
			for(var fid:String in data)
			{
				data[fid]['id'] = fid;
				if(type == "commonfb" && int(fid) > ConstFuben.COMMOMFUBEN_MAX_ID)
				{
					continue;
				}
				if(type == "superfb" && int(fid) < ConstFuben.COMMOMFUBEN_MAX_ID)
				{
					continue;
				}
				if(data[fid]['ret'] == 1)
				{
					//已通关的
					if(data[fid]['ispass'] == 1)
					{
						passList.push(data[fid]);
					}
					else //新开启的
					{
						newOpenList.push(data[fid]);
					}
				} //未达到条件的
				else
				{
					unOpenList.push(data[fid]);
				}
			}
			if(newOpenList.length>0)
			{
				passList.unshift(newOpenList[0]);
			}
			else
			{
				if(unOpenList.length > 0)
				{
					passList.unshift(unOpenList[0]);
				}
			}
			return passList;
		}
		
		private function getProcessGuankaData(data:Object):Array
		{
			var passList:Array = new Array;
			for(var i:String in data)
			{
				if(data[i]['code'] == CJGuankaItem.GUANKA_PASS)
				{
					data[i]['id'] = i;
					passList.push(data[i]);
				}
			}
			var canEnterList:Array = new Array;
			for(var i:String in data)
			{
				if(data[i]['code'] == CJGuankaItem.GUANKA_CANENTER)
				{
					data[i]['id'] = i;
					canEnterList.push(data[i]);
				}
			}
			if(canEnterList.length == 0)
			{
				var underLevelList:Array = new Array;
				for(var i:String in data)
				{
					if(data[i]['code'] == CJGuankaItem.GUANKA_UNPASS)
					{
						data[i]['id'] = i;
						underLevelList.push(data[i]);
					}
				}
				if(underLevelList.length >0)
				{
					passList.unshift(underLevelList[0])
				}
			}
			else
			{
				passList.unshift(canEnterList[0]);
			}
			return passList;
		}
		
		private function buyVitRet(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() == ConstNetCommand.CS_FUBEN_BUYVIT)
			{
				if(message.retcode !=0)
				{
					switch(message.retcode)
					{
						case 1:
							CJMessageBox(CJLang("ERROR_HEROTAG_GOLD"))
							break;
						case 2:
							CJMessageBox(CJLang("FUBEN_BUYVIT_HASMAXNUMS"))
							break;
					}
					return;
				}
				var rtnObject:Object = message.retparams;
				_vitlabel.text = String(rtnObject[0])+"/"+CJDataOfGlobalConfigProperty.o.getData("VIT_MAX");
				var vittips:String = CJLang("FUBEN_BUYVIT_SUCC_TIPS")
				vittips = vittips.replace("{totalnum}",message.retparams[2]);
				vittips = vittips.replace("{currentnum}",message.retparams[1]);
				CJFlyWordsUtil(vittips);
				SocketCommand_role.get_role_info();
			}
		}
		
		private function exit():void
		{
			SApplication.moduleManager.exitModule("CJWorldMapModule");
		}
	}
}