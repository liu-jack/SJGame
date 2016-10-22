package SJ.Game.heroPropertyUI
{
	import SJ.Common.Constants.ConstHero;
	import SJ.Common.Constants.ConstPlayer;
	import SJ.Common.global.textRender;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.config.CJDataOfHeroTagProperty;
	import SJ.Game.data.json.Json_hero_upper_limit_config;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.events.CollectionEventType;
	import feathers.events.FeathersEventType;
	
	import flash.text.TextFormat;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * 武将属性面板左侧的武将名称列表
	 * @author longtao
	 * 
	 */
	public class CJHeroNameItem extends SLayer implements IListItemRenderer
	{
		private static const _CONST_WIDTH_:int = 80;
		private static const _CONST_HEIGHT_:int = 40;
		
		private static const _SELECTED_X_:int = 0;
		private static const _SELECTED_WIDTH_:int = 83;
		private static const _SELECTED_HEIGHT_:int = 40;
		
		private static const _UNSELECTED_X_:int = 10;
		private static const _UNSELECTED_WIDTH_:int = 72;
		private static const _UNSELECTED_HEIGHT_:int = 40;
		
		/*item 的数据*/
		private var _data:Object = null;
		/*渲染时候在父容器的索引*/
		private var _index:int;
		/*放置item的容器*/
		private var _owner:List;
		/*名称按钮*/
		private var _btn:Button;
		
		private var _isSelected:Boolean;
		private var _templateId:String;
		private var _heroId:String;
		
		public function CJHeroNameItem()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			_drawContent();
//			_addListeners();
		}
		
		override public function dispose():void
		{
			_owner = null;
			_data = null;
			super.dispose();
		}
		
		
		override protected function draw():void
		{
			super.draw();
			
			const isSelectInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(isSelectInvalid)
			{
				this._heroId = this.data['heroId'];
				this._templateId = this.data['templeteid'];
				this.name = this.data['name'];
				var tIsSelected:Boolean = data["isSelected"];
//				_btn.name = index.toString();
				if (tIsSelected)
				{
					_btn.defaultSkin = new SImage( SApplication.assets.getTexture("common_xuanxiangka01") );
					_btn.x = _SELECTED_X_;
					_btn.width = _SELECTED_WIDTH_;
					_btn.height = _SELECTED_HEIGHT_;
				}
				else
				{
					_btn.defaultSkin = new SImage( SApplication.assets.getTexture("common_xuanxiangka02") );
					_btn.x = _UNSELECTED_X_;
					_btn.width = _UNSELECTED_WIDTH_;
					_btn.height = _UNSELECTED_HEIGHT_;
				}
				
				
				if ( int(_templateId) != 0 )
				{
					var fontFormat:TextFormat;
					var temp:CJDataHeroProperty = CJDataOfHeroPropertyList.o.getProperty(int(_templateId));
					// 改变武将名颜色
					fontFormat = new TextFormat( "黑体", 10, ConstHero.ConstHeroNameColor[temp.quality]);
					_btn.defaultLabelProperties.textFormat = fontFormat;
					_btn.label = data.heroname;
//					if (temp.type == ConstPlayer.SConstPlayerTypePlayer)
//						_btn.label = CJDataManager.o.DataOfRole.name;
//					else
//						_btn.label = temp.name;
				}
				else
				{
					if (data.isUsable)
					{
						fontFormat = new TextFormat( "Arial", 10, 0xFFFFFF);
						_btn.defaultLabelProperties.textFormat = fontFormat;
						_btn.label = CJLang("HERO_UI_EMPLOY");
					}
					else
					{
						fontFormat = new TextFormat( "Arial", 10, 0xEA9667);
						_btn.defaultLabelProperties.textFormat = fontFormat;
						var jsHeroUpper:Json_hero_upper_limit_config = CJDataOfHeroTagProperty.o.getHeroUpperJS(data.tag);
						_btn.label = CJLang(jsHeroUpper.describe);	
					}
					
				}
			}
		}
		
		private function _drawContent():void
		{
			this.width = _CONST_WIDTH_;
			this.height = _CONST_HEIGHT_;
			
			_btn = new Button();
			_btn.width = _UNSELECTED_WIDTH_;
			_btn.height = _UNSELECTED_HEIGHT_;
			_btn.defaultSkin = new SImage( SApplication.assets.getTexture("common_xuanxiangka02") );
			_btn.labelFactory = textRender.glowTextRender;
			addChild(_btn);
		}
		
		public function set data(value:Object):void
		{
			_data = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function get templateId():String
		{
			return _templateId;
		}
		
		public function get heroId():String
		{
			return _heroId;
		}
		
		public function get index():int
		{
			return _index;
		}
		
		public function set index(value:int):void
		{
			_index = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		public function get owner():List
		{
			return _owner;
		}
		
		public function set owner(value:List):void
		{
			_owner = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		public function get isSelected():Boolean
		{
			return _isSelected;
		}
		
		public function set isSelected(value:Boolean):void
		{
			_isSelected = value;
//			_data["isSelected"] = _isSelected;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
	}
}