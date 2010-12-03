package jp.cellfusion.ui.video.ui
{
	import jp.cellfusion.events.VideoEvent;
	import jp.cellfusion.ui.button.ToggleButton;
	import jp.cellfusion.ui.video.IVideoPlayer;

	/**	 * @author Mk-10:cellfusion	 */
	public class MuteButtonBase extends ToggleButton implements IMuteButton, IControllerParts
	{
		protected var _player:IVideoPlayer;
		private var _prevVolume:Number;

		public function MuteButtonBase(invisible:Boolean = true)
		{
			super(invisible);
		}


		override public function atClick():void
		{
			if (_current == onButton) {
				_prevVolume = _player.volume;
				_player.volume = 0;
			} else {
				_player.volume = _prevVolume;
			}
			
			super.atClick();
			enabled = true;
		}

		public function initialize(player:IVideoPlayer):void
		{
			_player = player;
			_player.addEventListener(VideoEvent.VOLUME_CHANGED, volumeChanged);
			buttonMode = true;
		}

		protected function volumeChanged(event:VideoEvent):void
		{
		}

		public function finalize():void
		{
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