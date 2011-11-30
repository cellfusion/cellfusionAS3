package jp.cellfusion.sound
{
	import flash.events.IEventDispatcher;
	import flash.media.Sound;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public interface ISoundObject extends IEventDispatcher
	{
		function play(startTime:Number = 0, loops:int = 0):void;

		function stop():void;

		function mute(fade:Boolean = false, seconds:Number = 1, easing:Function = null):void;

		function solo(fade:Boolean = false, seconds:Number = 1, easing:Function = null):void;
		
		function fade(volume:Number, seconds:Number, easing:Function):void;

		function pause():void;
		
		function resume():void;

		function close():void;

		function destroy():void;

		function seek(position:Number):void;
		
		function get sound():Sound;

		function get bytesLoaded():Number;

		function get bytesTotal():Number;

		function get volume():Number;

		function set volume(value:Number):void;

		function get isMute():Boolean;
		
		function get isSolo():Boolean;

		function get position():Number;

		function get length():Number;

		function set atSoundComplete(value:Function):void;

		function set atFadeComplete(value:Function):void;

		function get extra():Object;
	}
}
