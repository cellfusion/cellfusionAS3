package sample.video.ui 
{
	import flash.display.Sprite;

	/**
	 * @author Mk-10:cellfusion
	 */
	public class PlayButton extends Sprite 
	{
		public function PlayButton()
		{
			graphics.beginFill(0xFFFFFF);
			graphics.moveTo(0, 0);
			graphics.lineTo(9, 2.5);			graphics.lineTo(0, 5);			graphics.lineTo(0, 0);
			graphics.endFill();
		}
	}
}
