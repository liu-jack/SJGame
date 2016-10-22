package SJ.Game.fuben
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
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfEnterGuanqia;
	import SJ.Game.data.CJDataOfFuben;
	import SJ.Game.data.CJDataOfScene;
	import SJ.Game.data.CJDataOfTask;
	import SJ.Game.data.config.CJDataOfFubenProperty;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.config.CJDataOfGuankaProperty;
	import SJ.Game.data.json.Json_fuben_config;
	import SJ.Game.data.json.Json_fuben_guanka_config;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.loader.CJLoaderMoudle;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.display.TiledImage;
	import feathers.textures.Scale9Textures;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 *  副本信息显示界面
	 * @author yongjun
	 * 
	 */
	public class CJFubenLayer extends SLayer
	{
		private var _bgFrame:Scale9Image;
		private var _titleFrame:Scale9Image;
		
		private var _labeltitle:Label
		private var _labelsmalltitle:Label
		private var _vitlabel:Label
		private var _vitlabeltxt:Label
		private var _leftpagebtn:Button
		private var _rightpagebtn:Button
		private var _fubenname:Label
		private var _fubenimg:ImageLoader
		private var _fubenkuang:Scale9Image;
		private var _btnClose:Button;
		private var _buyBtn:Button;
		//当前副本ID
		private var _fid:int;
		//关卡进入弹出面板
		private var _fubenEnterLayer:CJFubenEnterLayer
		//当前页
		private var _currentPage:int = 1;
		//总页数
		private var _totalPage:int = 1;
		//副本数据
		private var _data:Object;
		
		private var _isSuperFb:Boolean = false;
		private var _redquad:Quad;
		
		public function CJFubenLayer()
		{
			super();
		}
		public function get labeltitle():Label
		{
			return this._labeltitle;
		}
		public function set labeltitle(label:Label):void
		{
			this._labeltitle = label;
		}
		public function get labelsmalltitle():Label
		{
			return this._labelsmalltitle;
		}
		public function set labelsmalltitle(label:Label):void
		{
			_labelsmalltitle = label
		}
		public function get vitlabel():Label
		{
			return this._vitlabel;
		}
		public function set vitlabel(label:Label):void
		{
			this._vitlabel = label;
		}
		public function get leftpagebtn():Button
		{
			return this._leftpagebtn;
		}
		public function set leftpagebtn(value:Button):void
		{
			this._leftpagebtn = value;
		}
		public function get rightpagebtn():Button
		{
			return this._rightpagebtn;
		}
		public function set rightpagebtn(value:Button):void
		{
			this._rightpagebtn = value;
		}
		public function get fubenname():Label
		{
			return this._fubenname;
		}
		public function set vitlabeltxt(value:Label):void
		{
			_vitlabeltxt = value;
		}
		public function get vitlabeltxt():Label
		{
			return _vitlabeltxt
		}
		public function set fubenname(label:Label):void
		{
			this._fubenname = label;
		}
		public function get btnClose():Button
		{
			return _btnClose;
		}
		
		public function set btnClose(value:Button):void
		{
			_btnClose = value;
		}
		public function get fubenimg():ImageLoader
		{
			return _fubenimg;
		}
		public function set fubenimg(value:ImageLoader):void
		{
			_fubenimg = value;
		}
		
		override protected function initialize():void
		{
			_drawContent();
		}
		
		public function get fubenEnterLayer():CJFubenEnterLayer
		{
			return this._fubenEnterLayer
		}
		
		/**
		 * 绘制内容 
		 * 
		 */
		private function _drawContent():void
		{
			//界面底图
			this._bgFrame= new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_quanpingzhuangshidi"),new Rectangle(15,14,2,2)));
			this._bgFrame.width = Starling.current.stage.stageWidth
			this._bgFrame.height = Starling.current.stage.stageHeight;
			this.addChildAt(this._bgFrame,0);
			
			var topImage:TiledImage = new TiledImage(SApplication.assets.getTexture("common_quanpingtoubudi"));
			topImage.width = SApplicationConfig.o.stageWidth;
			this.addChildAt(topImage,1);
			
			this._titleFrame= new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_fubenzhangjiedi"),new Rectangle(14,13,2,2)));
			this._titleFrame.x = 12;
			this._titleFrame.y = 25;
			this._titleFrame.width = 122;
			this._titleFrame.height = 30;
			this.addChildAt(this._titleFrame,1);
			
			var cjdataof:CJDataOfFuben = (CJDataManager.o.getData("CJDataOfFuben") as CJDataOfFuben)
			var titleStr:String = (cjdataof.from == ConstFuben.FUBEN_SUPER)?CJLang("FUBEN_SUPER_TEXT"):CJLang("FUBEN_TEXT")
			var title:CJPanelTitle = new CJPanelTitle(titleStr);
			title.x = 100;
			this.addChild(title);
			
			this.setSize(this._bgFrame.width,this._bgFrame.height);
			
			this._labelsmalltitle.textRendererProperties.textFormat = ConstTextFormat.smallTitleformat;
			this._fubenname.textRendererProperties.textFormat = ConstTextFormat.textformat;
			this._vitlabel.textRendererProperties.textFormat = ConstTextFormat.textformat;
			this._vitlabeltxt.textRendererProperties.textFormat = ConstTextFormat.textformat;
			
			//关闭按钮
			_btnClose.defaultSkin = new SImage(SApplication.assets.getTexture("common_quanpingguanbianniu01"));
			_btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_quanpingguanbianniu02"));
			_btnClose.addEventListener(Event.TRIGGERED,function(e:*):void{
				exit();
			});
			_btnClose.x = Starling.current.stage.stageWidth-_btnClose.width

			//购买按钮
			_buyBtn = CJButtonUtil.createCommonButton(CJLang("FUBEN_VITBUY"));
			_buyBtn.addEventListener(Event.TRIGGERED,function(e:*):void{
				CJFbUtil.buyvitUtil();
			});
			_buyBtn.x = 376;
			_buyBtn.y = 25;
			this.addChild(_buyBtn);
			
			_vitlabeltxt.text = CJLang("FUBEN_VITTEXT");
			
			var tipBtn:Button = new Button;
			tipBtn.defaultIcon = new SImage(SApplication.assets.getTexture("fuben_i"));
			tipBtn.addEventListener(Event.TRIGGERED,function():void
			{
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
				_fubenEnterLayer.data = {fid:_fid,gid:300};
				CJLayerManager.o.addModuleLayer(_fubenEnterLayer);
			});
			tipBtn.x = 150;
			tipBtn.y = 24;
			this.addChild(tipBtn);
				
			if(cjdataof.from == ConstFuben.FUBEN_SUPER)
			{
				_initRedMask();
			}
			else
			{
				if(this._redquad && this._redquad.parent)
				{
					this._redquad.removeFromParent(true);
				}
			}
			//副本图片外框
			this._fubenkuang = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("fuben_kuang"),new Rectangle(9,9,1,1)));
			_fubenkuang.width = 457;
			_fubenkuang.height = 248;
			_fubenkuang.x = 12;
			_fubenkuang.y = 55;
			this.addChildAt(_fubenkuang,2);
			
			fubenname.y =15;
				
