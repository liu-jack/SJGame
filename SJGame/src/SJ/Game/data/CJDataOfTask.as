package SJ.Game.data
{
	import SJ.Common.Constants.ConstTask;
	import SJ.Game.data.config.CJDataOfTaskPropertyList;
	import SJ.Game.data.json.Json_task_setting;
	import SJ.Game.task.CJTaskType;
	
	import engine_starling.data.SDataBase;

	/**
	 +------------------------------------------------------------------------------
	 * 任务单个数据dao类 ，更新数据，派发事件
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-4-24 下午7:20:42  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfTask extends SDataBase
	{
		/*任务id*/
		private var _taskId:int;
		/*任务状态*/
		private var _status:int;
		/*任务开启时间*/
		private var _ctime:int;
		/*任务进度1*/
		private var _progress1:int;
		/*任务进度2*/
		private var _progress2:int;
		/*任务进度3*/
		private var _progress3:int;
		/*任务配置数据*/
		private var _taskConfig:Json_task_setting;
		public const DATA_KEY:String = "CJDataOfTask";
		
		public function CJDataOfTask()
		{
			super("CJDataOfTask");
		}
		
		public function init(data:Object):void
		{
			if(data == null)
			{
				return;
			}
			this._taskId = data.taskid;
			this._taskConfig = CJDataOfTaskPropertyList.o.getTaskConfigById(this._taskId);
			this._ctime = data.ctime;
			this._resetData(data);
		}
		
		/**
		 * 每次数据变化调用restData ,派发DataEvent.DataChange事件
		 * obj = {"status":*** , "progress":***}
		 */		
		private function _resetData(obj:Object):void
		{
			if(obj.hasOwnProperty("status") && obj.status != null)
			{
				this._status = obj.status;
			}
			if(obj.hasOwnProperty("progress1") && obj.progress1 != null)
			{
				this._progress1 = obj.progress1;
			}
			if(obj.hasOwnProperty("progress2") && obj.progress2 != null)
			{
				this._progress2 = obj.progress2;
			}
			if(obj.hasOwnProperty("progress3") && obj.progress3 != null)
			{
				this._progress3 = obj.progress3;
			}
			this.setData(DATA_KEY , this);
		}
		
		/**
		 * 接受任务
		 */		
		public function accept():void
		{
			if(this._status == ConstTask.TASK_CAN_ACCEPT)
			{
				this._status = ConstTask.TASK_ACCEPTED;
			}
			this.setData(DATA_KEY , this);
		}
		
		/**
		 * 完成任务
		 */		
		public function complete():void
		{
			if(this._status == ConstTask.TASK_ACCEPTED)
			{
				this._status = ConstTask.TASK_COMPLETE;
			}
			this.setData(DATA_KEY , this);
		}
		
		/**
		 * 领取奖励
		 */		
		public function reward():void
		{
			if(this._status == ConstTask.TASK_COMPLETE)
			{
				this._status = ConstTask.TASK_REWARDED;
			}
			this.setData(DATA_KEY , this);
		}
		
		/**
		 * 放弃任务
		 */		
		public function abort():void
		{
			if(this._status >= ConstTask.TASK_ACCEPTED && this._status <= ConstTask.TASK_COMPLETE)
			{
				this._status = ConstTask.TASK_ABORT;
			}
			this.setData(DATA_KEY , this);
		}
		
		/**
		 * 是否是主线任务
		 */		
		public function isMainTask():Boolean
		{
			return int(this._taskConfig.tasktype) == CJTaskType.TASK_MAIN ; 
		}
		
		/**
		 *  任务是否已经接受
		 */		
		public function isTaskAccepted():Boolean
		{
			return this._status == ConstTask.TASK_ACCEPTED;
		}
		
		/**
		 * 任务是否已经完成
		 */		
		public function isTaskComplete():Boolean
		{
			return this._status == ConstTask.TASK_COMPLETE;
		}
		
		/**
		 * 任务是否已经领取奖励
		 */	
		public function isTaskRewarded():Boolean
		{
			return this._status == ConstTask.TASK_REWARDED;
		}
		
		/**
		 * 任务是否已经放弃
		 */	
		public function isTaskAbort():Boolean
		{
			return this._status == ConstTask.TASK_ABORT;
		}
		
		/**
		 * 获得任务接受需要的等级
		 */ 
		public function get acceptLevel():int
		{
			for(var i:int = 1 ; i<= ConstTask.CONDTION_NUM ; i++)
			{
				var conditionKey:* = this._taskConfig["conditionkey"+i];
				if(conditionKey != undefined)
				{
					if(int(conditionKey) == ConstTask.TASK_CONDITION_LEVEL)
					{
						return this._taskConfig["conditionvalue"+i];
					}
				}
			}
			return 0;
		}
		
		/**
		 * 任务的id
		 */	
		public function get taskId():int
		{
			return _taskId;
		}

		/**
		 * 任务的状态
		 */	
		public function get status():int
		{
			return _status;
		}

		/**
		 * 任务的激活时间
		 */	
		public function get ctime():int
		{
			return _ctime;
		}

		/**
		 * 获得该任务的配置
		 */	
		public function get taskConfig():Json_task_setting
		{
			return _taskConfig;
		}

		public function get progress1():int
		{
			return _progress1;
		}

		public function get progress2():int
		{
			return _progress2;
		}

		public function get progress3():int
		{
			return _progress3;
		}

		public function set status(value:int):void
		{
			_status = value;
			this.setData(DATA_KEY , this);
		}

		public function set ctime(value:int):void
		{
			_ctime = value;
			this.setData(DATA_KEY , this);
		}

		public function set progress1(value:int):void
		{
			_progress1 = value;
			this.setData(DATA_KEY , this);
		}

		public function set progress2(value:int):void
		{
			_progress2 = value;
			this.setData(DATA_KEY , this);
		}

		public function set progress3(value:int):void
		{
			_progress3 = value;
			this.setData(DATA_KEY , this);
		}
	}
}