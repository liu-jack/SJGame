package SJ.Game.controls
{
	import flash.net.URLVariables;
	
	import SJ.Common.Constants.ConstPlatformId;
	import SJ.Game.ServerList.CJServerList;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.loader.CJLoaderMoudle;
	import SJ.Game.utils.SNetUrlUtil;
	
	import engine_starling.display.SAutoSizeImage;
	import engine_starling.display.SImage;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;

	public class CJMapUtil
	{
		public function CJMapUtil()
		{
		}
		
		/**
		 * 根据纹理，返回拼好的地图 
		 * @param textures
		 * @return 
		 * 
		 */
		public static function getMapLayer(textures:Vector.<Texture>):Sprite
		{
			var mapUint:Sprite = new Sprite;
			
			var i:int,offsetx:int = 0;
			var w:Number = 0;
			
			
			offsetx = 2;
			
			var qb:QuadBatch = new QuadBatch();
			for(i =0;i<textures.length;i++)
			{
				var simage:Image = new Image(textures[i]);
				simage.smoothing = TextureSmoothing.NONE;
				simage.x = offsetx;
				qb.addImage(simage);
				offsetx += simage.width ;
			}
			offsetx = 0
			for(i =0;i<textures.length;i++)
			{
				simage = new Image(textures[i]);
				simage.x = offsetx;
				qb.addImage(simage);
				offsetx += simage.width ;
			}
//			qb.blendMode = BlendMode.NONE;
			mapUint.addChild(qb);
//			for (i=0;i<textures.length;i++)
//			{
//				var singlemap:SAutoSizeImage = new SAutoSizeImage(textures[i]);
////				singlemap.blendMode = BlendMode.NONE;
//				singlemap.smoothing = TextureSmoothing.NONE;
//				singlemap.x = offsetx;
//				mapUint.addChild(singlemap);
//				offsetx += singlemap.width;
//			}
//			mapUint.blendMode = BlendMode.NONE;
//			mapUint.flatten();
//			offsetx = 0;
//			for (i=0;i<textures.length;i++)
//			{
//				singlemap = new SImage(textures[i]);
//				singlemap.smoothing = TextureSmoothing.NONE;
//				singlemap.x = offsetx;
//				mapUint.addChild(singlemap);
//				offsetx += singlemap.width;
//				w += singlemap.width
//			}
//			mapUint.addChild(qb);
//			mapUint.flatten();
			
			
//			mapUint.blendMode = BlendMode.NONE;
//			mapUint.width = w;
			
//			mapUint.flatten();
			
			
			
			return mapUint;
//			var mapUint:SLayer = new SLayer;
//			var j:int = 0;
//			var qb:QuadBatch = new QuadBatch;
//			for(var i:String in textures)
//			{
//				var mapunit:SImage = new SImage(textures[i]);
//				mapunit.x = j*ConstMainUI.MAPUNIT_WIDTH;
//				if(j == 2)
//				{
//					mapunit.x = mapunit.x-1;
//				}
//				qb.addImage(mapunit);
//				j++;
//			}
//			mapUint.addChild(qb);
//			mapUint.flatten();
//			return mapUint;
		}
		/**
		 * 进入默认主城 
		 * @param params
		 * 
		 */
		public static function enterMainCity(params:Object = null):void
		{
			//上次退出时所在场景
			var roleInfo:CJDataOfRole = CJDataManager.o.DataOfRole
			var sceneId:int = roleInfo.last_map;
			if(!params)
			{
				params = new Object;
			}
			params.rolePos = {x:roleInfo.pos_x,y:roleInfo.pos_y};
			params.cityid = roleInfo.last_map;
			//第一次加载,不加载后续资源.防止卡顿
			CJLoaderMoudle.helper_enterMainUI(params,false);
		}
		
		public static function enterCharge():void
		{
			var role:CJDataOfRole = CJDataManager.o.DataOfRole;
			var data:URLVariables = new URLVariables();
			data.uid = role.name;
			data.serverid = CJServerList.getServerID();
			data.channelid = ConstPlatformId.channelIdSignDict[ConstPlatformId.getCHANNELID()]
			var url:String = CJDataOfGlobalConfigProperty.o.getData("WEB_CHARGE_URL");
			SNetUrlUtil.openurl(url,data);
		}
	}
}