package lib.engine.ui.uicontrols
{
	import flash.events.MouseEvent;
	
	import lib.engine.event.CEvent;
	import lib.engine.event.CEventVar;
	import lib.engine.resources.Resource;
	import lib.engine.ui.Manager.UIManager;
	import lib.engine.ui.impact.UI_Impact;
	import lib.engine.ui.impact.UI_Impact_Empty;
	import lib.engine.ui.impact.UI_Impact_fade_In;

	public class XDG_UI_Alert extends XDG_UI_Control
	{
		public static const NONE:uint= 0x0000;
		public static const YES:uint = 0x0001;
		public static const NO:uint = 0x0002;
		public static const OK:uint = 0x0004;
		public static const CANCEL:uint= 0x0008;
		public static const NONMODAL:uint = 0x8000;
		
		
		
		
		private var _layout:XDG_UI_Layout;
		private var _modal:Boolean;
		
		private var _btn_ok:XDG_UI_Button;
		private var _btn_cancel:XDG_UI_Button;
		private var _btn_yes:XDG_UI_Button;
		private var _btn_no:XDG_UI_Button;
		private var _label_txt:XDG_UI_Label;
		private var _label_title:XDG_UI_Label;
		private var _mc_icon:XDG_UI_MC;
		
		
		public var buttonFlags:uint = NONE;
		
		
//		public var defaultButtonFlag:uint = NONE;
		
		
		public var iconImages:String = "";
		/**
		 *  The text to display in this alert dialog box.
		 *
		 *  @default ""
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public var text:String = "";
		
		
		public var title:String ="";
		
		public function XDG_UI_Alert()
		{
			super();
		}
		/**
		 *  Static method that pops up the XDG_UI_Alert control. The XDG_UI_Alert control 
		 *  closes when you select a button in the control, or press the Escape key.
		 * 
		 *  @param text Text string that appears in the Alert control. 
		 *  This text is centered in the alert dialog box.
		 *
		 *  @param title Text string that appears in the title bar. 
		 *  This text is left justified.
		 *
		 *  @param flags Which buttons to place in the Alert control.
		 *  Valid values are <code>XDG_UI_Alert.OK</code>, <code>XDG_UI_Alert.CANCEL</code>,
		 *  <code>XDG_UI_Alert.YES</code>, and <code>XDG_UI_Alert.NO</code>.
		 *  The default value is <code>XDG_UI_Alert.OK</code>.
		 *  Use the bitwise OR operator to display more than one button. 
		 *  For example, passing <code>(XDG_UI_Alert.YES | XDG_UI_Alert.NO)</code>
		 *  displays Yes and No buttons.
		 *  Regardless of the order that you specify buttons,
		 *  they always appear in the following order from left to right:
		 *  OK, Yes, No, Cancel.
		 *
		 *  @param parent Object upon which the XDG_UI_Alert control centers itself.
		 *
		 *  @param closeHandler Event handler that is called when any button
		 *  on the Alert control is pressed.
		 *  The event object passed to this handler is an instance of CloseEvent;
		 *  the <code>detail</code> property of this object contains the value
		 *  <code>XDG_UI_Alert.OK</code>, <code>XDG_UI_Alert.CANCEL</code>,
		 *  <code>XDG_UI_Alert.YES</code>, or <code>XDG_UI_Alert.NO</code>.
		 *
		 *  @param iconClass Class of the icon that is placed to the left
		 *  of the text in the Alert control.
		 *
		 *  @param defaultButtonFlag A bitflag that specifies the default button.
		 *  You can specify one and only one of
		 *  <code>XDG_UI_Alert.OK</code>, <code>XDG_UI_Alert.CANCEL</code>,
		 *  <code>XDG_UI_Alert.YES</code>, or <code>XDG_UI_Alert.NO</code>.
		 *  The default value is <code>XDG_UI_Alert.OK</code>.
		 *  Pressing the Enter key triggers the default button
		 *  just as if you clicked it. Pressing Escape triggers the Cancel
		 *  or No button just as if you selected it.
		 *
		 *  @param iconImages Class of the icon that is placed to the left
		 *  of the text in the Alert control. 
		 * 
		 * 	@param iconImages Class of the icon that is placed to the left
		 *  of the text in the Alert control. 
		 *  @return A reference to the XDG_UI_Alert control. 
		 *
		 *  @see CEvent
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function show(layoutResource:Resource,
									text:String = "", title:String = "",
									flags:uint = 0x4 /* Alert.OK */, 
									closeHandler:Function = null, 
									iconImages:String = "", 
									lefttime:int = -1
									):XDG_UI_Alert
		{
			
			var _modal:Boolean = (flags & XDG_UI_Alert.NONMODAL) ? false : true;
			
			var alert:XDG_UI_Alert = new XDG_UI_Alert();
			alert._modal = _modal;
			
			
			if (flags & XDG_UI_Alert.OK||
				flags & XDG_UI_Alert.CANCEL ||
				flags & XDG_UI_Alert.YES ||
				flags & XDG_UI_Alert.NO)
			{
				alert.buttonFlags = flags;
			}
			
//			if (defaultButtonFlag == XDG_UI_Alert.OK ||
//				defaultButtonFlag == XDG_UI_Alert.CANCEL ||
//				defaultButtonFlag == XDG_UI_Alert.YES ||
//				defaultButtonFlag == XDG_UI_Alert.NO)
//			{
//				alert.defaultButtonFlag = defaultButtonFlag;
//			}
			
			alert.text = text;
			alert.title = title;
			alert.iconImages = iconImages;
			
			
			alert._loadlayoutResource(layoutResource);
			
			if (closeHandler != null)
				alert.addEventListener(CEventVar.E_UI_ALERT_CLOSE, closeHandler);
			
			if(lefttime > 0 )
			{
				alert.autodelete(lefttime);
				
			}
			return alert;
			
		}
		
		
		private function _loadlayoutResource(mRes:Resource):void
		{
			this._layout = new XDG_UI_Layout();
			this._layout.Load(mRes.value,_loadedlayoutComplete);
			this._layout.CanMove = false;
			this._layout.Modal = _modal;
			this._layout.foucsEffect = false;
			UIManager.o.addLayout(_layout);
			
			_layout.addEventListener(MouseEvent.CLICK,_onMouseClick);
			
			
			var mwitdh:int = UIManager.o.worldsize.x;
			var mheight:int = UIManager.o.worldsize.y;
			
			var lwitdh:int = this._layout.width;
			var lheight:int = this._layout.height;
			
			
			this._layout.x = (mwitdh - lwitdh)/2;
			this._layout.y = (mheight - lheight)/2;
			
			_layout.Show();
//			_layout.BringTofront();
			
		}
		
		private function _loadedlayoutComplete(l:XDG_UI_Layout):void
		{
			_btn_ok = l.findChild("ok");
			_btn_ok.visible = false;
			_btn_cancel = l.findChild("cancel");
			_btn_cancel.visible = false;
			_btn_yes = l.findChild("yes");
			_btn_yes.visible = false;
			_btn_no = l.findChild("no");
			_btn_no.visible = false;
			
			_label_txt = l.findChild("txt");
			_label_title = l.findChild("title");
			
			_mc_icon = l.findChild("icon");
			_mc_icon.visible = false;
			
			_createChildren();
			
		}
		
		private function _createChildren():void
		{
			if (buttonFlags & XDG_UI_Alert.OK)
			{
				_btn_ok.visible = true;
			}
			
			if (buttonFlags & XDG_UI_Alert.YES)
			{
				_btn_yes.visible = true;
			}
			
			if (buttonFlags & XDG_UI_Alert.NO)
			{
				_btn_no.visible = true;
			}
			
			if (buttonFlags & XDG_UI_Alert.CANCEL)
			{
				_btn_cancel.visible = true;
			}
			
			_label_txt.SetProperty("text",text);
			_label_title.SetProperty("text",title);
			
			
			if(iconImages != "")
			{
				_mc_icon.SetProperty("image",iconImages);
				_mc_icon.visible = true;
			}

		}
		
		private function _onMouseClick(e:MouseEvent):void
		{
			if(e.target is XDG_UI_Button)
			{
				removeAlert(e.target.name);
				
			}
		}
		
		
		private function removeAlert(buttonPressed:String):void
		{
			if(!_layout.visible)
				return;
			_layout.removeself();

			var closeEvent:CEvent = new CEvent(CEventVar.E_UI_ALERT_CLOSE);
			if (buttonPressed.toLocaleUpperCase() == "YES")
				closeEvent.ext = XDG_UI_Alert.YES;
			else if (buttonPressed.toLocaleUpperCase() == "NO")
				closeEvent.ext = XDG_UI_Alert.NO;
			else if (buttonPressed.toLocaleUpperCase() == "OK")
				closeEvent.ext = XDG_UI_Alert.OK;
			else if (buttonPressed.toLocaleUpperCase() == "CANCEL")
				closeEvent.ext = XDG_UI_Alert.CANCEL;
			this.dispatchEvent(closeEvent);
			
			
		}
		
		private function autodelete(lefttime:int):void
		{
			var impact:UI_Impact = new UI_Impact_Empty();
			impact.lefttime = lefttime;
			impact.addEventListener(CEventVar.E_UI_IMPACT_END,
				function e(e:CEvent):void
				{
					var impactfade:UI_Impact = new UI_Impact_fade_In(500,1,0);
					impactfade.addEventListener(CEventVar.E_UI_IMPACT_END,
					function e(e:CEvent):void
					{
						removeAlert("YES");
					});
					e.ext.manager.AddImpact(impactfade);
				});
			
			_layout.alpha = 1;
			_layout.impact.AddImpact(impact);
		}
		
	}
}