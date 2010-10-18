package  
{
	import jp.cellfusion.logger.Logger;
	import flash.events.Event;
	import jp.cellfusion.sound.ISoundObject;
	import jp.cellfusion.sound.ExternalSound;
	import jp.cellfusion.sound.SoundManager;
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
		private var _playButton:LabelButton;
		private var _stopButton:LabelButton;
		private var _video:VideoPlayer;
		private var _videoPlayButton:LabelButton;
		private var _videoStopButton:LabelButton;
		private var _pauseButton:LabelButton;
		private var _resumeButton:LabelButton;
		private var _sampleSo:ISoundObject;
		private var _volumeDownButton:LabelButton;
		private var _volumeUpButton:LabelButton;
		private var _videoMuteButton:LabelButton;
		private var _videoSoloButton:LabelButton;
		private var _bgmMuteButton:LabelButton;
		private var _bgmSoloButton:LabelButton;

		public function SoundManagerSample()
		{
			Logger.initialize();
			
			_muteButton = new LabelButton("mute", 100, 20);
			_muteButton.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {
				SoundManager.instance.mute();
			});
			addChild(_muteButton);
			
			_volumeDownButton = new LabelButton("volumeDown", 100, 20);
			_volumeDownButton.y = 30;
			_volumeDownButton.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {
				SoundManager.instance.volume = 0.5;
			});
			addChild(_volumeDownButton);
			
			_volumeUpButton = new LabelButton("volumeUp", 100, 20);
			_volumeUpButton.x = 110;
			_volumeUpButton.y = 30;
			_volumeUpButton.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {
				SoundManager.instance.volume = 1.0;
			});
			addChild(_volumeUpButton);
			
			_playButton = new LabelButton("bgmPlay", 100, 20);
			_playButton.y = 60;
			_playButton.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {
				addEventListener(Event.ENTER_FRAME, updateHandler);
				SoundManager.instance.getSound("sampleExternalSound").play();
			});
			addChild(_playButton);
			
			_stopButton = new LabelButton("bgmStop", 100, 20);
			_stopButton.y = 90;
			_stopButton.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {
				removeEventListener(Event.ENTER_FRAME, updateHandler);
				SoundManager.instance.getSound("sampleExternalSound").stop();
			});
			addChild(_stopButton);
			
			_pauseButton = new LabelButton("bgmPause", 100, 20);
			_pauseButton.y = 120;
			_pauseButton.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {
				SoundManager.instance.getSound("sampleExternalSound").pause();
			});
			addChild(_pauseButton);
			
			_bgmMuteButton = new LabelButton("bgmMute", 100, 20);
			_bgmMuteButton.y = 150;
			_bgmMuteButton.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {
				SoundManager.instance.getSound("sampleExternalSound").mute();
			});
			addChild(_bgmMuteButton);
			
			_bgmSoloButton = new LabelButton("bgmSolo", 100, 20);
			_bgmSoloButton.y = 210;
			_bgmSoloButton.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {
				SoundManager.instance.getSound("sampleExternalSound").solo();
			});
			addChild(_bgmSoloButton);
			
			
			// Video
			_video = new VideoPlayer("videoSample", 640, 360);
			_video.load(new URLRequest("sample.flv"));
			_video.x = 220;
			_video.scaleX = _video.scaleY = 0.5;
			
			addChild(_video);
			
			_videoPlayButton = new LabelButton("videoPlay", 100, 20);
			_videoPlayButton.x = 110;
			_videoPlayButton.y = 60;
			_videoPlayButton.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {
				_video.play();
			});
			addChild(_videoPlayButton);
			
			_videoStopButton = new LabelButton("videoStop", 100, 20);
			_videoStopButton.x = 110;
			_videoStopButton.y = 90;
			_videoStopButton.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {
				_video.stop();
			});
			addChild(_videoStopButton);
			
			_videoMuteButton = new LabelButton("videoMute", 100, 20);
			_videoMuteButton.x = 110;
			_videoMuteButton.y = 120;
			_videoMuteButton.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {
				_video.sound.mute();
			});
			addChild(_videoMuteButton);
			
			_videoSoloButton = new LabelButton("videoSolo", 100, 20);
			_videoSoloButton.x = 110;
			_videoSoloButton.y = 180;
			_videoSoloButton.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {
				_video.sound.solo();
			});
			addChild(_videoSoloButton);
			
			_sampleSo = SoundManager.instance.add(new ExternalSound(new URLRequest("sample.mp3")), "sampleExternalSound");
		}

		private function updateHandler(event:Event):void
		{
			Logger.trace("time:" + SoundManager.instance.getSound("sampleExternalSound").position);
		}
	}
}
