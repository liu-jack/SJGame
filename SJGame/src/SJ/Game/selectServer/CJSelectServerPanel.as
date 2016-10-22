package SJ.Game.selectServer
{
	import SJ.Common.Constants.ConstGlobal;
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.ServerList.CJServerList;
	import SJ.Game.data.json.Json_serverlist;
	import SJ.Game.formation.CJTurnPage;
	
	import engine_starling.display.SLayer;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.SStringUtils;
	
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;

	public class CJSelectServerPanel extends SLayer
	{
		/** 武将头像面板 **/
		private var _turnPage:CJTurnPage;
		/** 间隙 **/
		private const CONST_ITEM_GAP:Number = 5;
		
		public function CJSelectServerPanel()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			var serverlist:Object = AssetManagerUtil.o.getObject(ConstResource.sResJsonServerList);
			var serjson:Json_serverlist = new Json_serverlist();
			
//			for each(var serverinfo:Object in serverlist)
//			{
//				serjson.loadFromJsonObject(serverinfo);
//				SocketManager.callonce(serjson.serverip, serjson.serverport, "account.getserverstatus", __callback, serjson.id);
//			}
//			
//			// 回调
//			function __callback(obj:Object):void
//			{
//				var retCode:int = obj.code;
//				if (retCode != 0) // 错误信息不为0，该服务器维护
//					return;
//				var serverid:int = obj.rtnfunctionParams;
//				var isOpen:Boolean = obj.msg.retparams.isOpen;
//				var onlineMaxUserCount:int = obj.msg.retparams.onlineMaxUserCount;
//				var onlineUserCount:int = obj.msg.retparams.onlineUserCount;
//				
//				var arr:Array = _turnPage.getAllItemDatas();
//				for(var i:int=0; i<arr.length; i++)
//				{
//					if (int(arr[i].left.id) == serverid)
//					{
//						arr[i].left.state = CJSelectServerBtn.SELECT_STATE_NORMAL;
//						_turnPage.updateItemAt(int(arr[i].left.index));
//						break;
//					}
//					else if (int(arr[i].right.id) == serverid)
//					{
//						arr[i].right.state = CJSelectServerBtn.SELECT_STATE_NORMAL;
//						_turnPage.updateItemAt(int(arr[i].right.index));
//						break;
//					}
//				}
//			}
			
			_doInit();
		}
		
		private function _doInit():void
		{
			_turnPage = new CJTurnPage(3);
			_turnPage.setRect(width , height);
			_turnPage.x = 0;
			_turnPage.y = 1;
			_turnPage.type = CJTurnPage.SCROLL_V;
			
			var listData:Array = _getDataArr();
			//设置渲染属性
			var groceryList:ListCollection = new ListCollection(listData);
			// 添加数据监听
			var listLayout:VerticalLayout = new VerticalLayout();
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			listLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
			listLayout.gap = CONST_ITEM_GAP;
			_turnPage.layout = listLayout;
			_turnPage.dataProvider = groceryList;
			_turnPage.itemRendererFactory = function _getRenderFatory():IListItemRenderer
			{
				const render:CJSelectServerItem = new CJSelectServerItem();
				render.owner = _turnPage;
				return render;
			};
			addChild(_turnPage);
		}
		
		
		// 获取数据
		private function _getDataArr():Array
		{
			var listData:Array = new Array();
			
			var serverlist:Array = CJServerList.getServerList();
			var data:Object;
			for each(var serjson:Json_serverlist in serverlist)
			{
				
//				if ( !SStringUtils.isEmpty(serjson.channel) && // 没有渠道号字段时所有服务器均显示
//					int(ConstGlobal.CHANNEL) != int(serjson.channel)) //渠道号不同，不进行显示
//						continue;
				
				data = {id:serjson.id,
						recommend:int(serjson.recommend),
						servername:serjson.servername,
						servermaxuser:serjson.servermaxuser,
						state:CJSelectServerBtn.SELECT_STATE_MAINTAIN,
						weight: int(serjson.id),
						isclose:int(serjson.isclose)};
				//服务已经关闭 则不显示
				if(parseInt(serjson.isclose) == 1)
				{
					continue;
				}
				if ( int(serjson.recommend) == 1 )
					data.weight += 100000000;
				listData.push(data);
			}
			listData.sortOn("weight", Array.NUMERIC|Array.DESCENDING);
			
			var list:Array = new Array;
			var ndata:Object;
			var index:int = 0;
			for(var i:int=0; i<listData.length;)
			{
				var left:Object = null;
				var right:Object = null;
				left = listData[i++];
				left.index = index;
				if (i<listData.length)
				{
					right = listData[i++];
					right.index = index;
				}
				ndata = { left:left, right:right };
				index++;
				list.push(ndata);
			}
				
			return list;
		}
	}
}