package GameConsole.core
{
	public interface IConsole
	{
		function get isOpened():Boolean;
		function set isOpened(value:Boolean):void;
		
		
		/**
		 * 热键ID 
		 * @return 
		 * 
		 */
		function hotkeyId():uint;
	}
}