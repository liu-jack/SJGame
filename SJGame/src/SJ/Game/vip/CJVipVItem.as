package SJ.Game.vip
{
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.Constants.ConstVip;
	import SJ.Game.formation.CJItemTurnPageBase;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale3Image;
	import feathers.textures.Scale3Textures;
	
	/**
	 * VIP垂直滑动面板子控件
	 * @author longtao
	 * 
	 */
	public class CJVipVItem extends CJItemTurnPageBase
	{
		private static const ITEM_WIDTH:int = 480;
		private static const ITEM_HEIGHT:int = 42;
		
		
		private var _labelHeader:Label;
		
		// 文字
		private var _arrLabel:Vector.<Label>;
		// 图片
		private var _arrImg:Vector.<ImageLoader>;
		
		public function CJVipVItem()
		{
			super("CJVipVItem");height
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			width = ITEM_WIDTH;
			height = ITEM_HEIGHT;
			
			var img:ImageLoader;
			
			// 蓝线
			img = new ImageLoader;
			img.source = SApplication.assets.getTexture("vip_lanxian");
			img.x = 0;
			img.y = 0;
			addChild(img);
			
			// 底框
			var img1:Scale3Image;
			img1 = new Scale3Image(new Scale3Textures(SApplication.assets.getTexture("vip_biaogetiao") , 84 , 1));
			img1.x = 3;
			img1.y = 0;
			img1.width = SApplicationConfig.o.stageWidth;
			addChild(img1);
			
			_labelHeader = new Label;
			_labelHeader.x = 5;
			_labelHeader.y = 5;
			_labelHeader.width = 70;
			_labelHeader.height = 48;
			_labelHeader.textRendererProperties.textFormat = ConstTextFormat.textformatyellowcenter;
			_labelHeader.textRendererProperties.multiline = true; // 可显示多行
			_labelHeader.textRendererProperties.wordWrap = true; // 可自动换行
			addChild(_labelHeader);
			
			_arrLabel = new Vector.<Label>;
			for( var i:uint=0; i<ConstVip.VIP_MAX_FIELD; ++i)
			{
				var label:Label = new Label;
				label.x = i*30 + _labelHeader.x + 75;
				label.y = 10;
				label.width = 30;
				label.height = 35;
				label.visible = false;
				label.textRendererProperties.textFormat = ConstTextFormat.textformatwhitecenter;
				addChild(label);
				_arrLabel.push(label);
			}
			
			_arrImg = new Vector.<ImageLoader>;
			for ( i=0; i<ConstVip.VIP_MAX_FIELD; ++i )
			{
				img = new ImageLoader;
				img.x = i*30 + _labelHeader.x + 76;
				img.y = 8;
				img.visible = false;
				addChild(img);
				_arrImg.push(img);
			}
		}
		
		override protected function draw():void
		{
			super.draw();
			
			if(data == null)
				return;
			
			var isAllInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(!isAllInvalid)
				return;
			
			// 重新绘制
			_labelHeader.text = data.title;
			
			var moveIndex:uint = data.startIndex;
			
			if (data.type == ConstVip.VIP_SHOW_TYPE_BOOLEAN)
			{
				_arrImg
			}
			else
			{
				// 文字显示

			}
			
			moveIndex = data.startIndex;
			for( var i:uint=0; i<ConstVip.VIP_MAX_FIELD; ++i)
			{
				var label:Label = _arrLabel[i];
				label.visible = false;
				var img:ImageLoader = _arrImg[i];
				img.visible = false;
				
				var str:String = data.data[moveIndex];
				var b:Boolean = Boolean(int(data.data[moveIndex]));
				
				if (data.type == ConstVip.VIP_SHOW_TYPE_COUNT) // 数量
					label.visible = true;
				else if (data.type == ConstVip.VIP_SHOW_TYPE_PERCENT) // 判断百分比
				{
					label.visible = true;
					str += "%";
				}
				else	// 判断是否
				{
					img.visible = true;
					if(b)
						img.source = SApplication.assets.getTexture("vip_duigou");
					else
						img.source = SApplication.assets.getTexture("vip_chahao");
				}
					
				// 仅仅是否信息时才不显示label
				label.text = str;
				moveIndex++;
				if (moveIndex > data.endIndex)
					break;
			}
			
		}
		

	}
}