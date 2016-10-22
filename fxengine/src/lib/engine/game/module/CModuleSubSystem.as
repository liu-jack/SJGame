package lib.engine.game.module
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import engine_starling.utils.Logger;
	import engine_starling.utils.SObjectUtils;
	import engine_starling.utils.SStringUtils;
	
	import luaAlchemy.LuaAlchemy;
	

	/**
	 * 子系统基类 
	 * @author caihua
	 * 
	 */
	public class CModuleSubSystem extends CModuleLuaWrapper
	{
		
		public function CModuleSubSystem(name:String = "")
		{
			super();
			if(SStringUtils.isEmpty(name))
			{
				var shortClassName:String = SObjectUtils.getClassName(this);	
				this.name = shortClassName;
			}
			else
			{
				this.name = name;
			}
		}
		
	}
}