package lib.engine.ui.data
{
	import lib.engine.iface.IPackage;
	import lib.engine.utils.CPackUtils; 
	 
	public class ImageTileInfo implements IPackage
	{
		public function ImageTileInfo()
		{
		}
		public var name:String;
		public var x:int;
		public var y:int;
		public var width:int;
		public var height:int;
		
		public function Serialization():String
		{
			
			return JSON.stringify(Pack());;
		}
		
		public function UnSerialization(object:String):void
		{
			var obj:Object = JSON.parse(object);
			UnPack(obj);
			
		}
		
		public function Pack():Object
		{
			var obj:Object = new Object();
			CPackUtils.PacktoObject(this,obj);
			return obj;
		}
		
		public function UnPack(obj:Object):void
		{
			CPackUtils.UnPackettoObject(obj,this);
			
		}
		
	}
}