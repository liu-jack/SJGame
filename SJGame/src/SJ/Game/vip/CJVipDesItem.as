package SJ.Game.vip
{
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.formation.CJItemTurnPageBase;
	
	import feathers.controls.Label;
	
	public class CJVipDesItem extends CJItemTurnPageBase
	{
		
		private var _label:Label;
		
		public function CJVipDesItem()
		{
			super("CJVipDesItem");
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			width = 125;
			height = 12;
			
			_label = new Label();
			_label.textRendererProperties.textFormat = ConstTextFormat.viptextformatblack;
			addChild(_label);
		}
		
		override protected function draw():void
		{
			super.draw();
			
			if(data == null)
				return;
			
			var isAllInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(!isAllInvalid)
				return;
			
			_label.text = String(data.text);
		}
		
	}
}