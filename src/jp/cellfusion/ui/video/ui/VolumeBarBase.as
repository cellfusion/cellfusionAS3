package jp.cellfusion.ui.video.ui
{
	import jp.cellfusion.events.VideoEvent;
	import jp.cellfusion.ui.AbstractUI;
	import jp.cellfusion.ui.video.IVideoPlayer;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**	 * @author Mk-10:cellfusion	 */
	public class VolumeBarBase extends Sprite implements IVolumeBar
	{
		private var _player:IVideoPlayer;
		public var thumb:Sprite;
		public var progress:Sprite;
		public var track:Sprite;
		private var _dragStartX:Number;

		private function volumeChanged(event:VideoEvent):void
		{
			var maxWidth:Number = track.width - thumb.width;
			var volume:Number = _player.volume;
			progress.scaleX = volume;
			thumb.x = maxWidth * volume + track.x;
		}

		private function trackClick(event:MouseEvent):void
		{
			var x:Number = track.mouseX;
			x -= track.x;
			
			var maxWidth:Number = track.width - thumb.width;
			
			var p:Number = x / maxWidth;
			_player.volume = p;
			
			thumb.x = maxWidth * p;
			progress.scaleX = p;
		}

		private function thumbDragStart(event:MouseEvent):void
		{
			thumb.removeEventListener(MouseEvent.MOUSE_DOWN, thumbDragStart);
			_dragStartX = thumb.mouseX;

			thumb.addEventListener(Event.ENTER_FRAME, thumbDragProgress);
			AbstractUI._stage.addEventListener(MouseEvent.MOUSE_UP, thumbDragEnd);
		}

		private function thumbDragProgress(event:Event):void
		{
			var maxWidth:Number = track.width - thumb.width;
			
			var x:Number = mouseX + _dragStartX;
			thumb.x = Math.min(Math.max(0, x), maxWidth);
			
			var p:Number = (thumb.x - track.x) / maxWidth;
			_player.volume = p;
			progress.scaleX = p;
		}

		private function thumbDragEnd(event:MouseEvent):void
		{
			AbstractUI._stage.removeEventListener(MouseEvent.MOUSE_UP, thumbDragEnd);
			thumb.removeEventListener(Event.ENTER_FRAME, thumbDragProgress);

			var maxWidth:Number = track.width - thumb.width;
			
			var x:Number = mouseX + _dragStartX;
			thumb.x = Math.min(Math.max(0, x), maxWidth);
			
			var p:Number = (thumb.x - track.x) / maxWidth;
			_player.volume = p;
			progress.scaleX = p;
			
			thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbDragStart);
		}

		public function initialize(player:IVideoPlayer):void
		{
			_player = player;
			_player.addEventListener(VideoEvent.VOLUME_CHANGED, volumeChanged);
			thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbDragStart);
			track.addEventListener(MouseEvent.CLICK, trackClick);
			
			var maxWidth:Number = track.width - thumb.width;
			var volume:Number = _player.volume;
			progress.scaleX = volume;
			thumb.x = maxWidth * volume + track.x;
			
			thumb.buttonMode = true;
			track.buttonMode = true;
			progress.mouseEnabled = false;
		}

		public function finalize():void
		{
			thumb.removeEventListener(MouseEvent.MOUSE_DOWN, thumbDragStart);
			track.removeEventListener(MouseEvent.CLICK, trackClick);
			_player.removeEventListener(VideoEvent.VOLUME_CHANGED, volumeChanged);
			_player = null;
		}

		public function update():void
		{
			
		}

		public function reset():void
		{
		}
	}
}