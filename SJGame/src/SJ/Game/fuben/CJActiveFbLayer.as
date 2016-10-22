package SJ.Game.fuben
{
	import flash.geom.Rectangle;
	
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfActFb;
	import SJ.Game.data.config.CJDataOfActiveFbProperty;
	import SJ.Game.data.json.Json_activefuben;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJMessageBox;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	
	/**
	 * 活动副本UI
	 * @author yongjun
	 * 
	 */
	public class CJActiveFbLayer extends SLayer
	{
		
		private var _list:List
		private var _data:Object
		private var _actList:Object
		private var _listLayout:VerticalLayout
		private var _groceryList:ListCollection 
		private var _title:CJPanelTitle;
		public function CJActiveFbLayer()
		{
			super();
		}
		
		override protected function draw():void
		{
			super.draw();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			_init();
		}
		
		private function _init():void
		{	
			this.setSize(322,278);
			var bg : Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_dinew") , new Rectangle(2 , 2 , 1, 1)));
			bg.width = 322;
			bg.height = 278;
			this.addChild(bg);

			//滚珠
			var bgBall:CJPanelFrame = new CJPanelFrame(315 , 272);
			bgBall.x = 5;
			bgBall.y = 5;
			this.addChild(bgBall);
			
			//底框
			var bgWrap:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_waikuangnew") , new Rectangle(15 , 15 , 1, 1)));
			bgWrap.width = 322;
			bgWrap.height = 278;
			this.addChild(bgWrap);
			
			var _btnClose:Button = new Button
			_btnClose.defaultSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			_btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			_btnClose.addEventListener(Event.TRIGGERED,function(e:*):void{
				exit();
			});
			_btnClose.x = 298;
			_btnClose.y = -17;
			this.addChild(_btnClose)
			
			var titleStr:String = CJLang("ACTFB_TITLE")
			_title = new CJPanelTitle(titleStr)
			this.addChild(_title);
			_title.x = 10
			_title.y = -16
			
			_list = new List;
			_list.addEventListener("click",clickHandler);
			_list.width = 287
			_list.height = 254;
			_list.x = 17
			_list.y = 15
			_list.layout = _listLayout;
			_list.dataProvider = _groceryList;
			_list.itemRendererFactory = listItemRendererFactory;
			this.addChild(_list);
			
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, dataRet);
			
			//处理指引
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
		}
		
		public function set data(data:Object):void
		{
			var actdata:CJDataOfActFb = CJDataManager.o.getData("CJDataOfActFb") as CJDataOfActFb;
			actdata.fbdata = data["datalist"];
			actdata.actdata = data["actList"];
			_data = data["datalist"]
			_actList= data["actList"]
			var listData:Array = new Array
			for(var i:String in _actList)
			{
				var conf:Json_activefuben = CJDataOfActiveFbProperty.o.getPropertyById(_actList[i]['fid'])
				var detail:Object = _actList[i];
				detail['icon'] = conf.icon;
				detail['decs'] = conf.decs;
				detail['name'] = conf.name;
				detail['id'] = _actList[i]['fid'];
				listData.push(detail)
			}
			setDataToList(listData)
		}
		
		private function getActDetail(id:int):Object
		{
			var obj:Object = {}
			for(var i:String in _actList)
			{
				if(_actList[i].fid == id)
				{
					obj = _actList[i]
						break;
				}
			}
			return obj;
		}
		protected function setDataToList(data:Array):void
		{
			_groceryList = new ListCollection(data);
			_listLayout = new VerticalLayout();
			_listLayout.gap = 4;
			_listLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_TOP;		
		}
		public function getUserActInfo(dataList:Object,fid:int):Object
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
		
		protected function listItemRendererFactory():IListItemRenderer
		{
			const renderer:CJActiveFbItem = new CJActiveFbItem();
			return renderer;
		}
		
		public var cjActGuankaLayer:CJActGuankaLayer 
		private function clickHandler(e:Event):void
		{
			var aid:int = int(e.data)
			var conf:Json_activefuben = CJDataOfActiveFbProperty.o.getPropertyById(aid)
			var itemdata:Object = getUserActInfo(_data,aid)
			itemdata['fid'] = aid;
			cjActGuankaLayer = new CJActGuankaLayer
			cjActGuankaLayer.data = itemdata;
			CJLayerManager.o.addModuleLayer(cjActGuankaLayer)
			cjActGuankaLayer.title = CJLang(conf.name);
		}
		
		protected function exit():void
		{
			this.removeFromParent(true)
			SApplication.moduleManager.exitModule("CJActiveFbModule");
		}
		
		public function set title(name:String):void
		{
			_title.titleName = name;
		}
		
		public function dataRet(e:Event):void
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
				SocketCommand_role.get_role_info();
			}
			if(message.getCommand() == ConstNetCommand.CS_ROLE_GET_ROLE_INFO)
			{
				updateList();
			}
		}
		
		private function updateList():void
		{
			if(!this._list)
			{
				return;
			}
			for(var i:int = 0;i<this._list.dataProvider.length;i++)
			{
				this._list.dataProvider.updateItemAt(i);
			}
		}
		
		override public function dispose():void
		{
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, dataRet);
			super.dispose();
		}
	}
}