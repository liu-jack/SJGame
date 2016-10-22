package SJ.Game.data
{
	import SJ.Common.Constants.ConstItem;
	
	import engine_starling.data.SDataBase;
	
	/**
	 * 武将宝石镶嵌数据
	 * 数据格式{position, CJDataOfInlayPosition}
	 * @author sangxu
	 * 
	 */
	public class CJDataOfInlayHero extends SDataBase
	{
		public function CJDataOfInlayHero()
		{
			super("CJDataOfInlayHero");
		}
		
		/**
		 * 生成初始化数据
		 * @param heroid
		 * @param userid
		 * @return 
		 * 
		 */		
		public static function getNewCJDataOfInlayHero(heroid:String, userid:String):CJDataOfInlayHero
		{
			var data:CJDataOfInlayHero = new CJDataOfInlayHero();
			var dataPos:CJDataOfInlayPosition;
			for each(var posType:int in ConstItem.SCONST_ITEM_POSITION_ALL)
			{
				dataPos = CJDataOfInlayPosition.getNewCJDataOfInlayPosition(heroid, userid, posType);
				data.setInlayPosition(posType, dataPos);
			}
			return data;
		}
		
		public function setInlayPosition(position:int, data:CJDataOfInlayPosition):void
		{
			this.setData(String(position), data);
		}
		
		/**
		 * 获取武将装备位镶嵌信息
		 * @param heroId	武将id
		 * @return 若无镶嵌信息返回null
		 * 
		 */
		public function getInlayPosition(position:int) : CJDataOfInlayPosition
		{
			return this.getData(String(position));
		}
		
		
	}
}