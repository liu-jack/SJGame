package SJ.Game.reward
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import SJ.Game.controls.CJItemUtil;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.lang.CJLang;
	import SJ.Game.utils.SDateUtil;
	
	import engine_starling.SApplication;
	
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.controls.ScrollText;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	/**
	 +------------------------------------------------------------------------------
	 * 奖励的一个小面板
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-11-19 下午6:11:43  
	 +------------------------------------------------------------------------------
	 */
	public class CJRewardScreen extends Screen
	{
		private var _tYouxiaoqi:Label;
		private var _tTitle:ScrollText;
		private var _tContent:ScrollText;
		private var _data:Object;
		private var _id:String;
		
		public function CJRewardScreen()
		{
			super();
		}
		
		override protected function initialize():void
		{
			this._drawContent();
		}
		
		private function _drawContent():void
		{
			var bg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture('common_quanbingdise') , new Rectangle(2,2,1,1)));
			bg.width = 382;
			bg.height = 156;
			this.addChild(bg);
			
			var tf:TextFormat = new TextFormat('黑体' ,  null , 0xffff08);
			var tf1:TextFormat = new TextFormat('黑体' ,  10 , 0xffffff);
			
			var label_youxiaoqi:Label = new Label();
			label_youxiaoqi.textRendererProperties.textFormat = tf;
			this.addChild(label_youxiaoqi);
			label_youxiaoqi.x = 13;
			label_youxiaoqi.y = 10 ;
			label_youxiaoqi.text = CJLang('reward_youxiaoqi') + ":";
			
			_tYouxiaoqi = new Label();
			_tYouxiaoqi.textRendererProperties.textFormat = tf1;
			this.addChild(_tYouxiaoqi);
			_tYouxiaoqi.x = 58;
			_tYouxiaoqi.y = 10 ;
			
			var tfTitle:TextFormat = new TextFormat('黑体' ,  10 , 0xff0000);
			_tTitle = new ScrollText();
			_tTitle.isHTML = true;
			_tTitle.textFormat = tf1;
			_tTitle.maxWidth = 362;
			_tTitle.maxHeight = 45;
			this.addChild(_tTitle);
			_tTitle.x = 13;
			_tTitle.y = 35 ;
			
			var tf2:TextFormat = new TextFormat('黑体' ,  null , 0x4BDFF6);
			var label_content:Label = new Label();
			label_content.textRendererProperties.textFormat = tf2;
			this.addChild(label_content);
			label_content.x = 13;
			label_content.y = 86 ;
			label_content.text = CJLang('reward_content') + ":";
			
			_tContent = new ScrollText();
			_tContent.isHTML = true;
			_tContent.textFormat = tf1;
			_tContent.maxWidth = 362;
			_tContent.maxHeight = 85;
			this.addChild(_tContent);
			_tContent.x = 13;
			_tContent.y = 103 ;
		}
		
		override protected function draw():void
		{
			super.draw();
			
			if(this.owner && this.data)
			{
				_tYouxiaoqi.text = _getDateString(Number(this.data['ctime'])) + "  "+CJLang('reward_zhi')+"  " + _getDateString(Number(this.data['endtime']));
				_tTitle.text = this.data['content'];
//				显示里面的内容
				_tContent.text = CJItemUtil.getItemDescription(this.data['awarditem']);
				
				var templateSetting:CJDataOfItemProperty = CJDataOfItemProperty.o;
				var itemTemplate:Json_item_setting = templateSetting.getTemplate(int(this.data['awarditem']));
				_tContent.name = CJLang(itemTemplate.itemname);
			}
		}
		
		private function _getDateString(seconds:Number):String
		{
			return SDateUtil.LTSeconds2YYMMDDHHIISS(seconds);
		}

		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			if(!value || value == _data)
			{
				return;
			}
			_data = value;
			_id = _data['id'];
		}

		public function get id():String
		{
			return _id;
		}
		
		public function get text():String
		{
			return this._tContent.name;
		}
	}
}