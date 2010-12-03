package jp.cellfusion.ui.video{	import jp.cellfusion.ui.video.ui.IControllerParts;
	import flash.display.Sprite;	import flash.events.IEventDispatcher;	import flash.media.SoundTransform;	import flash.net.URLRequest;	/**	 * @author Mk-10:cellfusion	 * 	 */	public interface IVideoPlayer extends IEventDispatcher	{		/**		 * Video を再生する		 */		function play(request:URLRequest = null, play:Boolean = false):void;		/**		 * Video を停止する		 */		function pause(temporary:Boolean = false):void;		function stop():void;		function resume(temporary:Boolean = false):void;		function togglePause():void;		function load(request:URLRequest):void;		/**		 * Video を読み込む		 */
		function seek(offset:Number):void;

		function addParts(parts:IControllerParts):void;

		function removeParts(parts:IControllerParts):void;
		function close():void;		function get time():Number;		function get duration():Number;		function get bytesLoaded():Number;		function get bytesTotal():Number;		function get bufferLength():Number;		function get bufferTime():Number;		function get soundTransform():SoundTransform;		function get metadata():Object;		function get volume():Number;		function set volume(offset:Number):void;		function get autoRewind():Boolean;		function set autoRewind(value:Boolean):void;		function get preferredHeight():Number;		function get preferredWidth():Number;		function get smoothing():Boolean;

		function set smoothing(value:Boolean):void;

		function get isPlay():Boolean;				function get streming():Boolean;
	}}