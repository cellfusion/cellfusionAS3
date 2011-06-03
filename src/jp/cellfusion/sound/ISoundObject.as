package jp.cellfusion.sound
{
	import flash.media.SoundChannel;
	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public interface ISoundObject
	{
		function play(startTime:Number = 0, loops:int = 0):void;

		function stop():void;

		function mute(fade:Boolean = false, seconds:Number = 1, easing:Function = null):void;

		function solo(fade:Boolean = false, seconds:Number = 1, easing:Function = null):void;

		function pause():void;

		function destroy():void;

		function get volume():Number;

		function set volume(value:Number):void;

		function get isMute():Boolean;

		function get isSolo():Boolean;
		
		function get position():Number;
		
		function set atSoundComplete(value:Function):void;
<<<<<<< HEAD
		function set atFadeComplete(value:Function):void;
=======
>>>>>>> 1d9e0a7ce840b62f980d70748f4cbd26405e393a
	}
}
