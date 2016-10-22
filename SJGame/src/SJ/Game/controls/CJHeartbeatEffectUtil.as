package SJ.Game.controls
{
	import SJ.Game.layer.CJLayerManager;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.utils.STween;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.textures.Texture;
	
	/**
	 * 图片心跳动画效果
	 * @param imgName 图片的名称
	 * @param beatCount 跳动次数
	 * @param beatTime 跳动事件
	 */	
	public function CJHeartbeatEffectUtil(imgName:String, beatCount:int = 1, beatTime:Number = 1):void
	{
		var texture:Texture = SApplication.assets.getTexture(imgName);
		var image:SImage = new SImage(texture);
		image.width = texture.width;
		image.height = texture.height;
		image.pivotX = image.width / 2;
		image.pivotY = image.height / 2;
		CJLayerManager.o.addToModal(image);
		image.x = SApplicationConfig.o.stageWidth >> 1;
		image.y = SApplicationConfig.o.stageHeight >> 1;
		
		var perTime:Number = beatTime / (2 * beatCount);
		var tween:STween = new STween(image , perTime, Transitions.LINEAR);
		tween = _stweenMaker(image, true);
		Starling.juggler.add(tween);
		
		var tTween:STween = tween;
		for (var i:int = 0; i < 2 * beatCount - 1; ++i)
		{
			tTween.nextTween = _stweenMaker(image, Boolean(i % 2));
			tTween = tTween.nextTween as STween;
		}
		tTween.onComplete = function():void
		{
			Starling.juggler.remove(tween);
			
			if(image.parent)
			{
				image.removeFromParent(true);
			}
		};
		
		
		/**
		 * 生成放大缩小动画
		 * @param isBig true:放大动画,false:缩小动画
		 * @return STween
		 * 
		 */		
		function _stweenMaker(img:SImage, isBig:Boolean):STween
		{
			var stween:STween = new STween(img, 1/4, Transitions.LINEAR);
			
			if (isBig)
			{
				stween.animate("scaleX",2.0);
				stween.animate("scaleY",2.0);
			}
			else
			{
				stween.animate("scaleX",1.0);
				stween.animate("scaleY",1.0);
			}
			return stween;
		}
	}
}