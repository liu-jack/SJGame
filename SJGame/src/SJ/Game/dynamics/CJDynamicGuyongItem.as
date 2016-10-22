package SJ.Game.dynamics
{
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketCommand_duobao;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import starling.events.Event;

	/**
	 * 动态雇佣显示单元
	 * @author zhengzheng
	 * 
	 */	
	public class CJDynamicGuyongItem extends CJItemTurnPageBase
	{
		/**敲锣图标*/
		private var _imgLuo:SImage;
		/**时间显示*/
		private var _labTime:Label;
		/**动态描述*/
		private var _labDesc:Label;
		/**同意按钮*/
		private var _btnAgree:Button;
		/**拒绝按钮*/
		private var _btnReject:Button;
		
		public function CJDynamicGuyongItem()
		{
			super("CJDynamicSnatchItem");
		}
		override protected function initialize():void
		{
			_initData();
			_drawContent();
			_addListener();
		}
		/**
		 * 添加按钮监听
		 * 
		 */		
		private function _addListener():void
		{
			_btnAgree.addEventListener(Event.TRIGGERED , _btnAgreeTriggered);
			_btnReject.addEventListener(Event.TRIGGERED , _btnRejectTriggered);
		}
		/**
		 * 初始化数据
		 */		
		private function _initData():void
		{
			this.width = 393;
			this.height = 52;
			
			_imgLuo = new SImage(SApplication.assets.getTexture("dongtai_luo"));
			_imgLuo.x = 10;
			_imgLuo.y = 10;
			
			_labTime = new Label();
			_labTime.x = 56;
			_labTime.y = 4;
			_labTime.textRendererProperties.textFormat = new TextFormat( "Arial", 10, 0x37E1D6);
			
			_labDesc = new Label();
			_labDesc.textRendererProperties.textFormat = new TextFormat( "Arial", 10, 0x37E1D6, null, null, null, null, null, TextFormatAlign.LEFT);
			_labDesc.textRendererProperties.wordWrap = true; 
			_labDesc.textRendererFactory = textRender.htmlTextRender;
			_labDesc.x = 56;
			_labDesc.y = 19;
			_labDesc.width = 230;
			
			
			_btnAgree = new Button();
			_btnAgree.x = 300;
			_btnAgree.y = 13;
			_btnAgree.width = 35;
			_btnAgree.height = 28;
			_btnAgree.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			_btnAgree.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			_btnAgree.defaultLabelProperties.textFormat = new TextFormat( "Arial", 10, 0xE3B542);
			_btnAgree.label = CJLang("DYNAMIC_AGREE");
			
			_btnReject = new Button();
			_btnReject.x = 346;
			_btnReject.y = 13;
			_btnReject.width = 35;
			_btnReject.height = 28;
			_btnReject.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			_btnReject.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			_btnReject.defaultLabelProperties.textFormat = new TextFormat( "Arial", 10, 0xE3B542);
			_btnReject.label = CJLang("DYNAMIC_REJECT");

		}
		
		/**
		 * 画出单个条目
		 */
		private function _drawContent():void
		{
			//文字底框
			var imgBg:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_liaotian_wenzidi", 5, 5, 2, 2);
			imgBg.width = 393;
			imgBg.height = 52;
			imgBg.alpha = 0.8;
			addChild(imgBg);
			
			addChild(_imgLuo);
			addChild(_labTime);
			addChild(_labDesc);
			addChild(_btnAgree);
			addChild(_btnReject);
		}
		
		override protected function draw():void
		{
			super.draw();
			const isSelectInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(isSelectInvalid)
			{
				_labTime.text = CJDynamicUtil.o.changeSecondToDate(data.applytime);
				var descStr:String;
				_labDesc.width = 230;
				var heroName:String;
				var heroinfo:Object = JSON.parse(data.heroinfo)
				var heroProperty:CJDataHeroProperty = CJDataOfHeroPropertyList.o.getProperty(int(heroinfo.templateid));
				if (heroProperty)
				{
					heroName = CJLang(heroProperty.name);
				}
				descStr = CJLang("DYNAMIC_GUYONG")  + "：" + 
					CJLang("DYNAMIC_GUYONG_DESCRIPTION", {"rolename":data.friendrolename, "heroname":heroName});
				_labDesc.text = descStr;
			}
		}
		
		/**
		 * 同意雇佣触发事件
		 * @param e Event
		 */		
		private function _btnAgreeTriggered(e:Event):void
		{
			SocketCommand_duobao.agreeEmploy(data.frienduid , data.heroid);
		}
		
		/**
		 * 拒绝雇佣触发事件
		 * @param e Event
		 */		
		private function _btnRejectTriggered(e:Event):void
		{
			SocketCommand_duobao.rejectEmploy(data.frienduid);
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}