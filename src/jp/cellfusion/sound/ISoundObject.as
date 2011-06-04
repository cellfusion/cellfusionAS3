package jp.cellfusion.sound {
	import flash.media.SoundChannel;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public interface ISoundObject {
		function play(startTime : Number = 0, loops : int = 0) : void;

		function stop() : void;

		function mute(fade : Boolean = false, seconds : Number = 1, easing : Function = null) : void;

		function solo(fade : Boolean = false, seconds : Number = 1, easing : Function = null) : void;

		function pause() : void;

		function destroy() : void;

		function get volume() : Number;

		function set volume(value : Number) : void;

		function get isMute() : Boolean;

		function get isSolo() : Boolean;

		function get position() : Number;

		function set atSoundComplete(value : Function) : void;

		function set atFadeComplete(value : Function) : void;
		
		function get extra():Object;
	}
}
