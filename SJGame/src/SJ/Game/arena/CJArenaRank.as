package SJ.Game.arena
{
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	
	import starling.events.Event;
	
	public class CJArenaRank extends SLayer
	{
		private var _rankValueLabel:Label
		private var _pageValueLabel:Label
		private var _itemList:Vector.<CJArenaRankItem>
		private var _totalPage:int
		private var _currentPage:int
		private var _perPageNum:int = 8
		private var _data:Array
		private var _rightpagebtn:Button
		private var _leftpagebtn:Button 
		public function CJArenaRank()
		{
			super();
			_init();
		}
		
		private function _init():void
		{
			this.setSize(350,238)
			_itemList = new Vector.<CJArenaRankItem>
			var bg:Scale9Textures = new Scale9Textures(SApplication.assets.getTexture("common_tankuangdi"),new Rectangle(19,19,1,1))	
			var img:Scale9Image = new Scale9Image(bg);
			img.width = 349
			img.height = 237
			this.addChild(img)
			
			var frame:Scale9Textures = new Scale9Textures(SApplication.assets.getTexture("common_tankuangwenzidi"),new Rectangle(11,11,2,2));
			var frameimg:Scale9Image = new Scale9Image(frame)
			frameimg.width = 339
			frameimg.height = 184
			frameimg.x = 6
			frameimg.y = 23
			this.addChild(frameimg)
			
			var btn:Button = new Button();
			btn.defaultSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			btn.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
			btn.addEventListener(Event.TRIGGERED , this._closePanel);
			btn.x = 326;
			btn.y = -18;
			this.addChild(btn);

			var xian1:SImage = new SImage(SApplication.assets.getTexture("jingjichang_jingjibangfengexian"));
			xian1.x = 85
			xian1.y = 23
			this.addChild(xian1)
				
			var xian2:SImage = new SImage(SApplication.assets.getTexture("jingjichang_jingjibangfengexian"));
			xian2.x = 177
			xian2.y = 23
			this.addChild(xian2)
				
			var xian3:SImage = new SImage(SApplication.assets.getTexture("jingjichang_jingjibangfengexian"));
			xian3.x = 258
			xian3.y = 23
			this.addChild(xian3)
			
			var fengexian:SImage = new SImage(SApplication.assets.getTexture("common_tankuangbiaotouzhuangshixian"))
			fengexian.x = 40;
			fengexian.y = 13
			this.addChild(fengexian)
				
			var fengexian2:SImage = new SImage(SApplication.assets.getTexture("common_tankuangbiaotouzhuangshixian"))
			fengexian2.scaleX = -1
			fengexian2.x = 301;
			fengexian2.y = 13
			this.addChild(fengexian2)
				
			var pagebg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_fanyeyemawenzidi"),new Rectangle(8,8,2,2)))	
			pagebg.width = 59
			pagebg.height = 17
			pagebg.x = 144
			pagebg.y = 213
			this.addChild(pagebg)
//			var leftxian:SImage = new SImage(SApplication.assets.getTexture("common_xiannew"))
				
			var rankTitleText:Label = new Label
			rankTitleText.textRendererProperties.textFormat = ConstTextFormat.arenaranktitle
			rankTitleText.text = CJLang("ARENA_JINGJIBANG")
			rankTitleText.x = 144;
			rankTitleText.y = 6
			this.addChild(rankTitleText);
			
			var rankName:Label = new Label
			rankName.textRendererProperties.textFormat = ConstTextFormat.arenaranksmalltitle
			rankName.text = CJLang("ARENA_PAIMING");
			rankName.x = 33
			rankName.y = 28
			this.addChild(rankName);
			
			var playerName:Label = new Label
			playerName.textRendererProperties.textFormat = ConstTextFormat.arenaranksmalltitle
			playerName.text = CJLang("ARENA_PLAYERNAME");
			playerName.x = 116
			playerName.y = 28
			this.addChild(playerName)
			
			var rankName2:Label = new Label
			rankName2.textRendererProperties.textFormat = ConstTextFormat.arenaranksmalltitle
			rankName2.text = CJLang("ARENA_RANK")
			rankName2.x = 202
			rankName2.y = 28
			this.addChild(rankName2)
				
			var totalBattleLevel:Label = new Label
			totalBattleLevel.textRendererProperties.textFormat = ConstTextFormat.arenaranksmalltitle
			totalBattleLevel.text = CJLang("ARENA_TOTALBATTLE")
			totalBattleLevel.x = 277
			totalBattleLevel.y = 28
			this.addChild(totalBattleLevel)
				
			var myRankText:Label = new Label
			myRankText.textRendererProperties.textFormat = ConstTextFormat.arenamyrank
			myRankText.text = CJLang("ARENA_MYRANK_TEXT")
			myRankText.x = 9
			myRankText.y = 216
			this.addChild(myRankText)
				
			_rankValueLabel = new Label
			_rankValueLabel.textRendererProperties.textFormat = ConstTextFormat.arenarankwhite
			_rankValueLabel.x = 59
			_rankValueLabel.y = 216
			this.addChild(_rankValueLabel)
				
			_pageValueLabel = new Label
			_pageValueLabel.textRendererProperties.textFormat = ConstTextFormat.arenarankwhite
			_pageValueLabel.x = 161
			_pageValueLabel.y = 213
			this.addChild(_pageValueLabel)
				
			_rightpagebtn = new Button
			_rightpagebtn.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeright01"));
			_rightpagebtn.x = 213
			_rightpagebtn.y = 205
			_rightpagebtn.scaleX = _rightpagebtn.scaleY = 0.7
			this.addChild(_rightpagebtn)
				
			_leftpagebtn = new Button
			_leftpagebtn.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeright01"));
			_leftpagebtn.x = 135
			_leftpagebtn.y = 205
			_leftpagebtn.scaleX = -0.7
			_leftpagebtn.scaleY = 0.7
			this.addChild(_leftpagebtn)
				
			for(var i:int = 0;i<this._perPageNum;i++)
			{
				var item:CJArenaRankItem = new CJArenaRankItem
				item.x = 6
				item.y = 50 + i*(19)
				item.visible = false;
				this.addChild(item)
				this._itemList.push(item);
			}
			
			_rightpagebtn.addEventListener(Event.TRIGGERED,pageHandler);
			_leftpagebtn.addEventListener(Event.TRIGGERED,pageHandler);
		}
		
		private function pageHandler(e:Event):void
		{
			var page:int = this._currentPage;
			if(e.currentTarget == this._rightpagebtn)
			{
				page++;
			}
			if(e.currentTarget == this._leftpagebtn)
			{
				page--;
			}
			if(page>this._totalPage)
			{
				page = this._totalPage;
			}
			if(page<1)
			{
				page =1;
			}
			if(page == this._currentPage)return;
			_currentPage = page;
			_pageValueLabel.text = String(this._currentPage)+"/"+String(this._totalPage)
			var data:Array = getDataByPage(this._currentPage);
			this.applayData(data)
		}
		
		public function updateData(data:Array):void
		{
			_data = data
			_currentPage = 1;
			var myrankid:int = this.getMyRank(data);
			var ranktext:String = String(myrankid);
			if (myrankid == 0)
			{
				ranktext = CJLang("AREBA_RANK_OUTRANK");
			}
			_rankValueLabel.text = ranktext;
			this._totalPage = Math.ceil(_data.length/_perPageNum)
			_pageValueLabel.text = String(_currentPage)+"/"+String(this._totalPage)
			data = this.getDataByPage(1)
			applayData(data)
		}
		
		private function getMyRank(data:Array):int
		{
			var myuid:String = CJDataManager.o.DataOfAccounts.userID;
			var rankid:int = 0;
			for(var i:String in data)
			{
				if(data[i].uid == myuid)
				{
					rankid = int(data[i].rankid)
					break;
				}
			}
			return rankid;
		}
		
		private function getDataByPage(page:int):Array
		{
			var startIndex:int = (page-1)*this._perPageNum	
			var endIndex:int = page*this._perPageNum
			var data:Array = this._data.slice(startIndex,endIndex)
			return data
		}
		
		private function applayData(data:Array):void
		{
			var j:int = 0
			for(var i:int=0;i<this._perPageNum;i++)
			{
				if(data[i])
				{
					this._itemList[i].update(data[i])
					this._itemList[i].visible = true;
				}
				else
				{
					this._itemList[i].visible = false;
				}
			}
		}
		
		private function _closePanel(e:Event):void
		{
			this.removeFromParent(true);
		}
		
	}
}