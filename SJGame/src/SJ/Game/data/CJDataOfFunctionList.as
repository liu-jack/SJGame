package SJ.Game.data
{
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_funcpoint;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.config.CJDataOfFuncPropertyList;
	import SJ.Game.data.json.Json_function_open_setting;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * 开启功能列表数据 functionid => CJDataOfFunctionPoint
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-25 上午11:34:48  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfFunctionList extends SDataBaseRemoteData
	{
		public static const DATA_KEY:String = "function_list_data";
		/*是否正在指引中*/
		private var _isIndicating:int = 0;
		private var _currentIndicatingModule:String = "";
		/*开启列表字典*/
		private var _functionListDic:Dictionary = new Dictionary();
		/*需要返回城镇才开启的功能id*/
		private var _needOpenFunctionAfterReturnToTown:int = -1;
		
		public function CJDataOfFunctionList()
		{
			super("CJDataOfFunctionList");
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData , this._onDataLoaded);
		}
		
		private function _onDataLoaded(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.retcode == 1)
			{
				var retData:Object = message.retparams;
				if(message.getCommand() == ConstNetCommand.CS_FUNCITON_GETALL)
				{
					this._initData(retData);
					this._onloadFromRemoteComplete();
				}
				//新开启
				else if(message.getCommand() == ConstNetCommand.CS_FUNCITON_OPEN)
				{
					if(retData)
					{
						_addNewOpenFunction(int(retData));
					}
				}
				//完成开启
				else if(message.getCommand() == ConstNetCommand.CS_FUNCITON_INDICATE_COMPLETE)
				{
					if(retData)
					{
						_completeFunction(int(retData));
					}
				}
			}
		}
		
		/**
		 * 完成开启
		 */		
		private function _completeFunction(functionid:int):void
		{
			if(!this._functionListDic || !this._functionListDic.hasOwnProperty(functionid))
			{
				return;
			}
			var funcDao:CJDataOfFunctionPoint = this._functionListDic[int(functionid)];
			funcDao.completed = 1;
		}
		
		/**
		 * 新增一个开启的功能点
		 */		
		private function _addNewOpenFunction(functionid:int):void
		{
			var funcDao:CJDataOfFunctionPoint = new CJDataOfFunctionPoint();
			var data:Object = {"functionid":functionid , "userid":CJDataManager.o.DataOfAccounts.userID , "completed":0};
			funcDao.initData(data);
			this._functionListDic[int(functionid)] = funcDao;
			this.setData(DATA_KEY , this._functionListDic);
		}
		
		private function _initData(obj:Object):void
		{
			for(var functionid:String in obj)
			{
				var funcDao:CJDataOfFunctionPoint = new CJDataOfFunctionPoint();
				funcDao.initData(obj[functionid]);
				this._functionListDic[int(functionid)] = funcDao;
			}
			this.setData(DATA_KEY , this._functionListDic);
		}
		
		/**
		 * 获取所有开启完成了的功能点列表
		 * @see type: ConstFunctionList
		 */		
		public function getAllCompleteFunctionIdList(type:int):Array
		{
			var temp:Array = new Array();
			for(var functionid:String in this._functionListDic)
			{
				var funcDao:CJDataOfFunctionPoint = _functionListDic[functionid];
				
				if(funcDao && funcDao.completed == 1 && funcDao.config != null && int(funcDao.config.type )== type)
				{
					temp.push(functionid);
				}
			}
			return temp;
		}
		
		
		/**
		 * 获取所有开启的功能点列表
		 * @type: 类型 @see ConstFunctionList
		 */		
		public function getAllFunctionIdList(type:int):Array
		{
			var temp:Array = new Array();
			for(var functionid:String in this._functionListDic)
			{
				var funcDao:CJDataOfFunctionPoint = _functionListDic[functionid];
				if(int(funcDao.config.type )== type)
				{
					temp.push(functionid);
				}
			}
			return temp;
		}
		
		/**
		 * 取得特定等级下，下一个需要开启的功能点配置id(最小)
		 */		
		public function getNextUnOpenFunctionId(level:int):int
		{
			var functionIdList:Array = CJDataOfFuncPropertyList.o.getFunctionIdListByLevel(level);
//			不包含，或者包含没完成
			for(var i:String in functionIdList)
			{
				//已开启的列表中有它，但是没有完成
				if(this._functionListDic.hasOwnProperty(functionIdList[i]))
				{
					var funcDao:CJDataOfFunctionPoint = this._functionListDic[functionIdList[i]] as CJDataOfFunctionPoint;
					if(funcDao.completed == 1)
					{
						continue;
					}
					return functionIdList[i];
				}
				//干脆没有开启呢还
				else
				{
					return functionIdList[i];
				}
			}
			return -1;
		}
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			super._onloadFromRemote(params);
			SocketCommand_funcpoint.getAllFunctionList();
		}
		
		override public function clearAll():void
		{
			_functionListDic = new Dictionary();
			_isIndicating = 0 ;
			currentIndicatingModule = "" ;
			needOpenFunctionAfterReturnToTown = -1;
		}

		public function get isIndicating():int
		{
			return _isIndicating;
		}

		public function set isIndicating(value:int):void
		{
			_isIndicating = value;
		}

		public function get currentIndicatingModule():String
		{
			return _currentIndicatingModule;
		}

		public function set currentIndicatingModule(value:String):void
		{
			_currentIndicatingModule = value;
		}
		
		/**
		 * 判断模块是否开启
		 * @param modulename
		 * 
		 */
		public function isFunctionOpen(modulename:String):Boolean
		{
			var json:Json_function_open_setting = CJDataOfFuncPropertyList.o.getPropertyByModulename(modulename);
			if (null == json)
				return false;
			
			// 只配置"0" "1"
			if (json.needopen == "0")
				return true;
			
			for each ( var funcDao:CJDataOfFunctionPoint in _functionListDic)
			{
				if (funcDao.config && String(funcDao.config.modulename).indexOf(modulename) != -1)
					return true;
			}
			return false;
		}

		public function get needOpenFunctionAfterReturnToTown():int
		{
			return _needOpenFunctionAfterReturnToTown;
		}

		public function set needOpenFunctionAfterReturnToTown(value:int):void
		{
			_needOpenFunctionAfterReturnToTown = value;
		}

	}
}