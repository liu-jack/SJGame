package fxengine.game.animation
{
	import flash.utils.Dictionary;
	
	import fxengine.game.node.FSpriteFrame;

	public class FAnimationFrame
	{
		public function FAnimationFrame()
		{
		}
		
		
		private var _spriteFrame:FSpriteFrame;

		public function get spriteFrame():FSpriteFrame
		{
			return _spriteFrame;
		}

		public function set spriteFrame(value:FSpriteFrame):void
		{
			_spriteFrame = value;
		}

		
		private var _delayUnits:Number;

		public function get delayUnits():Number
		{
			return _delayUnits;
		}

		public function set delayUnits(value:Number):void
		{
			_delayUnits = value;
		}

		
		private var _userinfo:Dictionary;

		public function get userinfo():Dictionary
		{
			return _userinfo;
		}

		public function set userinfo(value:Dictionary):void
		{
			_userinfo = value;
		}
		
		public function initWithSpriteFrame(spriteFrame:FSpriteFrame,delayUnits:Number,userInfo:Dictionary):FAnimationFrame
		{
			this.spriteFrame = spriteFrame;
			this.delayUnits =delayUnits;
			this.userinfo = userInfo;
			return this;
		}

	}
}