//			this._rightpagebtn.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeright01"));
//			this._rightpagebtn.disabledIcon =new SImage(SApplication.assets.getTexture("common_fanyeright02"));
//			this._leftpagebtn.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeright01"));
//			this._leftpagebtn.disabledIcon =new SImage(SApplication.assets.getTexture("common_fanyeright02"));
			//设置左翻页按钮
			_leftpagebtn.pivotX = _leftpagebtn.width>>1;
			_leftpagebtn.pivotY = _leftpagebtn.height>>1;
			_leftpagebtn.rotation = Math.PI;
			_leftpagebtn.x +=25;
			_leftpagebtn.y += _leftpagebtn.height+40;
			//翻页按钮
			_rightpagebtn.addEventListener(Event.TRIGGERED,pageHandler);
			_leftpagebtn.addEventListener(Event.TRIGGERED,pageHandler);
			
			updatePage(this._currentPage);
			if(_guidGid && !_isBackToGuanqia)
			{
				var guidItem:CJGuankaItem = this.getItemById(_guidGid)
				_guidIcon = new CJFubenTaskGuidIcon
				_guidIcon.x = guidItem.x+((guidItem.width-_guidIcon.width)>>1);
				_guidIcon.y = guidItem.y+((guidItem.height -_guidIcon.height)>>1+2);
				this.addChild(_guidIcon);
			}
