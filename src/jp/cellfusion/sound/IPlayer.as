package jp.cellfusion.sound 
{

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public interface IPlayer 
	{
		function play(fade:Boolean = false):void;

		function pause(fade:Boolean = false):void;

		function resume(fade:Boolean = false):void;

		function stop(fade:Boolean = false):void;

		function get solo():Boolean;
		function set solo(b:Boolean):void;

		function get mute():Boolean;
		function set mute(b:Boolean):void;
	}
}
