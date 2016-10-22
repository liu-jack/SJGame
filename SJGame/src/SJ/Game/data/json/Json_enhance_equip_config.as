/**
* gen by tools!
* time:Thu Oct 10 18:11:00 GMT+0800 2013
* from:装备强化等级配置.csv
* to:enhance_equip_config.json
**/
package SJ.Game.data.json
{
	import engine_starling.data.SDataBaseJson;
	public class Json_enhance_equip_config extends SDataBaseJson
	{
		public function Json_enhance_equip_config()
		{
		}
		private var _id:* = null;
		public function get id():*{return _id;}
		public function set id(value:*):void{_id=value;}

		private var _position:* = null;
		public function get position():*{return _position;}
		public function set position(value:*):void{_position=value;}

		private var _level:* = null;
		public function get level():*{return _level;}
		public function set level(value:*):void{_level=value;}

		private var _addproprate:* = null;
		public function get addproprate():*{return _addproprate;}
		public function set addproprate(value:*):void{_addproprate=value;}

		private var _costtype:* = null;
		public function get costtype():*{return _costtype;}
		public function set costtype(value:*):void{_costtype=value;}

		private var _costprice:* = null;
		public function get costprice():*{return _costprice;}
		public function set costprice(value:*):void{_costprice=value;}

		private var _baserate:* = null;
		public function get baserate():*{return _baserate;}
		public function set baserate(value:*):void{_baserate=value;}

		private var _addcosttype:* = null;
		public function get addcosttype():*{return _addcosttype;}
		public function set addcosttype(value:*):void{_addcosttype=value;}

		private var _addprice:* = null;
		public function get addprice():*{return _addprice;}
		public function set addprice(value:*):void{_addprice=value;}

		private var _trans:* = null;
		public function get trans():*{return _trans;}
		public function set trans(value:*):void{_trans=value;}

	}
}
