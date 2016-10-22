package SJ.Game.controls
{
	import SJ.Common.Constants.ConstUtil;
	import SJ.Game.layer.CJLayerManager;
	
	import engine_starling.SApplicationConfig;
	import engine_starling.utils.STween;
	
	import feathers.controls.Label;
	
	import flash.text.TextFormat;
	
	import starling.animation.Transitions;
	import starling.core.Starling;

	/**
	 * 飘字动画工具
	 * author zhengzheng
	 * @param msg 要飘字的内容
	 * 
	 */		
	public function CJFlyWordsUtil(msg:String, flyTime:int = 1):void
	{
		if (ConstUtil.isFlyComplete || ConstUtil.isFirstFly )
		{
			ConstUtil.isFirstFly = false;
			var labFlyWords:Label = new Label();
			if (msg == null)
				return;
			labFlyWords.text = msg;
			labFlyWords.textRendererProperties.textFormat = new TextFormat( "Arial", 13, 0xFFFFFF);
			labFlyWords.width = msg.length * 14;
			labFlyWords.height = 18;
			labFlyWords.x = (SApplicationConfig.o.stageWidth - labFlyWords.width) / 2;
			labFlyWords.y = (SApplicationConfig.o.stageHeight - labFlyWords.height) / 2;
			var textTween:STween = new STween(labFlyWords,flyTime,Transitions.LINEAR);
			textTween.moveTo(labFlyWords.x,labFlyWords.y- 50);
			ConstUtil.isFlyComplete = false;
			textTween.onComplete = function():void
			{
				Starling.juggler.remove(textTween);
				labFlyWords.removeFromParent(true);
				ConstUtil.isFlyComplete = true;
			}
			CJLayerManager.o.addToModal(labFlyWords);
			Starling.juggler.add(textTween);
		}
	}
}