package SJ.Game.NPCDialog
{
	/**
	 * 
	 @author	Weichao 每一个功能点对应的对象
	 2013-5-10
	 * 
	 */
	
	public class CJNPCDialogActionObject extends Object
	{
		private var _actionName:String;//用于显示的文字,注意自己排版
		private var _specialIconType:int;//用于处理前面的符号，感叹号，问号之类的
		private var _recallParams:Object = null;//通知会加上这个信息，用来区别是哪一个功能点被点击
		/*任务等级限制*/
		private var _levelLimit:String = "";
		
		public function CJNPCDialogActionObject()
		{
			super();
		}

		public function get actionName():String
		{
			return _actionName;
		}

		public function set actionName(value:String):void
		{
			_actionName = value;
		}

		public function get specialIconType():int
		{
			return _specialIconType;
		}

		public function set specialIconType(value:int):void
		{
			_specialIconType = value;
		}

		public function get recallParams():Object
		{
			return _recallParams;
		}

		public function set recallParams(value:Object):void
		{
			_recallParams = value;
		}

		public function get levelLimit():String
		{
			return _levelLimit;
		}

		public function set levelLimit(value:String):void
		{
			_levelLimit = value;
		}


	}
}