package SJ.Game.data
{
	import SJ.Common.Constants.ConstItem;
	
	import engine_starling.data.SDataBase;
	
	/**
	 * 武将装备位洗练数据
	 * 数据格式{position, CJDataOfRecastPosition}
	 * @author zhengzheng
	 * 
	 */
	public class CJDataOfRecastHero extends SDataBase
	{
		public function CJDataOfRecastHero()
		{
			super("CJDataOfRecastHero");
		}
		
		/**
		 * 生成初始化数据
		 * @param heroid
		 * @param userid
		 * @return 
		 * 
		 */		
		public static function getNewCJDataOfRecastHero(heroid:String, userid:String):CJDataOfRecastHero
		{
			var data:CJDataOfRecastHero = new CJDataOfRecastHero();
			var dataPos:CJDataOfRecastPosition;
			for each(var posType:int in ConstItem.SCONST_ITEM_POSITION_ALL)
			{
				dataPos = CJDataOfRecastPosition.getNewCJDataOfRecastPosition(heroid, userid, posType);
				data.setRecastPosition(posType, dataPos);
			}
			return data;
		}
		
		public function setRecastPosition(position:int, data:CJDataOfRecastPosition):void
		{
			this.setData(String(position), data);
		}
		
		/**
		 * 获取武将装备位洗练信息
		 * @param heroId	武将id
		 * @return 若无洗练信息返回null
		 * 
		 */
		public function getRecastPosition(position:int) : CJDataOfRecastPosition
		{
			return this.getData(String(position));
		}
		
		
	}
}