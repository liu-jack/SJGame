package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_item_setting;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;
	
	import lib.engine.utils.CObjectUtils;

	/**
	 * 道具模板数据
	 * @author sangxu
	 * 
	 */	
	public class CJDataOfItemProperty extends SDataBase
	{
		
		public function CJDataOfItemProperty()
		{
			super("CJDataOfItemProperty");
			
		}
		
		private static var _o:CJDataOfItemProperty;
		public static function get o():CJDataOfItemProperty
		{
			if(_o == null)
			{
				_o = new CJDataOfItemProperty();
				_o._initData();
			}
			return _o;
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResItemSetting) as Array;
			if(obj == null)
			{
				return;
			}
			var length:int = obj.length;
			for(var i:int=0 ; i < length ; i++)
			{
				var data:Json_item_setting = new Json_item_setting();
				data.loadFromJsonObject(obj[i]);
				this._setTemplate(data)
			}
		}
		
		/**
		 * 获取全部道具模板
		 * @return 
		 * 
		 */		
		public function getAllTemplates():Dictionary
		{
			return CObjectUtils.clone(this._dataContains);
		}
		
		/**
		 * 获取道具模板
		 */
		public function getTemplate(templateId : int) : Json_item_setting
		{
			var data:Json_item_setting = this.getData(String(templateId));
			if (null == data)
			{
				return null;
			}
//			return CObjectUtils.clone(data);
			return data;
		}
		
		/**
		 * 设置道具模板
		 */
		private function _setTemplate(template : Json_item_setting) : void
		{
			this.setData(String(template.id), template);
		}
	}
}