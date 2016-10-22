package SJ.Game.task.util
{
	import SJ.Game.controls.CJItemUtil;
	import SJ.Game.controls.CJTextFormatUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.data.json.Json_task_setting;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.utils.Logger;
	
	import lib.engine.utils.functions.Assert;

	/**
	 +------------------------------------------------------------------------------
	 * 任务奖励工具类
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-28 下午6:06:39  
	 +------------------------------------------------------------------------------
	 */
	public class CJTaskRewardUtil
	{
		/**
		 * 检测是否奖励可以完全放入背包
		 */ 
		public static function canPutRewardInBag(taskConfig:Json_task_setting):Boolean
		{
			var rewardItemIdList:Array = new Array();
			
			var str:String = "";
			var addItemData:Array = new Array();
			for(var i:int = 1 ; i<= 4 ; i++)
			{
				var rewardTemplateId:int = int(taskConfig["reward"+i]);
				var num:int = int(taskConfig["num"+i]);
				if(rewardTemplateId > 0 && num > 0 )
				{
					Logger.log("add task reward ===>" , "itemTemplateId:"+rewardTemplateId + " num:"+num);
					addItemData.push({"id":rewardTemplateId , "count":num});
				}
			}
			
			if(addItemData.length != 0)
			{
				return CJItemUtil.canPutItemsInBag(CJDataManager.o.DataOfBag , addItemData);
			}
			else
			{
				return true;
			}
		}
		
		/**
		 * 构造奖励的文字
		 */		
		public static function rewardString(taskConfig:Json_task_setting):String
		{
			Assert(taskConfig != null , "任务配置为空");
			var text:String = "";
			
			var exprText:String =  CJTaskHtmlUtil.colorText(CJLang("COMMON_EXP") , "#c1910e") + CJTaskHtmlUtil.tab+CJTaskHtmlUtil.colorText("+"+taskConfig.expr , "#4AFD2C")
			var silverText:String =  CJLang("COMMON_SILVER") + CJTaskHtmlUtil.tab+CJTaskHtmlUtil.colorText("+"+taskConfig.silver , "#4AFD2C");
			
			var rewardItemIdList:Array = new Array();
			for(var j:int = 1 ; j<= 4 ; j++)
			{
				var rewardTemplateId:int = int(taskConfig["reward"+j]);
				var num:int = int(taskConfig["num"+j]);
				if(rewardTemplateId > 0 && num > 0 )
				{
					rewardItemIdList.push({"id":rewardTemplateId , "count":num});
				}
			}
			
			var itemText:String = "";
			for(var i:String in rewardItemIdList)
			{
				var itemTemplateId:int = rewardItemIdList[i]['id'];
				var setting:CJDataOfItemProperty = CJDataOfItemProperty.o;
				var template: Json_item_setting = setting.getTemplate(itemTemplateId);
				var itemColor:Object = CJTextFormatUtil.getQualityColorString(template.quality)
				var tempText:String =  CJTaskHtmlUtil.colorText(CJLang(template.itemname) , String(itemColor)) + CJTaskHtmlUtil.tab+CJTaskHtmlUtil.colorText("+" + rewardItemIdList[i]['count'] , "#4AFD2C")
				itemText += tempText+CJTaskHtmlUtil.br;
			}
			
			return exprText + CJTaskHtmlUtil.br + silverText + CJTaskHtmlUtil.br + itemText;
		}
	}
}