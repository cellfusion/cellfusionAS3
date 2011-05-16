package jp.cellfusion.video
{
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import jp.cellfusion.ui.video.IVideoPlayer;
	import jp.cellfusion.ui.video.ui.IControllerParts;


	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 * FMS に接続するための VideoPlayer
	 */
	public class FMSVideoPlayer extends Sprite implements IVideoPlayer
	{
		public function FMSVideoPlayer()
		{
		}

		public function play(request:URLRequest = null, play:Boolean = false, start:Number = 0):void
		{
		}

		public function pause(temporary:Boolean = false):void
		{
		}

		public function stop():void
		{
		}

		public function resume(temporary:Boolean = false):void
		{
		}

		public function togglePause():void
		{
		}

		public function load(request:URLRequest):void
		{
		}

		public function seek(offset:Number):void
		{
		}

		public function addParts(parts:IControllerParts):void
		{
		}

		public function removeParts(parts:IControllerParts):void
		{
		}

		public function close():void
		{
		}

		public function get time():Number
		{
			return 0;
		}

		public function get duration():Number
		{
			return 0;
		}

		public function get bytesLoaded():Number
		{
			return 0;
		}

		public function get bytesTotal():Number
		{
			return 0;
		}

		public function get bufferLength():Number
		{
			return 0;
		}

		public function get bufferTime():Number
		{
			return 0;
		}

		public function get metadata():Object
		{
			return null;
		}

		public function get volume():Number
		{
			return 0;
		}

		public function set volume(offset:Number):void
		{
		}

		public function get autoRewind():Boolean
		{
			return false;
		}

		public function set autoRewind(value:Boolean):void
		{
		}

		public function get preferredHeight():Number
		{
			return 0;
		}

		public function get preferredWidth():Number
		{
			return 0;
		}

		public function get smoothing():Boolean
		{
			return false;
		}

		public function set smoothing(value:Boolean):void
		{
		}

		public function get isPlay():Boolean
		{
			return false;
		}

		public function get streming():Boolean
		{
			return false;
		}
	}
}
