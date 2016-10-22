package engine_starling.display
{
	public class SAnimateFrameScriptContains implements ISAnimateFrameScript
	{
		public function SAnimateFrameScriptContains()
		{
			_init();
		}
		
		private function _init():void
		{
			_scripts = new Vector.<ISAnimateFrameScript>();
		}
		/**
		 * 所有脚本 
		 */
		private var _scripts:Vector.<ISAnimateFrameScript>;
		
		public function execute(owner:SAnimate):void
		{
			var length:int = _scripts.length;
			for(var i:int = 0;i<length;i++)
			{
				_scripts[i].execute(owner);
			}
			
		}
		
		public final function addScript(script:ISAnimateFrameScript):void
		{
			_scripts.push(script);
		}
		
		
		public static function genScriptContains(...Sprites):SAnimateFrameScriptContains
		{
			var ins:SAnimateFrameScriptContains = new SAnimateFrameScriptContains();
			var length:int = Sprites.length;
			var script:ISAnimateFrameScript;
			for(var i:int = 0;i<length;i++)
			{
				script = Sprites[i];
				ins.addScript(script);
			}
			
			return ins;
		}
		

		
		
	}
}