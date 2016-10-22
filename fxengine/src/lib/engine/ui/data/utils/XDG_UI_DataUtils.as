package lib.engine.ui.data.utils
{
	import flash.geom.Point;
	
	import lib.engine.iface.IResource;
	import lib.engine.ui.data.ImageTileInfo;
	import lib.engine.ui.data.ImagesSet;
	import lib.engine.utils.functions.Assert;
	
	public class XDG_UI_DataUtils
	{
		public function XDG_UI_DataUtils()
		{
		}
		
		/**
		 * 合成图片资源名称 
		 * @param imagesetname
		 * @param areaName
		 * @return 
		 * 
		 */
		public static function MakeImageName(imagesetname:String,areaName:String):String
		{
			return imagesetname + "::" + areaName;
		}
		
		/**
		 * 获取imageset名称 
		 * @param imagename
		 * @return 
		 * 
		 */
		public static function GetImage_ImageSetName(imagename:String):String
		{
			return imagename.split('::')[0];
		}
		/**
		 * 获得区域名称 
		 * @param imagename
		 * @return 
		 * 
		 */
		public static function GetImage_AreaName(imagename:String):String
		{
			return imagename.split('::')[1];
		}
		
		/**
		 * 
		 * @param cBtnInfo
		 * @param BtnInfo
		 * @param layoutData
		 * @return 
		 * 
		 */
//		public static function ConvertButtonInfo(cBtnInfo:XDG_UI_Data_Button,layoutData:Layouts):CButtonInfo
//		{
//			var BtnInfo:CButtonInfo = null;
//			var _size:Point = _ConvertImageToSize(cBtnInfo.normal,layoutData);
//			var _upPos:Point = _ConvertImageToPoint(cBtnInfo.normal,layoutData);
//			var _overPos:Point = _ConvertImageToPoint(cBtnInfo.over,layoutData);
//			var _downPos:Point = _ConvertImageToPoint(cBtnInfo.down,layoutData);
//			var _disabledPos:Point  = _ConvertImageToPoint(cBtnInfo.disabled,layoutData);
//			var _selectedPos:Point = _ConvertImageToPoint(cBtnInfo.select,layoutData);
//			
//			
//			BtnInfo = new CButtonInfo(_size,_upPos,_overPos,_downPos,_disabledPos,_selectedPos);
//			
//			
//			return BtnInfo;
//			
//		}
		public static function _ConvertImageToPoint(name:String,ResManager:IResource):Point
		{
			var info:ImageTileInfo = _ConvertImageToPicInfo(name,ResManager);
			if(info == null)
				return null;
			return new Point(info.x,info.y);
		}
		/**
		 * 转换图片字符串,到尺寸 
		 * @param name frm_pk::btn_itemfrm_001
		 * @param ResManager 资源管理器
		 * @return 尺寸
		 * 
		 */
		public static function ConvertImageToSize(name:String,ResManager:IResource):Point
		{
			var info:ImageTileInfo = _ConvertImageToPicInfo(name,ResManager);
			Assert(info != null,"_ConvertImageToSize 没有找到Info:" + name);
			if(info == null)
				return null;
			return new Point(info.width,info.height);
		}
		
		public static function _ConvertImageToPicInfo(name:String,ResManager:IResource):ImageTileInfo
		{
			if(name == null)
				return null;
			var info:ImageTileInfo = null;
			var imagesetName:String = GetImage_ImageSetName(name);
			var areaname:String = GetImage_AreaName(name);
			var imageset:ImagesSet = ResManager.getImageset(imagesetName).value;
			info = imageset.getArea(areaname);
			return info;
		}
	}
}