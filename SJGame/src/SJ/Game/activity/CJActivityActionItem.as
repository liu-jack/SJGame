package SJ.Game.activity
{
	import SJ.Game.data.config.CJDataOfActivityPropertyList;
	import SJ.Game.data.json.Json_activity_progress_setting;
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.display.SScale9Plane;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	
	/**
	 +------------------------------------------------------------------------------
	 * 活跃度的单个item
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-9-10 下午6:02:02  
	 +------------------------------------------------------------------------------
	 */
	public class CJActivityActionItem extends CJItemTurnPageBase
	{
		private var _bg:SScale9Plane;
		private var _duigou:ImageLoader;
		private var _currentProgress:Label;
		private var _addProgress:Label;
		private var _actionName:Label;

		private var json:Json_activity_progress_setting;
		
		public function CJActivityActionItem()
		{
			super("CJActivityActionItem");
		}
		
		override protected function initialize():void
		{
			super.initialize();
			_duigou.visible = false;
		}
		
		override protected function draw():void
		{
			super.draw();
			json = CJDataOfActivityPropertyList.o.getConfigByKey(this.data.key);
			_actionName.text = CJLang("activityaction_"+json.activityname);
			_addProgress.text = "+"+json.addscore+CJLang("activity");
			//进度
			_currentProgress.text = this._data.value +"/"+json.count+"   ";
			//对勾
			if(int(this._data.value) >= int(json.count))
			{
				_duigou.visible = true;
			}
			else
			{
				_duigou.visible = false;
			}
			//背景
			if(this.index % 2 == 0)
			{
				_bg.texturename = "huoyuedu_liebiaodi";
			}
			else
			{
				_bg.texturename = "zhuangbei_fuxuankuang";
			}
		}

		public function get bg():SScale9Plane
		{
			return _bg;
		}

		public function set bg(value:SScale9Plane):void
		{
			_bg = value;
		}

		public function get duigou():ImageLoader
		{
			return _duigou;
		}

		public function set duigou(value:ImageLoader):void
		{
			_duigou = value;
		}

		public function get currentProgress():Label
		{
			return _currentProgress;
		}

		public function set currentProgress(value:Label):void
		{
			_currentProgress = value;
		}

		public function get addProgress():Label
		{
			return _addProgress;
		}

		public function set addProgress(value:Label):void
		{
			_addProgress = value;
		}

		public function get actionName():Label
		{
			return _actionName;
		}

		public function set actionName(value:Label):void
		{
			_actionName = value;
		}
	}
}