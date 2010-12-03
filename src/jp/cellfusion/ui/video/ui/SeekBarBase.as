package jp.cellfusion.ui.video.ui
{
	import jp.cellfusion.ui.AbstractUI;
	import jp.cellfusion.ui.video.IVideoPlayer;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**	 * @author Mk-10:cellfusion	 */
	public class SeekBarBase extends Sprite implements ISeekBar
	{
		public var thumb:Sprite;
		public var progress:Sprite;
		public var track:Sprite;
		protected var _player:IVideoPlayer;
		private var _dragStartX:Number;
		private var _isDrag:Boolean;

		public function initialize(player:IVideoPlayer):void
		{
			_player = player;
			
			thumb.buttonMode = true;
			track.buttonMode = true;
			progress.mouseEnabled = false;
			progress.mouseChildren = false;
			
			thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbDragStart);
			track.addEventListener(MouseEvent.CLICK, trackClick);
			
			_isDrag = false;
		}

		private function trackClick(event:MouseEvent):void
		{
			if (!_player.isPlay) {
				_player.play(null, true);
			}
			
			var maxWidth:Number = track.width - thumb.width;

			var x:Number = track.mouseX;
			x -= track.x;
			var p:Number = x / maxWidth;
			
			
			_player.seek(_player.duration * p);

			thumb.x = maxWidth * p;
			progress.scaleX = p;
			
			
		}

		private function thumbDragStart(event:MouseEvent):void
		{
			_isDrag = true;
			
			thumb.removeEventListener(MouseEvent.MOUSE_DOWN, thumbDragStart);
			_dragStartX = thumb.mouseX;
			thumb.addEventListener(Event.ENTER_FRAME, thumbDragProgress);
			AbstractUI._stage.addEventListener(MouseEvent.MOUSE_UP, thumbDragEnd);
			
			var bounds:Rectangle = new Rectangle(Math.ceil(track.x), thumb.y);
			bounds.bottom = thumb.y;
			bounds.width = Math.ceil(track.width - thumb.width);

			thumb.startDrag(false, bounds);
			
			if (!_player.isPlay) {
				_player.play(null, true);
			}
			_player.pause(true);
		}

		private function thumbDragProgress(event:Event):void
		{
			var maxWidth:Number = track.width - thumb.width;

			var p:Number = (thumb.x - track.x) / maxWidth;
			if (!_player.streming) {
				_player.seek(_player.duration * p);
			}
			progress.scaleX = p;
		}

		private function thumbDragEnd(event:MouseEvent):void
		{
			_isDrag = false;
			
			AbstractUI._stage.removeEventListener(MouseEvent.MOUSE_UP, thumbDragEnd);
			thumb.removeEventListener(Event.ENTER_FRAME, thumbDragProgress);
			
			thumb.stopDrag();

			var maxWidth:Number = track.width - thumb.width;

			var p:Number = (thumb.x - track.x) / maxWidth;
			_player.seek(_player.duration * p);
			progress.scaleX = p;

			_player.resume(true);

			thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbDragStart);
		}

		public function finalize():void
		{
			thumb.removeEventListener(MouseEvent.MOUSE_DOWN, thumbDragStart);
			track.removeEventListener(MouseEvent.CLICK, trackClick);
			_player = null;
		}

		public function update():void
		{
			if (_isDrag) {
				return;
			}
			
			var p:Number = _player.time / _player.duration;
			var l:Number = _player.bytesLoaded / _player.bytesTotal;
			var maxWidth:Number = track.width - thumb.width;
			
			thumb.x = maxWidth * p + track.x;
			progress.scaleX = p;
			track.scaleX = l;
		}

		public function reset():void
		{
			thumb.x = track.x;
			progress.scaleX = 0;
		}

		public function get isDrag():Boolean
		{
			return _isDrag;
		}
	}
}