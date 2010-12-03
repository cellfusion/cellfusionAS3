package jp.cellfusion.ui.button 
{
	import flash.events.MouseEvent;
	import jp.cellfusion.events.ButtonEvent;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public class DragButton extends MovieClipButton 
	{
		public function DragButton(up:String = 'up', over:String = 'over', disable:String = 'disable')
		{
			super(up, over, disable);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}

		private function mouseDownHandler(event:MouseEvent):void 
		{
			if (enabled) {
				atDragReady();
				dispatchEvent(new ButtonEvent(ButtonEvent.DRAG_READY));
				addEventListener(MouseEvent.MOUSE_MOVE, dragStart);
			}
		}

		public function atDragReady():void 
		{
		}

		private function dragStart(event:MouseEvent):void 
		{
			removeEventListener(MouseEvent.MOUSE_MOVE, dragStart);
			
			if (enabled) {
				atDragStart();
				dispatchEvent(new ButtonEvent(ButtonEvent.DRAG_START));
			}
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, dragProgress);
			stage.addEventListener(MouseEvent.MOUSE_UP, dragComplete);
		}

		public function atDragStart():void 
		{
		}

		private function dragProgress(event:MouseEvent):void 
		{
			if (enabled) {
				atDragProgress();
				dispatchEvent(new ButtonEvent(ButtonEvent.DRAG_PROGRESS));
			}
		}

		public function atDragProgress():void 
		{
		}

		private function dragComplete(event:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragProgress);
			stage.removeEventListener(MouseEvent.MOUSE_UP, dragComplete);
			if (enabled) {
				atDragComplete();
				dispatchEvent(new ButtonEvent(ButtonEvent.DRAG_COMPLETE));
			}
		}

		public function atDragComplete():void 
		{
		}
	}
}
