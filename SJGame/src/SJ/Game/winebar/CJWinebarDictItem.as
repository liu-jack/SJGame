package SJ.Game.winebar
{
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.filters.ConvolutionFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.pixelmask.PixelMaskDisplayObject;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	/**
	 * 宝典内武将牌
	 * @author longtao
	 * 
	 */
	public class CJWinebarDictItem extends SLayer
	{
		// 控件宽高
		private static const CONST_WIDTH:uint = 90;
		private static const CONST_HEIGHT:uint = 120;
		
		// 该武将的数据
		private var _heroInfo:Object;
		
		/// 含遮罩的底层
		private var _layer:PixelMaskDisplayObject;
		// 武将半身像
		private var _heroBust:ImageLoader;
		// 技能名称
		private var _labelSkill:Label;
		
		// 武将名称
		private var _heroName:TextField;
		// 武将职业小图标
		private var _jobIcon:ImageLoader;
		
		public function CJWinebarDictItem()
		{
			super();
			
			_init();
			
			// 添加触摸事件
			addEventListener(TouchEvent.TOUCH, _touchHandler);
		}
		
		override public function dispose():void
		{
			// 移除触摸事件
			removeEventListener(TouchEvent.TOUCH, _touchHandler);
			
			super.dispose();
		}
		
		private function _touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(touch == null)
				return;
			if (touch.phase != TouchPhase.ENDED)
				return;
			
			/// 
			SApplication.moduleManager.enterModule("CJWinebarHeroModule", [0, _heroInfo.id, "-1"]);
		}
		
		// 初始化layer
		private function _init():void
		{
			// 设置控件宽高
			width = CONST_WIDTH;
			height = CONST_HEIGHT;
			
			// 整个item的背景
			var texture:Texture = SApplication.assets.getTexture("wujiangbaodian_renwudikuang");
			var scale9Texture:Scale9Textures = new Scale9Textures(texture, new Rectangle(15,15 ,8,9));
			var bg:Scale9Image = new Scale9Image(scale9Texture);
			bg.width = width;
			bg.height = height;
			addChild(bg);
			
			// 遮罩底层
			_layer = new PixelMaskDisplayObject();
			
			// 遮罩本身
			bg = new Scale9Image(scale9Texture);
			bg.x = 3;
			bg.y = 3;
			bg.width = width-2*bg.x;
			bg.height = height-2*bg.y;
			_layer.mask = bg;
			
			// 武将卡牌
			_heroBust = new ImageLoader;
			_heroBust.source = Texture.empty(1,1);
			_layer.addChild(_heroBust);
			addChild(_layer);
			
			// 技能名称底
			var imgskillNameBG:ImageLoader = new ImageLoader;
			imgskillNameBG.source = SApplication.assets.getTexture("wujiangbaodian_jinengdikuang");
			imgskillNameBG.x = 10;
			imgskillNameBG.y = 90;
			imgskillNameBG.width = 70;
//			imgskillNameBG.height = 15;
			addChild(imgskillNameBG);
			// 技能名称
			_labelSkill = new Label;
			_labelSkill.textRendererProperties.textFormat = ConstTextFormat.textformatwhitecenter;
			_labelSkill.x = 20;
			_labelSkill.y = 95;
			_labelSkill.width = 70;
			_labelSkill.height = 20;
			addChild(_labelSkill);
//			// “技”图片
//			var imgSkill:ImageLoader = new ImageLoader;
//			imgSkill.source = SApplication.assets.getTexture("zhaomu_ji");
//			imgSkill.x = 0;
//			imgSkill.y = 90;
//			addChild(imgSkill);
			
			// 武将名称
			_heroName = new TextField(15, 60, "");
			_heroName.x = 8;
			_heroName.y = 5;
			_textStroke(_heroName);
			addChild(_heroName);
			
			// 职业小图标
			_jobIcon = new ImageLoader;
			_jobIcon.x = 5;
			_jobIcon.y = 60;
			addChild(_jobIcon);
			
		}
		
		/// 更新界面
		private function _updateLayer():void
		{
			if(null == _heroInfo)
			{
				visible = false;
				return;
			}
			visible = true;
			
			// 武将半身像
			_heroBust.source = SApplication.assets.getTexture(_heroInfo.card);
			_heroBust.width = CONST_WIDTH;
			_heroBust.height = CONST_HEIGHT;
			
			// 武将名称
			_heroName.text = CJLang(_heroInfo.name);
			// 获取技能名称
			_labelSkill.text = CJLang(_heroInfo.skillname);
			// 职业小图标
			var str:String = CJWinebarDictItem["CONST_SOURCE_JOB_"+_heroInfo.job];
			_jobIcon.source = SApplication.assets.getTexture(str);
		}
		
		// 文字描边
		private function _textStroke(tf:TextField):void
		{
			var matrix:Array = [0,1,0,
				1,1,1,
				0,1,0];
			tf.nativeFilters = [new ConvolutionFilter(3,3,matrix,3),
				new GlowFilter(0xFFFFFF,1.0,2.0,2.0,5,2)];
		}
		
		/**
		 * 设置数据
		 * @param heroInfo{id:xxx, card:xxx, name:xxx, skillname:xxx, job:xxx} 武将信息
		 * 
		 */
		public function set data(tempInfo:Object):void
		{
			if (_heroInfo!=null && tempInfo!=null)
			{
				if (_heroInfo.id == tempInfo.id)
					return;
			}
			_heroInfo = tempInfo;
			// 更新界面
			_updateLayer();
		}
	}
}