package SJ.Game.duobao
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import SJ.Common.global.textRender;
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.formation.CJTurnPage;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Label;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.display.Scale9Image;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.textures.Scale9Textures;
	
	/**
	 +------------------------------------------------------------------------------
	 * @comment 夺宝雇佣-滚动列表
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-11-7 下午3:19:14  
	 +------------------------------------------------------------------------------
	 */
	public class CJDuoBaoEmployListLayer extends SLayer
	{
		private var _title:Label;
		private var _bg:Scale9Image;
		private var _turnpage:CJTurnPage;
		private var _tf:TextFormat;
		private var _data:Object;
		private var _key:String;
		
		public function CJDuoBaoEmployListLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this._initContent();
		}
		
		private function _initContent():void
		{
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture('baoshi_yijianhechengwenzidi') , new Rectangle(10,10,1,1)));
			_bg.width = this.width;
			_bg.height = this.height;
			this.addChild(_bg);
			
			_tf = new TextFormat("黑体" , 15);
			_title = new Label();
			_title.textRendererFactory = textRender.standardTextRender;
			_title.textRendererProperties.textFormat = _tf;
			_title.x = 42;
			this.addChild(_title);
			
			this._turnpage = new CJTurnPage(4 , CJTurnPage.SCROLL_V);
			this._turnpage.setRect(190 , 160);
			this._turnpage.x = 4;
			this._turnpage.y = 20;
			this.addChild(this._turnpage);
			
			const listLayout:VerticalLayout = new VerticalLayout();
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			listLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
			listLayout.gap = 5;
			this._turnpage.paddingTop = 0;
			this._turnpage.layout = listLayout;
		}
		
		override protected function draw():void
		{
			super.draw();
		}
		
		/**
		 * 设置是好友还是武将
		 * data={'key':'friend' , 'data':*****}
		 */ 
		public function set data(ob:Object):void
		{
			if(!ob)
			{
				return;
			}
			this._turnpage.dataProvider = ob.data;
			
			var key:String = ob.key;
			_key = key;
			this._turnpage.itemRendererFactory = function _getRenderFatory():IListItemRenderer
			{
				var render:CJItemTurnPageBase;
				if(key == 'friend')
				{
					render = new CJDuoBaoEmployFriendItem();
				}
				else
				{
					render = new CJDuoBaoEmployHeroItem();
				}
				render.owner = _turnpage;
				return render;
			}
				
			if(key == 'friend')
			{
				this._title.text = CJLang('duobao_selectfriend');
				_tf.color = 0xA4FE3D;
			}
			else
			{
				this._title.text = CJLang('duobao_selecthero');
				_tf.color = 0xFCC13A;
			}
			
			this.invalidate();
		}
	}
}