//			CJLayerRandomBackGround.Close();
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, buyVitRet);
		}
		

		
		private function _initRedMask():void
		{
			_redquad = new Quad(457,248,0xFF0000)
			_redquad.alpha = 0.35;
			_redquad.touchable = false;
			_redquad.x = 12;
			_redquad.y = 55;
			this.addChild(_redquad)
		}
		public function set isSuperFb(b:Boolean):void
		{
			_isSuperFb = b	
		}
		override public function dispose():void
		{
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, buyVitRet);
			super.dispose();
		}
		
		
		/**
		 * 购买体力结果 
		 * @param e
		 * 
		 */	
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
		
		/**
		 *设置界面数据，并更新 
		 * @param d
		 * 
		 */	
		private var _confirmText:String
		private var _guidGid:int
		private var _fubenProperty:Json_fuben_config;
		//标志战斗结束后是否返回关卡
		private var _isBackToGuanqia:Boolean;//add by zhengzheng
		public function set data(d:Object):void
		{
			_isBackToGuanqia = d.isBackToGuanqia;
			_fid = d.fid;
			_fubenProperty= CJDataOfFubenProperty.o.getPropertyById(_fid);
			var totalGids:Array = _fubenProperty.gids;
			this._totalPage = Math.ceil(totalGids.length/CJDataOfFubenProperty._pageNum);
			//引导关卡ID ，需显示引导
			_guidGid = d.gid;
			
			//如果d.gid为0，则非任务触发，根据当前任务的npcid获得当前所在地图id，若当前地图id与任务涉及地图id相同，则显示任务图标
			if(d.gid==0)
			{
				var curTask:CJDataOfTask = CJDataManager.o.DataOfTaskList.getCurrentMainTask();
				if(curTask != null)
				{
					var gid:int = curTask.taskConfig.key2;
					var fid:int = CJDataOfFubenProperty.o.getFidByGid(gid);
					if(_fid == fid)_guidGid = gid;
				}
			}
			
			// 如果有任务引导，可能会引导到后面几页
			if(_guidGid)
			{
				var guidPage:int = CJDataOfFubenProperty.o.getPageById(_fid,_guidGid)
				this._currentPage = guidPage
			}
			_labelsmalltitle.text =  CJLang(_fubenProperty.name)+String(this._currentPage)+"/"+String(this._totalPage);//CJLang(fubenProperty.desc);

		}
		/**
		 *    控制翻页
		 * @param e
		 * 
		 */
		private function pageHandler(e:Event):void
		{
			var page:int = this._currentPage;
			if(e.currentTarget == this._rightpagebtn)
			{
				page++;
			}
			if(e.currentTarget == this._leftpagebtn)
			{
				page--;
			}
			if(page>this._totalPage)
			{
				page = this._totalPage;
			}
			if(page<1)
			{
				page =1;
			}
			if(page == this._currentPage)return;
			this._currentPage = page;
			updatePage(this._currentPage);
			refreshPageBtn();
		}
		
		private function refreshPageBtn():void
		{
			if(this._totalPage>1)
			{
				if(this._currentPage == this._totalPage)
				{
					this._rightpagebtn.visible = false;
					this._leftpagebtn.visible = true;
				}
				if(this._currentPage == 1)
				{
					this._leftpagebtn.visible = false;
					this._rightpagebtn.visible = true;
				}
			}
			else
			{
				this._rightpagebtn.visible = this._leftpagebtn.visible = false;
			}
		}
		/**
		 * 更新页面内容 
		 * @param page
		 * 
		 */
		private var _itemList:Vector.<CJGuankaItem> = new Vector.<CJGuankaItem>;
		private function updatePage(page:int):void
		{
			this._currentPage = page;
			this.clearGuankaItem();
			if(_guidIcon)
			{
				_guidIcon.removeFromParent(true);
			}
			var bgimg:String = CJDataOfFubenProperty.o.getPageBgimg(_fid,page);
			//设置背景图
			_fubenimg.source = SApplication.assets.getTexture(bgimg);
			_fubenimg.x = 17
			//设置关卡
			var gids:Array = CJDataOfFubenProperty.o.getPageGuankaIds(_fid,page);
			for(var i:String in gids)
			{
				var guankaProperty:Json_fuben_guanka_config = CJDataOfGuankaProperty.o.getPropertyById(gids[i]);
				var guankaItem:CJGuankaItem = new CJGuankaItem(gids[i]);
				guankaItem.source = guankaProperty.icon;
				guankaItem.gname = guankaProperty.name;
				
				guankaItem.x = guankaProperty.posx
				guankaItem.y = guankaProperty.posy
				guankaItem.addEventListener(TouchEvent.TOUCH,touchHandler);
				this.addChild(guankaItem)
				_itemList.push(guankaItem);
			}
			updateItemStats()
			refreshPageBtn();
			_labelsmalltitle.text =  CJLang(_fubenProperty.name)+String(this._currentPage)+"/"+String(this._totalPage);
		}
		
		private function getItemById(id:int):CJGuankaItem
		{
			var item:CJGuankaItem
			for(var i:String in this._itemList)
			{
				if(this._itemList[i].id == id)
				{
					item = this._itemList[i];
					break;
				}
			}
			return item
		}
		/**
		 * 更新体力 
		 * @param vit
		 * 
		 */
		public function updateVit(vit:int):void
		{
			_vitlabel.text = String(vit)+"/"+CJDataOfGlobalConfigProperty.o.getData("VIT_MAX");
		}
		private var _guidIcon:CJFubenTaskGuidIcon
		public function set fubenData(value:Object):void
		{
			_data = value;
		}
		/**
		 * 更新关卡状态
		 * @param data
		 * 
		 */
		public function updateItemStats():void
		{
			for(var i:String in _itemList)
			{
				if(_data.hasOwnProperty(_itemList[i].id))
				{
					_itemList[i].reasonCode = _data[_itemList[i].id]['reason'];
					switch(_data[_itemList[i].id]['code'])
					{
						case CJGuankaItem.GUANKA_UNPASS://不可进入
							_itemList[i].status = CJGuankaItem.GUANKA_UNPASS
							break;
						case CJGuankaItem.GUANKA_CANENTER://可进入
							_itemList[i].status = CJGuankaItem.GUANKA_CANENTER
							break;
						case CJGuankaItem.GUANKA_PASS://已通关
							_itemList[i].status = CJGuankaItem.GUANKA_PASS
							break;
					}
				}
			}
		}
		/**
		 * 清除关卡item 
		 * 
		 */
		private function clearGuankaItem():void
		{
			for each(var item:CJGuankaItem in _itemList)
			{
				item.removeEventListener(TouchEvent.TOUCH,touchHandler);
				item.removeFromParent(true);
			}
		}

		private function touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(touch && touch.phase == TouchPhase.BEGAN)
			{
				var item:CJGuankaItem = e.currentTarget as CJGuankaItem;
				if(item.status == CJGuankaItem.GUANKA_PASS || item.status == CJGuankaItem.GUANKA_CANENTER)
				{
					var _dataEnterGuanqia:CJDataOfEnterGuanqia = CJDataOfEnterGuanqia.o;
					var guankaProperty:Json_fuben_guanka_config = CJDataOfGuankaProperty.o.getPropertyById(item.id);
//					SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadAssistantInfo);
					_dataEnterGuanqia.fubenId = _fid;
					_dataEnterGuanqia.guanqiaId = item.id;
					_dataEnterGuanqia.firstFightId = guankaProperty.zid1;
					ConstDynamic.isEnterFromFuben = ConstDynamic.ENTER_FROM_FB;
					CJFbUtil.enterFb()
					return;
				}
				else if(item.status == CJGuankaItem.GUANKA_UNPASS)
				{
					var reason:int = item.reasonCode;
					var reasonStr:String = "";
					switch(reason)
					{
						case 1:
							break;
						case 2:
							reasonStr = CJLang("FUBEN_GUANKATASK_UNABLE");
							break;
						case 3:
							reasonStr = CJLang("FUBEN_GUANKAPREFID_UNABLE");
							break;
					}
					CJFlyWordsUtil(reasonStr);
				}
			}
		}
		
		/**
		 * 退出副本界面 
		 * 
		 */		
		public function exit():void
		{
			if(this._fubenEnterLayer)
			{
				this._fubenEnterLayer.exit();
				this._fubenEnterLayer = null;
			}
			SApplication.moduleManager.exitModule("CJFubenModule");
			var cjdataof:CJDataOfFuben = (CJDataManager.o.getData("CJDataOfFuben") as CJDataOfFuben)
			if(cjdataof.from == ConstFuben.FUBEN_SUPER)
			{
				cjdataof.gotos = ConstFuben.FUBEN_SUPER;
			}
			
			//如果当前场景是世界则关闭副本回到世界，
			if(!CJDataOfScene.o.isInMainCity)
			{
				CJLoaderMoudle.helper_enterWorld({cityid:CJDataOfScene.o.fromSceneId});
			}
		}
	}
}