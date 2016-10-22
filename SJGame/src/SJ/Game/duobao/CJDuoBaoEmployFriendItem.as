package SJ.Game.duobao
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import SJ.Common.global.textRender;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfFriendItem;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.formation.CJItemTurnPageBase;
	
	import engine_starling.SApplication;
	
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	/**
	 +------------------------------------------------------------------------------
	 * @comment 雇佣-好友列表Item
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-11-7 下午5:01:14  
	 +------------------------------------------------------------------------------
	 */
	public class CJDuoBaoEmployFriendItem extends CJItemTurnPageBase
	{
		private var _level:Label;
		/*好友名称*/
		private var _fname:Label;
		
		public const ITEMWIDTH:int = 170;
		
		public const ITEMHEIGHT:int = 35;
		
		private var _selectedMask:Scale9Image;
		
		public function CJDuoBaoEmployFriendItem()
		{
			super("CJDuoBaoEmployFriendItem");
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this._drawContent();
			this._addEventListeners();
		}
		
		private function _addEventListeners():void
		{
			
		}
		
		private function _drawContent():void
		{
			this.width = ITEMWIDTH;
			this.height = ITEMHEIGHT;
			
			var bg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("huodong_dikuang01"),new Rectangle(5 , 25 , 1 , 1)));
			bg.width = ITEMWIDTH - 5;
			bg.height = ITEMHEIGHT;
			this.addChild(bg);
			
			var lv:Label = new Label();
			lv.textRendererFactory = textRender.standardTextRender;
			lv.textRendererProperties.textFormat = new TextFormat("黑体",12,0xFFF31E);
			lv.text = "LV.";
			lv.x = 12;
			lv.y = 10;
			this.addChild(lv);
			
			_level = new Label();
			_level.textRendererFactory = textRender.standardTextRender;
			_level.textRendererProperties.textFormat = new TextFormat("黑体",12,0xFFF31E);
			_level.text = "0";
			_level.x = 30;
			_level.y = 10;
			this.addChild(_level);
			
			_fname = new Label();
			_fname.textRendererFactory = textRender.standardTextRender;
			_fname.textRendererProperties.textFormat = new TextFormat("黑体",12,0x8FFF15);
			_fname.text = "";
			_fname.x = 53;
			_fname.y = 10;
			this.addChild(_fname);
			
			_selectedMask = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture('zhuzhanhaoyou_xuanzhong') ,new Rectangle(8,8,1,1)));
			_selectedMask.width = ITEMWIDTH - 3;
			_selectedMask.height = ITEMHEIGHT;
			this.addChild(_selectedMask);
			_selectedMask.visible = false;
		}
		
		/**
		 * 选中发事件
		 */ 
		override protected function onSelected():void
		{
			super.onSelected();
			CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_DUOBAO_SELECTFRIEND , false , this.data);
			_selectedMask.visible = true;
		}
		
		override protected function draw():void
		{
			super.draw();
			if(!this.data)
			{
				return;
			}
			
			var friend:CJDataOfFriendItem = data as CJDataOfFriendItem;
			_level.text = ""+friend.level;
			_fname.text = friend.rolename;
			
			if(CJDataManager.o.DataOfDuoBaoEmploy.tempSelectFriendUid != friend.frienduid)
			{
				_selectedMask.visible = false;
			}
		}
	}
}