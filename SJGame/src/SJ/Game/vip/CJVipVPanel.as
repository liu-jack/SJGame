package SJ.Game.vip
{
	import SJ.Common.Constants.ConstVip;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.config.CJDataOfVipFuncSetting;
	import SJ.Game.formation.CJTurnPage;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SAtlasLabel;
	import engine_starling.display.SLayer;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	
	import starling.utils.HAlign;
	
	/**
	 * VIP垂直滑动面板
	 * @author longtao
	 * 
	 */
	public class CJVipVPanel extends SLayer
	{
		private const TURN_PAGE_WIDTH:int = 480;
		private const TURN_PAGE_HEIGHT:int = 200;
		
		/** 字段宽度 **/
		private const FIELD_WIDTH:int = 30;
		/** 字段X偏移 **/
		private const FIEL_OFFSET_X:int = 80;
		/** 字段Y偏移 **/
		private const FIEL_OFFSET_Y:int = -35;
		
		/** 竖线X偏移 **/
		private const LINE_OFFSET_X:int = 78;
		/** 竖线Y偏移 **/
		private const LINE_OFFSET_Y:int = 20;
		
		private var _index:int = 0;
		/** 面板 **/
		private var _turnPage:CJTurnPage;
		
		public function CJVipVPanel(index:int=0)
		{
			super();
			
			_index = index;
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			_turnPage = new CJTurnPage(6);
			_turnPage.x = 0;
			_turnPage.y = 0;
			_turnPage.setRect(480 , 229);
			
			var listData:Array = _getDataArr();
			//设置渲染属性
			var listLayout:VerticalLayout = new VerticalLayout();
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			listLayout.gap = -4;
			_turnPage.layout = listLayout;
			_turnPage.dataProvider = new ListCollection(listData);
			_turnPage.itemRendererFactory = function _getRenderFatory():IListItemRenderer
			{
				const render:CJVipVItem = new CJVipVItem();
				render.owner = _turnPage;
				return render;
			};
			addChild(_turnPage);
			
			// 判断显示vip表头
			var img:ImageLoader;
			var imgLine:ImageLoader;
			var imgNum: SAtlasLabel;
			// index==0 -> vip0~vip12 
			// index==1 -> vip13~vip15
			var maxVipLimit:uint = uint(CJDataOfGlobalConfigProperty.o.getData("VIP_MAX_LEVEL"));
			var startIndex:uint = _index * ConstVip.VIP_MAX_FIELD;
			var endIndex:uint = startIndex+(ConstVip.VIP_MAX_FIELD-1);
			endIndex = (endIndex <= maxVipLimit) ? endIndex : maxVipLimit; // 有效性
			var pIndex:uint=startIndex;
			for (var i:uint=0;;++i)
			{
				// 蓝色竖线
				imgLine = new ImageLoader;
				imgLine.source = SApplication.assets.getTexture("vip_lanseshuxian");
				imgLine.x = i*FIELD_WIDTH + LINE_OFFSET_X;
				imgLine.y = 0;//LINE_OFFSET_Y;
				imgLine.height = 227;
				addChild(imgLine);
				
				if (pIndex>endIndex)
					break;
				
				// 表头
				img = new ImageLoader;
				img.x = i*FIELD_WIDTH + FIEL_OFFSET_X - 3;
				img.y = FIEL_OFFSET_Y;
				img.source = SApplication.assets.getTexture("vip_xiaov");
				addChild(img);
				
				imgNum = new SAtlasLabel();
				imgNum.hAlign = HAlign.LEFT;
				imgNum.registerChars("0123456789", "vip_xiaovip", SApplication.assets);
				imgNum.space_x = -4;
				imgNum.x = img.x + 12;
				imgNum.y = img.y + 8.5;
				if(pIndex >9)
				{
					imgNum.x = imgNum.x - 4;
				}
				imgNum.text = String(pIndex);
				addChild(imgNum);
				
				pIndex++;
			}
		}
		
		private function _getDataArr():Array
		{
			// 数据
			var listData:Array = new Array();
			
			
			var maxVipLimit:uint = uint(CJDataOfGlobalConfigProperty.o.getData("VIP_MAX_LEVEL"));
			var startIndex:uint = _index * ConstVip.VIP_MAX_FIELD;
			var endIndex:uint = startIndex+(ConstVip.VIP_MAX_FIELD-1);
			endIndex = (endIndex <= maxVipLimit) ? endIndex : maxVipLimit; // 有效性
			var obj:Object;
			var count:int = ConstVip.VIP_FIELD_NAME_ARR.length;
			for (var i:uint=0; i<count; ++i)
			{
				var fieldname:String = ConstVip.VIP_FIELD_NAME_ARR[i];
				obj = CJDataOfVipFuncSetting.o.getOneFieldData(fieldname, startIndex, endIndex);
				if(!obj)
				{
					continue;
				}
				var title:String = CJLang("vip_"+fieldname);
				if ("null" != title)
				{
					listData.push({title:CJLang("vip_"+fieldname), data:obj, 
						startIndex:startIndex, endIndex:endIndex, type:ConstVip.VIP_FIELD_TYPE_OBJ[fieldname]});
				}
			}
			
			return listData;
		}
		
		/**
		 * 更新界面
		 */
		public function updateLayer():void
		{
			for (var i:uint=0; i<ConstVip.VIP_FIELD_NAME_ARR.length; ++i)
				_turnPage.updateItemAt(i);
		}

		public function get index():int
		{
			return _index;
		}
	}
}