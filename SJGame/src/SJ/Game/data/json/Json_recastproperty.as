/**
* gen by tools!
* time:Thu Oct 10 18:10:59 GMT+0800 2013
* from:洗炼属性种类表.csv
* to:recastproperty.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_recastproperty extends SDataBaseJson
	{
		public function Json_recastproperty()
		{
		}
		private var _propertyid:* = null;
		public function get propertyid():*{return _propertyid;}
		public function set propertyid(value:*):void{_propertyid=value;}

		private var _description:* = null;
		public function get description():*{return _description;}
		public function set description(value:*):void{_description=value;}

		private var _proportion:* = null;
		public function get proportion():*{return _proportion;}
		public function set proportion(value:*):void{_proportion=value;}

	}
}
