package SJ.Game.data
{
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.config.CJDataOfTreasurePropertyList;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.data.json.Json_treasureconfig;
	
	import engine_starling.data.SDataBase;
	
	/**
	 +------------------------------------------------------------------------------
	 * 聚灵 - 灵丸单条数据
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-5-31 下午12:33:47  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfTreasure extends SDataBase
	{
		/*灵丸id*/
		private var _treasureid:String;
		/*灵丸当前位置*/
		private var _placetype:int;
		/*灵丸配置id*/
		private var _templateId:int;
		/*灵丸的配置信息*/
		private var _treasureConfig:Json_treasureconfig;
		/*道具配置信息*/
		private var _itemConfig:Json_item_setting;
		
		public static const DATA_KEY:String = "CJDataOfTreasure";
		
		public function CJDataOfTreasure()
		{
			super(DATA_KEY);
		}
		
		public function init(data:Object):void
		{
			if(data == null)
			{
				return;
			}
			this._treasureid = data.treasureid;
			this._templateId = data.templateid;
			this._placetype = data.placetype;
			this._treasureConfig = CJDataOfTreasurePropertyList.o.getTreasureConfigByTemplateid(this._templateId);
			this._itemConfig = CJDataOfItemProperty.o.getTemplate(this._templateId);
		}

		/**
		 * 灵丸的id
		 */	
		public function get treasureid():String
		{
			return _treasureid;
		}

		/**
		 * 灵丸的id
		 */
		public function set treasureid(value:String):void
		{
			_treasureid = value;
		}

		/**
		 * 灵丸当前位置
		 */
		public function get placetype():int
		{
			return _placetype;
		}

		/**
		 * 灵丸当前位置
		 */
		public function set placetype(value:int):void
		{
			_placetype = value;
		}

		/**
		 * 灵丸配置id
		 */
		public function get templateId():int
		{
			return _templateId;
		}

		/**
		 * 灵丸配置id
		 */
		public function set templateId(value:int):void
		{
			_templateId = value;
		}

		public function get treasureConfig():Json_treasureconfig
		{
			return _treasureConfig;
		}
		
		public function get level():int
		{
			return this._itemConfig.level;
		}
	}
}