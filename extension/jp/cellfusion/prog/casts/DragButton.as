package jp.cellfusion.prog.casts 
{
	import jp.cellfusion.ui.events.ButtonEvent;

	import flash.events.MouseEvent;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public class DragButton extends SpriteButton 
	{
		public function DragButton(initObject:Object = null)
		{
			super(initObject);
			addEventListener(MouseEvent.MOUSE_DOWN, dragStart);
		}

		final private function mouseDownHandler(event:MouseEvent):void 
		{
			if (enabled) {
				atDragReady();
				dispatchEvent(new ButtonEvent(ButtonEvent.DRAG_READY));
				addEventListener(MouseEvent.MOUSE_MOVE, dragStart);
			}
		}

		protected function atDragReady():void 
		{
		}

		final private function dragStart(event:MouseEvent):void 
		{
			//			removeEventListener(MouseEvent.MOUSE_MOVE, dragStart);
			if (enabled) {
				atDragStart();
				dispatchEvent(new ButtonEvent(ButtonEvent.DRAG_START));
				stage.addEventListener(MouseEvent.MOUSE_MOVE, dragProgress);
				stage.addEventListener(MouseEvent.MOUSE_UP, dragComplete);
			}
		}

		protected function atDragStart():void 
		{
		}

		final private function dragProgress(event:MouseEvent):void 
		{
			if (enabled) {
				atDragProgress();
				dispatchEvent(new ButtonEvent(ButtonEvent.DRAG_PROGRESS));
			}
		}

		protected function atDragProgress():void 
		{
		}

		final private function dragComplete(event:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragProgress);
			stage.removeEventListener(MouseEvent.MOUSE_UP, dragComplete);
			if (enabled) {
				atDragComplete();
				dispatchEvent(new ButtonEvent(ButtonEvent.DRAG_COMPLETE));
			}
		}

		protected function atDragComplete():void 
		{
		}
	}
}
