package SJ.Game.fuben
{
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfActFb;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.config.CJDataOfActiveFbProperty;
	import SJ.Game.data.config.CJDataOfGuankaProperty;
	import SJ.Game.data.json.Json_activefuben;
	import SJ.Game.data.json.Json_fuben_guanka_config;
	import SJ.Game.data.json.Json_vip_function_setting;
	import SJ.Game.data.config.CJDataOfVipFuncSetting;
	
	import feathers.controls.renderers.IListItemRenderer;

	public class CJActGuankaLayer extends CJActiveFbLayer
	{
		private var _aid:int
		private var _data:Object
		public function CJActGuankaLayer()
		{
			super();
		}
		
		override public function set data(data:Object):void
		{
			_data = data;
			_aid = data['fid'];
			var actConfig:Json_activefuben = CJDataOfActiveFbProperty.o.getPropertyById(_aid)
			var listData:Array = new Array
				
			var role:CJDataOfRole = CJDataManager.o.getData("CJDataOfRole") as CJDataOfRole
			var vip:int = role.vipLevel;
			var vipConf:Json_vip_function_setting = CJDataOfVipFuncSetting.o.getData(String(vip));
			
			for(var i:int = 1;i<=12;i++)
			{
				var key:String = "gids"+String(i)
				if(actConfig.hasOwnProperty(key) && actConfig[key])
				{
					var guankaProperty:Json_fuben_guanka_config = CJDataOfGuankaProperty.o.getPropertyById(actConfig[key]);
					var totalNum:int = guankaProperty.totalnum;
					totalNum = totalNum + int(vipConf.actfb_extracount);
					var useritem:Object = {}
					var actdata:CJDataOfActFb = CJDataManager.o.getData("CJDataOfActFb") as CJDataOfActFb;
					var itemdata:Object = actdata.getfbdetail(_aid,actConfig[key]);
					var num:int = 0;
					if(itemdata)
					{
						num = itemdata['num'];
					}
					num = Math.max(0,totalNum - num);
					useritem['fid'] = _aid
					useritem['gvit'] = guankaProperty.needvit;
					useritem['vit'] = role.vit
					useritem['fzid'] = guankaProperty.zid1
					useritem['gid'] = actConfig[key];
					useritem['num'] = num;
					useritem['name'] = guankaProperty.name;
					useritem['desc'] = guankaProperty.desc;
					listData.push(useritem)
				}
			}
			setDataToList(listData)
		}
		
		override protected function listItemRendererFactory():IListItemRenderer
		{
			const renderer:CJActGuankaItem = new CJActGuankaItem();
			return renderer;
		}
		override protected function exit():void
		{
			this.removeFromParent(true)
		}
	}
}