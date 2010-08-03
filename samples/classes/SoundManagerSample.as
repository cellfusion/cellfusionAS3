package  
{
	import jp.cellfusion.sound.ISoundObject;
	import jp.cellfusion.sound.ExternalSound;
	import jp.cellfusion.sound.SoundManager2;
	import jp.cellfusion.ui.button.LabelButton;
	import jp.cellfusion.ui.video.VideoPlayer;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public class SoundManagerSample extends Sprite 
	{
		private var _muteButton:LabelButton;
		private var _unmuteButton:LabelButton;
		private var _playButton:LabelButton;
		private var _stopButton:LabelButton;
		private var _video:VideoPlayer;
		private var _videoPlayButton:LabelButton;
		private var _videoStopButton:LabelButton;
		private var _pauseButton:LabelButton;
		private var _resumeButton:LabelButton;
		private var _sampleSo:ISoundObject;

		public function SoundManagerSample()
		{
			_muteButton = new LabelButton("mute", 100, 20);
			_muteButton.addEventListener(MouseEvent.CLICK, muteClick);
			addChild(_muteButton);
			
			_unmuteButton = new LabelButton("unmute", 100, 20);
			_unmuteButton.x = 110;
			_unmuteButton.addEventListener(MouseEvent.CLICK, unmuteClick);
			addChild(_unmuteButton);
			
			_playButton = new LabelButton("bgmPlay", 100, 20);
			_playButton.y = 60;
			_playButton.addEventListener(MouseEvent.CLICK, playClick);
			addChild(_playButton);
			
			_stopButton = new LabelButton("bgmStop", 100, 20);
			_stopButton.y = 90;
			_stopButton.addEventListener(MouseEvent.CLICK, stopClick);
			addChild(_stopButton);
			
			_pauseButton = new LabelButton("bgmPause", 100, 20);
			_pauseButton.y = 120;
			_pauseButton.addEventListener(MouseEvent.CLICK, pauseClick);
			addChild(_pauseButton);
			
			_resumeButton = new LabelButton("bgmResume", 100, 20);
			_resumeButton.y = 150;
			_resumeButton.addEventListener(MouseEvent.CLICK, resumeClick);
			addChild(_resumeButton);
			
			// Video
			_video = new VideoPlayer("videoSample", 640, 480);
			_video.load(new URLRequest("sample.flv"));
			
			_videoPlayButton = new LabelButton("videoPlay", 100, 20);
			_videoPlayButton.x = 110;
			_videoPlayButton.y = 60;
			_videoPlayButton.addEventListener(MouseEvent.CLICK, videoPlayClick);
			addChild(_videoPlayButton);
			
			_videoStopButton = new LabelButton("videoStop", 100, 20);
			_videoStopButton.x = 110;
			_videoStopButton.y = 90;
			_videoStopButton.addEventListener(MouseEvent.CLICK, videoStopClick);
			addChild(_videoStopButton);
			
			_sampleSo = SoundManager2.instance.add(new ExternalSound(new URLRequest("sample.mp3")), "sampleExternalSound");
		}

		private function resumeClick(event:MouseEvent):void 
		{
			SoundManager2.instance.getSound("sampleExternalSound").resume();
		}

		private function pauseClick(event:MouseEvent):void 
		{
			SoundManager2.instance.getSound("sampleExternalSound").pause();
		}

		private function videoStopClick(event:MouseEvent):void 
		{
			_video.stop();
		}

		private function videoPlayClick(event:MouseEvent):void 
		{
			_video.play();
		}

		private function stopClick(event:MouseEvent):void 
		{
			SoundManager2.instance.getSound("sampleExternalSound").stop();
		}

		private function playClick(event:MouseEvent):void 
		{
			SoundManager2.instance.getSound("sampleExternalSound").play();
		}

		private function unmuteClick(event:MouseEvent):void 
		{
			SoundManager2.instance.unmute(true);
		}

		private function muteClick(event:MouseEvent):void 
		{
			SoundManager2.instance.mute(true);
		}
	}
}
