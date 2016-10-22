/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package SJ.Game.layer
{
	import engine_starling.utils.STween;
	
	import flash.utils.Dictionary;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.display.Stage;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.ResizeEvent;

	/**
	 * Adds a display object as a pop-up above all content.
	 */
	public class CJLayerMaskManager
	{
		/**
		 * @private
		 */
		private static const POPUP_TO_OVERLAY:Dictionary = new Dictionary(true);
		
		/**
		 * A function that returns a display object to use as an overlay for
		 * modal pop-ups.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 * <pre>function():DisplayObject</pre>
		 */
		public static var overlayFactory:Function = defaultOverlayFactory;

		/**
		 * The default factory that creates overlays for modal pop-ups.
		 */
		public static function defaultOverlayFactory():DisplayObject
		{
			const quad:Quad = new Quad(100, 100, 0x000000);
			quad.alpha = 0.85;
			return quad;
		}

		/**
		 * @private
		 */
		protected static var popUps:Vector.<DisplayObject> = new <DisplayObject>[];
		
		/**
		 * Adds a pop-up to the container.
		 */
		public static function addTo(module:DisplayObject,displayCotainer:DisplayObjectContainer):void
		{
			const stage:Stage = Starling.current.stage;
			const overlay:DisplayObject = defaultOverlayFactory();
			overlay.width = stage.stageWidth;
			overlay.height = stage.stageHeight;
			displayCotainer.addChild(overlay);
			POPUP_TO_OVERLAY[module] = overlay;

			popUps.push(module);
			displayCotainer.addChild(module);
			
			//@caihua 淡入
			displayCotainer.alpha = 0.001;
			var tween :STween = new STween(displayCotainer , 0.5);
			tween.fadeTo(0.999);
			Starling.juggler.add(tween);
			tween.onComplete = function():void
			{
				displayCotainer.alpha = 1;
				Starling.juggler.remove(tween);
			};
			
			module.addEventListener(Event.REMOVED_FROM_STAGE, popUp_removedFromStageHandler);

			if(popUps.length == 1)
			{
				displayCotainer.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			}
			centerPopUp(module);
		}
		
		/**
		 * Removes a pop-up from the stage.
		 */
		public static function removePopUp(popUp:DisplayObject, dispose:Boolean = false):void
		{
			const index:int = popUps.indexOf(popUp);
			if(index < 0)
			{
				throw new ArgumentError("Display object is not a pop-up.");
			}
			popUp.removeFromParent(dispose);
		}

		/**
		 * Determines if a display object is a pop-up.
		 */
		public static function isPopUp(popUp:DisplayObject):Boolean
		{
			return popUps.indexOf(popUp) >= 0;
		}

		
		/**
		 * Centers a pop-up on the stage.
		 */
		public static function centerPopUp(popUp:DisplayObject):void
		{
			const stage:Stage = Starling.current.stage;
			popUp.x = (stage.stageWidth - popUp.width) / 2;
			popUp.y = (stage.stageHeight - popUp.height) / 2;
		}

		/**
		 * @private
		 */
		protected static function popUp_removedFromStageHandler(event:Event):void
		{
			const popUp:DisplayObject = DisplayObject(event.currentTarget);
			popUp.removeEventListener(Event.REMOVED_FROM_STAGE, popUp_removedFromStageHandler);
			const index:int = popUps.indexOf(popUp);
			popUps.splice(index, 1);
			
			const overlay:DisplayObject = DisplayObject(POPUP_TO_OVERLAY[popUp]);

			if(popUps.length == 0)
			{
				Starling.current.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			}
			
			//@caihua 淡出
			var tween :STween = new STween(popUp , 0.5);
			tween.fadeTo(0.001);
			Starling.juggler.add(tween);
			tween.onComplete = function():void
			{
				popUp.alpha = 1;
				Starling.juggler.remove(tween);
			};
			
			var tween1 :STween = new STween(overlay , 0.5);
			tween1.fadeTo(0.001);
			Starling.juggler.add(tween1);
			tween1.onComplete = function():void
			{
				
				if(overlay)
				{
					//fix peng.zhi 
					//不知道为什么要放到帧循环中
					overlay.removeFromParent(true);
					
					delete POPUP_TO_OVERLAY[popUp];
				}
				
				Starling.juggler.remove(tween1);
			};
		}

		/**
		 * @private
		 */
		protected static function stage_resizeHandler(event:ResizeEvent):void
		{
			const stage:Stage = Starling.current.stage;
			const popUpCount:int = popUps.length;
			for(var i:int = 0; i < popUpCount; i++)
			{
				var popUp:DisplayObject = popUps[i];
				var overlay:DisplayObject = DisplayObject(POPUP_TO_OVERLAY[popUp]);
				if(overlay)
				{
					overlay.width = stage.stageWidth;
					overlay.height = stage.stageHeight;
				}
			}
		}
	}
}