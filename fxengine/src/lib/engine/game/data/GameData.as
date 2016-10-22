package lib.engine.game.data
{
	import lib.engine.iface.IPackage;
	import lib.engine.utils.CPackUtils;

	/**
	 * 游戏数据基类 
	 * @author caihua
	 * 
	 */
	public class GameData implements IPackage
	{
		public function GameData()
		{
		}
		
		public function Pack():Object
		{
			var Obj:Object = new Object();
			CPackUtils.PacktoObject(this,Obj,false);
			return Obj;
		}
		
		public function UnPack(obj:Object):void
		{
			CPackUtils.UnPackettoObject(obj,this,false);
			
		}
		
	}
}