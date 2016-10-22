package engine_starling.data
{
	import engine_starling.utils.SObjectUtils;

	public class SDataBaseJson
	{
		protected var _propertys:Array = new Array();
		public function SDataBaseJson()
		{
		}
		
		public function loadFromJsonObject(JsonObject:Object):SDataBaseJson
		{
			if(_propertys.length == 0)
			{
				SObjectUtils.JsonObject2Object(JsonObject,this);
			}
			else
			{
				SObjectUtils.JsonObject2ObjectWithPropertys(JsonObject,this,_propertys);
			}
			
			return this;
		}
	}
}