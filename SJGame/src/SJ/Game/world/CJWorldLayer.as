package SJ.Game.world
{
	import SJ.Common.Constants.ConstFuben;
	import SJ.Game.SocketServer.SocketCommand_scene;
	import SJ.Game.controls.CJFlyWordsUtil;
	import SJ.Game.controls.CJMapUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfFuben;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfHeroList;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.CJDataOfScene;
	import SJ.Game.data.config.CJDataOfFubenProperty;
	import SJ.Game.data.config.CJDataOfMainSceneProperty;
	import SJ.Game.data.config.CJDataOfWorldProperty;
	import SJ.Game.data.json.Json_fuben_config;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.loader.CJLoaderMoudle;
	import SJ.Game.player.CJPlayerData;
	import SJ.Game.player.CJPlayerNpc;
	
	import engine_starling.Events.DataEvent;
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SCamera;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 *  世界地图
	 * @author yongjun
	 * 
	 */
	public class CJWorldLayer extends SLayer
	{
		public function CJWorldLayer()
		{
			super();
			
		}
		private var _mapLayer:SLayer = null;
		//背景地图层
		private var _mapBackGroundLayer:Sprite = null;
		//地图上的元素层
		private var _mapElementLayer:SLayer = null;
		//前景元素层
		private var _elementLayer:SLayer = null;
		//时间地图数据
		private var _data:Object = null;
		//item pool
		private var _itemList:Vector.<CJWorldItem> = new Vector.<CJWorldItem>;
		
		private var _hasExit:Boolean = false;
		
		private var _camera:SCamera;
		
		private static var ITEM_TYPE_CITY:int = 0;
		private static var ITEM_TYPE_FUBEN:int = 1;
		
		private var _back:Button
		//是否精英副本
		private var _isSuperFb:Boolean = false;
		//红色遮罩
		private var _redquad:Quad
		//对应主城跟遮罩纹理名对应表
		private  var worldCityInfo:Object = {"WORLD_NAME_1":{name:"daditu_zhezhao1",x:90},"WORLD_NAME_2":{name:"daditu_zhezhao2",x:500},"WORLD_NAME_3":{name:"daditu_zhezhao3",x:950}}
			
			
		
		/**
		 *  地图层
		 * @return 
		 * 
		 */
		public function get mapLayer():SLayer
		{
			return _mapLayer;
		}
		/**
		 * 元素层
		 * @return 
		 * 
		 */
		public function get elementLayer():SLayer
		{
			return this._elementLayer;
		}
		public function set data(d:Object):void
		{
			_data = d;
			CJDataOfScene.o.fromSceneId = d.cityid;
		}
		
		override protected function initialize():void
		{
			
			_init();
			_initNpc();
			super.initialize();
		}
		
		
		
		/**
		 * 初始化大地图 
		 * 
		 */
		private function _init():void
		{
			_mapLayer = new SLayer;
			_mapElementLayer = new SLayer;
			_elementLayer = new SLayer;
			
			var textures:Vector.<Texture>= SApplication.assets.getTextures("daditu_di");
			
			_mapBackGroundLayer= CJMapUtil.getMapLayer(textures);
			_mapBackGroundLayer.addEventListener(TouchEvent.TOUCH,touchHandler);
			
			this._mapLayer.addChild(_mapBackGroundLayer);
			this._mapLayer.addChild(_mapElementLayer);
			
			
			
			this.addChild(this._mapLayer);
			_camera = new SCamera(_mapLayer);
			_camera.maxx = (textures.length - 1) * SApplicationConfig.o.stageWidth;
			addChild(_camera);
			
			//回城按钮
			var backToCity:SImage = new SImage(SApplication.assets.getTexture("daditu_huicheng"));
//			var backToCityC:SImage = new SImage(SApplication.assets.getTexture("daditu_huicheng1"));
			_back= new Button
			_back.defaultSkin = backToCity;
//			back.downSkin = backToCityC;
			_back.addEventListener(Event.TRIGGERED,backHandler);
			
			_back.x = Starling.current.stage.stageWidth - backToCity.width;
			
			_elementLayer.addChild(_back);
			this.addChild(this._elementLayer);
			
			var cjdataof:CJDataOfFuben = (CJDataManager.o.getData("CJDataOfFuben") as CJDataOfFuben)
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
			_initIcon();
			_initMask();

			//监听主角需要移动事件
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_SCENE_WORLD_MOVE,worldMoveHandler);
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_SCENE_FUBEN_OPEN,worldMoveHandler);
		}
		
		
		private function _initRedMask():void
		{
			_redquad = new Quad(_mapBackGroundLayer.width,Starling.current.stage.stageHeight,0x0200B2)
			_redquad.alpha = 0.42;
			_redquad.touchable = false;
			_mapBackGroundLayer.addChild(_redquad)
		}
		
		private function _initMask():void
		{
			var level:String = CJDataManager.o.DataOfHeroList.getMainHero().level
			var mapInfo:Object  = CJDataOfMainSceneProperty.o.getPropertyByLevel(int(level));
			if(this.worldCityInfo.hasOwnProperty(mapInfo.name))
			{
				var textureObj:Object = worldCityInfo[mapInfo.name];
				var texture:Texture = SApplication.assets.getTexture(textureObj.name);
				var scaletexture:Scale9Textures = new Scale9Textures(texture,new Rectangle(texture.width-4,texture.height,2,2));
				var maskImage:Scale9Image = new Scale9Image(scaletexture,2);
				maskImage.width = (_camera.maxx+1)*SApplicationConfig.o.stageWidth - textureObj.x;
				maskImage.x = textureObj.x;
				maskImage.touchable = false;
				maskImage.alpha = 0.7;
				this._mapElementLayer.addChild(maskImage);
			}
			
		}
		
		/**
		 * 监听主角需要移动到某个NPC身边 
		 * @param e
		 * 
		 */		
		private function worldMoveHandler(e:Event):void
		{
			var toSceneId:int = e.data.tosceneid
			var gid:int = e.data.gid;
			this._moveToItem(toSceneId,gid)
		}
		/**
		 * 初始化副本，主城ICON 
		 * 
		 */
		private function _initIcon():void
		{
			var cjdataof:CJDataOfFuben = (CJDataManager.o.getData("CJDataOfFuben") as CJDataOfFuben)
			var iconDataList:Dictionary = CJDataOfWorldProperty.o.getData(cjdataof.from);
			_mapBackGroundLayer.unflatten()
			_mapBackGroundLayer.blendMode = BlendMode.NORMAL;
			var level:String = CJDataManager.o.DataOfHeroList.getMainHero().level
			var openedIds:Array = CJDataOfMainSceneProperty.o.getOpenedIdByLevel(int(level));
			for(var i:String in iconDataList)
			{
				var item:CJWorldItem = new CJWorldItem(iconDataList[i].type);
				item.data = iconDataList[i];
				item.x = iconDataList[i].posx;
				item.y = iconDataList[i].posy;
				_mapBackGroundLayer.addChild(item);
				if(openedIds.indexOf(iconDataList[i].itemid)!=-1)
				{
					item.addEventListener(TouchEvent.TOUCH,_itemHandler);
				}
				_itemList.push(item);
			}
//			_mapBackGroundLayer.flatten()
		}
		
		private function _getItemPosById(type:int,id:int):CJWorldItem
		{
			for(var h:String in this._itemList)
			{
				if(this._itemList[h].id == id && this._itemList[h].type == type)
				{
					return this._itemList[h];
				}
			}
			return null;
		}
		
		/**
		 * 初始化NPC 
		 */
		private var _role:CJPlayerNpc
		private function _initNpc():void
		{
			var heroList:CJDataOfHeroList = CJDataManager.o.getData( "CJDataOfHeroList" ) as CJDataOfHeroList;
			var roleId:String = heroList.getRoleId();
			var roleConf:CJDataOfHero = heroList.getHero(roleId);
			
			var playerData:CJPlayerData = new CJPlayerData;
			playerData.isPlayer = true;
			playerData.templateId = roleConf.templateid;
			playerData.name = roleConf.heroProperty.name;
			_role= new CJPlayerNpc(playerData,Starling.juggler);
			_role.lodlevel = CJPlayerNpc.LEVEL_LOD_1|CJPlayerNpc.LEVEL_LOD_0;
			_role.hidebattleInfo();
			_role.scaleX = _role.scaleY = 0.5;
			_role.addEventListener(CJEvent.Event_PlayerPosChange,function _roleMoveHandler(e:Event):void
			{
				_camera.x = e.data.x - SApplicationConfig.o.stageWidth/2;
				_camera.y = e.data.y - SApplicationConfig.o.stageHeight/2;
			});
			
			_role.onloadResourceCompleted = function loaded(npc:CJPlayerNpc):void{
				npc.sceneidle();
				Starling.juggler.delayCall(function():void
				{
					CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_SCENE_CHANGE_COMPLETE,false,{scene:CJDataOfScene.SCENE_WORLD});
				},1);

			};
			var item:CJWorldItem = this._getItemPosById(CJWorldLayer.ITEM_TYPE_CITY,this._data.cityid);
			if(item)
			{
				_role.x = item.x+50;
				_role.y = item.y+50;
				_mapElementLayer.addChild(_role);
			}
		}
		
		/**
		 * npc 移动
		 * @param x
		 * @param y
		 * 
		 */
		private function _moveRole(item:CJWorldItem,gid:int =0):void
		{
			this._role.runTo(new Point(item.x+50,item.y+50),function():void
			{
				_back.isEnabled = true;
				if(item.type == CJWorldItem.ITEM_TYPE_CITY)
				{
					CJDataOfScene.o.fromSceneId = item.id;
					//发送切换场景请求
					_changeScene(CJDataOfScene.o.fromSceneId);
				}
				else
				{
					SApplication.moduleManager.enterModule("CJFubenModule",{fid:item.id,gid:gid});
					var evt:Event = new Event(CJEvent.EVENT_SCENE_TASKGUID_COMPLETE);
					CJEventDispatcher.o.dispatchEvent(evt);
				}
			});
		}
		
		/**
		 * ICON图点击回调 
		 * @param e
		 * 
		 */
		private function _itemHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this._mapBackGroundLayer,TouchPhase.BEGAN)
			if(touch)
			{
				e.stopImmediatePropagation();
				_back.isEnabled = false;
				var worldItem:CJWorldItem = e.currentTarget as CJWorldItem
				if ((worldItem.type == CJWorldItem.ITEM_TYPE_FUBEN ||worldItem.type == CJWorldItem.ITEM_TYPE_SUPERFB) && worldItem.status == CJWorldItem.ITEM_STATUS_UNABLE)
				{
					var reason:String
					switch(worldItem.reason)
					{
						case "task":
							reason = CJLang("FUBEN_TASK_UNABLE");
							break;
						case "level":
							var fconf:Json_fuben_config = CJDataOfFubenProperty.o.getPropertyById(worldItem.id);
							var needlevel:int = int(fconf.openvalue);
							var str:String = CJLang("FUBEN_LEVEL_UNABLE");
							reason = str.replace("{level}",needlevel);
							break;
						case "prefid":
							reason = CJLang("FUBEN_PREFID_UNABLE");
							break;
					}
					CJFlyWordsUtil(reason);
					_back.isEnabled = true;
					return;
				}
				this._moveToItem(worldItem.id);
			}
		}
		
		private function _moveToItem(id:int,gid:int=0):void
		{
			for(var i:String in _itemList)
			{
				if(_itemList[i].id == id)
				{
					this._moveRole(_itemList[i] as CJWorldItem,gid)
					break;
				}
			}
		}
		

		private var _cameraStartX:int = 0;
		private var _touchstartX:int = 0;
		
		private function touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this._mapLayer);
			if(touch == null) return;
			
			if(touch.phase == TouchPhase.BEGAN)
			{
				
				_touchstartX = touch.globalX ;
				_cameraStartX = _camera.x;
			}
			else if(touch.phase == TouchPhase.MOVED)
			{
				//拖动是反向操作,鼠标向右,地图向左移动
				_camera.x = _cameraStartX - (touch.globalX - _touchstartX);
			}
			
		}
		
		private function backHandler(e:Event):void
		{
			var roleInfo:CJDataOfRole = CJDataManager.o.DataOfRole
			var sceneId:int = roleInfo.last_map;
			_changeScene(sceneId);
		}
		
		/**
		 *  发送切换主城
		 * @param sceneId
		 * 
		 */		
		private function _changeScene(sceneId:int):void
		{		
			CJDataOfScene.o.addEventListener(DataEvent.DataLoadedFromRemote,this._onSceneLoaded)
			SocketCommand_scene.changeScene(sceneId)
		}
		
		private function _onSceneLoaded(e:Event):void
		{
			if(e.target is CJDataOfScene)
			{
				if((e.target as CJDataOfScene).canEnter)
				{
					//如果大于等于200 为副本 
					if((e.target as CJDataOfScene).sceneid >=200)
					{
						SApplication.moduleManager.enterModule("CJFubenModule",{fid:CJDataOfScene.o.sceneid});
					}
					else
					{
						enterCity(CJDataOfScene.o.sceneid);
					}
				}
				else
				{
					CJMessageBox("")
				}
			}
		}
		
		/**
		 * 进入主城 
		 * @param cityId
		 * 
		 */
		private function enterCity(cityId:int):void
		{
			if(!_hasExit)
			{
				
				var data:Object = {fromscreen:"world",cityid:cityId};
				SApplication.moduleManager.exitModule("CJWorldModule");
				CJLoaderMoudle.helper_enterMainUI(data);
			}
			_hasExit = true
		}
		
		/**
		 * 更新副本信息 
		 * @param data
		 * 
		 */		
		public function updateFuben(data:Object):void
		{
			for each(var item:CJWorldItem in _itemList)
			{
				if(item.type == CJWorldItem.ITEM_TYPE_FUBEN || item.type == CJWorldItem.ITEM_TYPE_SUPERFB)
				{
					item.fubendata = data[item.id];
				}
			}
		}
		
		public function set isSuperFb(b:Boolean):void
		{
			_isSuperFb = b	
		}
		
		override public function dispose():void
		{
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_SCENE_WORLD_MOVE,worldMoveHandler);
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_SCENE_FUBEN_OPEN,worldMoveHandler);
			CJDataOfScene.o.removeEventListener(DataEvent.DataLoadedFromRemote,this._onSceneLoaded);
			_mapBackGroundLayer.removeEventListener(TouchEvent.TOUCH,touchHandler);
			_role.dispose();
			super.dispose();
		}
	}
}