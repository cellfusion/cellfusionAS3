package sample.video.ui 
{
	import mx.core.BitmapAsset;

	import flash.display.Sprite;

	/**
	 * @author Mk-10:cellfusion
	 */
	public class Controller extends Sprite 
	{
    	[Embed(source="../../../../../img/bg_controller.png")]
    	private var imgBgController:Class;
		
		public function Controller()
		{
			graphics.beginFill(0x4F4F4f);
			graphics.drawRect(0, 0, 640, 1);
			graphics.endFill();
			
			var bg:BitmapAsset = BitmapAsset(new imgBgController());
			bg.y = 1;
			bg.width = 640;
			
			addChild(bg);
		}
	}
}
