package sample.video.ui 
{
	import flash.display.Sprite;

	/**
	 * @author Mk-10:cellfusion
	 */
	public class BackButton extends Sprite 
	{
		public function BackButton()
		{
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 1, 1, 5);
			graphics.moveTo(0.5, 3.5);
			graphics.lineTo(7, 0.5);
			graphics.lineTo(7, 6.5);
			graphics.lineTo(0.5, 3.5);
			graphics.endFill();
		}
	}
}
