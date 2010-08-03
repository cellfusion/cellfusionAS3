package jp.cellfusion.sound 
{

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public interface ISoundObject 
	{
		function play(startTime:Number = 0, loops:int = 0):void;

		function stop():void;

		function mute():void;

		function unmute():void;

		function solo():void;

		function pause():void;

		function resume():void;

		function destroy():void;

		function get volume():Number;

		function set volume(value:Number):void;
	}
}
