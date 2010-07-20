package jp.cellfusion.ui.events 
{
	import flash.events.MouseEvent;

	/**
	 * @author Mk-10:cellfusion
	 */
	public class ButtonEvent extends MouseEvent 
	{
		public static const CLICK:String = "buttonClick";		public static const ROLL_OVER:String = "buttonRollOver";		public static const ROLL_OUT:String = "buttonRollOut";
		public static const DRAG_START:String = "buttonDragStart";
		public static const DRAG_PROGRESS:String = "buttonDragProgress";
		public static const DRAG_COMPLETE:String = "buttonDragComplete";
		public static const DRAG_READY:String = "buttonDragReady";

		public function ButtonEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
