package SJ.Game.worldmap
{
	import SJ.Game.SocketServer.SocketCommand_scene;
	import SJ.Game.data.CJDataOfScene;
	import SJ.Game.loader.CJLoaderMoudle;
	
	import engine_starling.Events.DataEvent;
	import engine_starling.SApplication;
	import engine_starling.display.SNode;
	
	import starling.events.Event;
	
	public class CJWorldMapAction extends SNode
	{
		private var _succFunc:Function;
		public function CJWorldMapAction()
		{
			super();
		}
		
		/**
		 *  发送切换主城
		 * @param sceneId
		 * 
		 */		
		public function changeScene(sceneId:int,succFunc:Function):void
		{		
			_succFunc = succFunc;
			CJDataOfScene.o.addEventListener(DataEvent.DataLoadedFromRemote,this._onSceneLoaded)
			SocketCommand_scene.changeScene(sceneId)
		}
		
		private function _onSceneLoaded(e:Event):void
		{
			if(e.target is CJDataOfScene)
			{
				if((e.target as CJDataOfScene).canEnter)
				{
					if(this._succFunc)
					{
						_succFunc();
					}
					//如果大于等于200 为副本 
					if((e.target as CJDataOfScene).sceneid >=200)
					{
						
					}
					else
					{
						enterCity(CJDataOfScene.o.sceneid);
					}
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
			var data:Object = {fromscreen:"world",cityid:cityId};
			SApplication.moduleManager.exitModule("CJMainUiModule");
			CJLoaderMoudle.helper_enterMainUI(data);
		}
		
		override public function dispose():void
		{
			CJDataOfScene.o.removeEventListener(DataEvent.DataLoadedFromRemote,this._onSceneLoaded);
		}
		
	}
}