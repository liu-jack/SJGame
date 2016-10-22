package SJ.Game.NPCDialog
{
	/**
	 @author	Weichao 显示NPC对话框需要传进去的参数
	 2013-5-10
	 */
	
	public class CJNPCDialogContentObject extends Object
	{
		private var _portraitResourceName:String;//半身像资源名
		private var _content:String//对话内容
		private var _npcName:String;//NPC名字
		private var _rewardExp:int;//奖励的经验
		private var _rewardYinliang:int;//奖励的银两
		private var _rewardItemIdArray:Array;//奖励的物品的ID
		private var _NPCActionObjectArray:Array;//所有功能点对象
		private var _buttonText:String; // 按钮的文字
		
		public function CJNPCDialogContentObject()
		{
			//TODO: implement function
			super();
		}

		public function get portraitResourceName():String
		{
			return _portraitResourceName;
		}

		public function set portraitResourceName(value:String):void
		{
			_portraitResourceName = value;
		}

		public function get content():String
		{
			return _content;
		}

		public function set content(value:String):void
		{
			_content = value;
		}

		public function get npcName():String
		{
			return _npcName;
		}

		public function set npcName(value:String):void
		{
			_npcName = value;
		}

		public function get rewardExp():int
		{
			return _rewardExp;
		}

		public function set rewardExp(value:int):void
		{
			_rewardExp = value;
		}

		public function get rewardYinliang():int
		{
			return _rewardYinliang;
		}

		public function set rewardYinliang(value:int):void
		{
			_rewardYinliang = value;
		}

		public function get rewardItemIdArray():Array
		{
			return _rewardItemIdArray;
		}

		public function set rewardItemIdArray(value:Array):void
		{
			_rewardItemIdArray = value;
		}

		public function get NPCActionObjectArray():Array
		{
			return _NPCActionObjectArray;
		}

		public function set NPCActionObjectArray(value:Array):void
		{
			_NPCActionObjectArray = value;
		}

		public function get buttonText():String
		{
			return _buttonText;
		}

		public function set buttonText(value:String):void
		{
			_buttonText = value;
		}
	}
}