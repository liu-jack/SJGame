package uiEditor.core
{
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	
	import starling.textures.Texture;
	
	public class AUIEControlPropertyLayer extends SLayer
	{
		public function AUIEControlPropertyLayer()
		{
			super();
		}
		private var _propertylist:List;
		public function editProperty(ctrl:FeathersControl,maskControls:AUIEControlMask):void
		{
			var extObject:Object = {editorctrl:ctrl,maskctrl:maskControls};
			var groceryList:ListCollection = new ListCollection(
				[
					{ text: "x", value: ctrl.x,ext:extObject},
					{ text: "y", value: ctrl.y,ext:extObject},
					{ text: "width", value:ctrl.width,ext:extObject},
					{ text: "height", value: ctrl.height,ext:extObject},
				]);
			
			_propertylist.dataProvider = groceryList;
		}
		override protected function draw():void
		{
			// TODO Auto Generated method stub
			super.draw();
		}
		
		override protected function initialize():void
		{
			// TODO Auto Generated method stub
			
			_propertylist = new List();
			_propertylist.y = 40;
			_propertylist.backgroundSkin = new SImage(Texture.fromColor(70,20,0x7FFFFF00),true);
			_propertylist.width = 70;
			_propertylist.height = 300;
			this.addChild( _propertylist );
			
//			var groceryList:ListCollection = new ListCollection(
//				[
//					{ text: "x", value: "1000"},
//					{ text: "y", value: "1000"},
//					{ text: "width", value:"1000"},
//					{ text: "heigth", value: "1000"},
//				]);
//			
//			_propertylist.dataProvider = groceryList;
			_propertylist.itemRendererFactory =function():IListItemRenderer
			{
				var renderer:AUIEControlPropertyItemRender = new AUIEControlPropertyItemRender();
				return renderer;
			}
			_propertylist.itemRendererProperties.labelField = "text";
			
//			_propertylist.itemRendererProperties.iconTextureField = "thumbnail";
			super.initialize();
		}
		
		
	}
}