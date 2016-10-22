package SJ.Game.fuben
{
	import SJ.Game.player.CJPlayerData;
	import SJ.Game.player.CJPlayerNpc;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	
	import starling.animation.Juggler;
	/**
	 *  副本关卡中的武将，处理死亡及复活等逻辑
	 * @author yongjun
	 * 
	 */	
	public class CJFubenPlayerNpc extends CJPlayerNpc
	{
		private var _fuhuoBtn:SImage
		private var _isLive:Boolean
		public function CJFubenPlayerNpc(data:CJPlayerData, jugger:Juggler, async:Boolean=true)
		{
			super(data, jugger, async);
			_init();
		}
		
		private function _init():void
		{
			//复活按钮
			_fuhuoBtn = new SImage(SApplication.assets.getTexture("fuben_fuhuo_dianjifuhuo"));
			_fuhuoBtn.x = -50;
			_fuhuoBtn.y = -5;
			_fuhuoBtn.touchable = false;
			_fuhuoBtn.visible = false;
			this._PlayerTitleLayer.addChild(_fuhuoBtn)
			_isLive = true;
		}
		
		/**
		 * 死亡 
		 * 
		 */		
		public function toDead():void
		{
			super.idle();
			this._animsNode.alpha = 0.5;
			this._fuhuoBtn.visible = true;
			_isLive = false;
		}
		/**
		 * 复活 
		 * 
		 */
		public function relive():void
		{
			super.idle();
			this._animsNode.alpha = 1;
			this._fuhuoBtn.visible = false
			_isLive = true;
		}
		/**
		 * 是否活着的 
		 * @return 
		 * 
		 */		
		public function get isLive():Boolean
		{
			return this._isLive
		}
	}
}