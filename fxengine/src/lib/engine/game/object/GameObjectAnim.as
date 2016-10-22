package lib.engine.game.object
{
	import lib.engine.game.data.anim.GameData_Anim;
	import lib.engine.game.data.anim.GameData_AnimGroup;
	import lib.engine.utils.functions.Assert;
	
	/**
	 * 动画类 
	 * @author caihua
	 * 
	 */
	public class GameObjectAnim extends GameObjectAnimBase
	{
		private var _animData:GameData_AnimGroup;
		private var _StartFrame:int = 0;
		/**
		 * 默认播放影片 
		 */
//		private var _defautAnim:String = "";
		public function GameObjectAnim()
		{
			super();
		}
		
		
		/**
		 * 加载动画文件 
		 * @param animdata
		 * @param defautAnim
		 * 
		 */
		public function load(animdata:GameData_AnimGroup,defautAnim:String = "",startframe:int = 0):void
		{
			_animData = animdata;
			if(defautAnim == "")
			{
				return;
			}
			
			Play(defautAnim,startframe);
		}
		
		private function _loadResComplete(Groupdata:GameData_AnimGroup,animData:GameData_Anim):void
		{
			if(animData != null)
			{
				_Play(animData,_StartFrame);
			}
		}
		
		
		/**
		 * 播放制定名称影片 
		 * @param animName
		 * @param startframe 起始帧
		 */
		public function Play(animName:String,startframe:int = 0):void
		{
			Assert(_animData != null,"动画播放错误,没有设置动画数据");
			Assert(animName != "","要播放的动画名称为空!");
			if(animName == "")
			{
				return;
			}
			var mGameData_Anim:GameData_Anim = _animData.getAnimData(animName);
			if(mGameData_Anim != null)
			{
				this.Reset();
				_StartFrame = startframe;
				this.fps = mGameData_Anim.fps;
				this.loop = mGameData_Anim.loop;
			}
			//资源还没有缓存完成,则转换为默认播放影片
			if(!_animData.BuildCache(animName,_loadResComplete))
			{
				return;
			}
			
			_Play(mGameData_Anim,_StartFrame);
			
			
		}
		
		protected function _Play(mGameData:GameData_Anim,startframe:int = 0):void
		{
			this.Reset();
			for(var i:int = 0;i<mGameData.getCache().length;i++)
			{
				this.addFrameImage(mGameData.getCache()[i]);
			}
			this.gotoAndPlay(startframe);
		}
	}
}
	
