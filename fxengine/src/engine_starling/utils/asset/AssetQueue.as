package engine_starling.utils.asset
{
	import engine_starling.utils.SArrayUtil;

	internal class AssetQueue
	{
		public function AssetQueue(mgroupName:String)
		{
			groupName = mgroupName;
		}
		
		
		/**
		 * 压入资源 
		 * @param massets
		 * 
		 */
		public function pushAssets(massets:Array):void
		{
			assets = assets.concat(massets);
			assets = SArrayUtil.deleteRepeat(assets);
//			assets = SArrayUtil.deleteElements(assets,['sxml','json','anims','mp3']);
		}
		
		/**
		 * 加载完成 
		 * 
		 */
		public function loadfinish():void
		{
			onProgress = null;
		}
		
		public function dispose():void
		{
			assets = null;
			onProgress = null;
			groupName = null;
		}
		/**
		 * 资源组名称 
		 */	
		public var groupName:String;
		public var assets:Array = new Array();
		//			public var resourceQueue:Vector.<AssetQueueStruct> = new Vector.<AssetQueueStruct>();
		public var onProgress:Function;
	}
}