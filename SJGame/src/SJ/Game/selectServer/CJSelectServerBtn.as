package SJ.Game.selectServer
{
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.ServerList.CJServerList;
	import SJ.Game.SocketServer.SocketManager;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	
	public class CJSelectServerBtn extends Button
	{
		/** 正常 **/
		public static const SELECT_STATE_NORMAL:int = 1;
		/** 拥挤 **/
		public static const SELECT_STATE_CROWD:int = 2;
		/** 爆满 **/
		public static const SELECT_STATE_FULL:int = 3;
		/** 维护 **/
		public static const SELECT_STATE_MAINTAIN:int = 4;
		
		private static const stateRes:Object = {1:"fuwuqi_zhengchang", 2:"fuwuqi_yongji", 3:"fuwuqi_baoman", 4:"fuwuq_weihu"};
		
		/** 推荐 **/
		private var _imgRecommend:ImageLoader;
		/** 当前状态 **/
		private var _state:int;
		/** 状态 **/
		private var _imgState:ImageLoader;
		
		/** 服务器名字 **/
		private var _serverName:Label;
		
		/// 服务器id
		private var _serverid:int;

		
		public function CJSelectServerBtn(tServerName:String="", tIsRecommend:Boolean=false, tServerState:int=SELECT_STATE_MAINTAIN)
		{
			super();
			
			defaultSkin = new SImage( SApplication.assets.getTexture("fuwuqi_fuwuqianniu01") );
			downSkin = new SImage( SApplication.assets.getTexture("fuwuqi_fuwuqianniu02") );
			disabledSkin = new SImage( SApplication.assets.getTexture("fuwuqi_fuwuqianniu03") );
			
			_imgRecommend = new ImageLoader;
			_imgRecommend.x = 0;
			_imgRecommend.y = 0;
			_imgRecommend.touchable = false;
			_imgRecommend.pivotX = 14;
			_imgRecommend.pivotY = 14;
			addChild(_imgRecommend);
			
			_imgState = new ImageLoader;
			_imgState.x = 70;
			_imgState.y = 5;
			addChild(_imgState);
			
			_serverName = new Label;
			_serverName.textRendererProperties.textFormat = ConstTextFormat.textformatblack;
			_serverName.x = 5;
			_serverName.y = 5;
			addChild(_serverName);
			
			// 更新状态信息等
			serverName = tServerName;
			isRecommend = tIsRecommend;
			serverState = tServerState;
		}
		
		/** 是否推荐 **/
		public function set isRecommend(b:Boolean):void
		{
			if (b)
				_imgRecommend.source = SApplication.assets.getTexture("fuwuqi_jian");
			else
				_imgRecommend.source = null;
		}
		/** @private **/
		public function get isRecommend():Boolean
		{
			if (_imgRecommend.source)
				return true;
			
			return false;
		}
		/** 服务器状态 **/
		public function set serverState(value:int):void
		{
			if ( value<SELECT_STATE_NORMAL || SELECT_STATE_MAINTAIN<value )
				return;
			
			_state = value;
			_imgState.source = SApplication.assets.getTexture(stateRes[_state]);
		}
		/** 服务器状态 **/
		public function get serverState():int
		{
			return _state;
		}
		
		/** 服务器名称 **/
		public function set serverName(str:String):void
		{
			_serverName.text = str;
		}
		/** 服务器名称 **/
		public function get serverName():String
		{
			return _serverName.text;
		}
		
		/** 服务器id **/
		public function get serverid():int
		{
			return _serverid;
		}
		
		/**
		 * @private
		 */
		public function set serverid(value:int):void
		{
			if (_serverid == value)
				return;
			
			_serverid = value;
			serverState = SELECT_STATE_MAINTAIN;
			
			var serverip:String = CJServerList.getServerJS(_serverid).serverip;
			var serverport:int = CJServerList.getServerJS(_serverid).serverport;
			SocketManager.callonce(serverip, serverport, "account.getserverstatus", __callback, _serverid);
			
			// 回调
			function __callback(obj:Object):void
			{
				var retCode:int = obj.code;
				if (retCode != 0) // 错误信息不为0，该服务器维护
					return;
				var serverid:int = obj.rtnfunctionParams;
				var isOpen:Boolean = obj.msg.retparams.isOpen;
				var onlineMaxUserCount:int = obj.msg.retparams.onlineMaxUserCount;
				var onlineUserCount:int = obj.msg.retparams.onlineUserCount;
				// 改变状态
				serverState = SELECT_STATE_NORMAL;
			}
		}
		
		/** 不进行发包的设置severid **/
		public function setServerID(value:int):void
		{
			_serverid = value;
		}
	}
}