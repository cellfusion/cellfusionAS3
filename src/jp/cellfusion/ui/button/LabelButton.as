package jp.cellfusion.ui.button 
{
	import flash.text.TextFieldAutoSize;
	import flash.text.TextField;

	/**
	 * @author Mk-10:cellfusion (www.cellfusion.jp)
	 */
	public class LabelButton extends MovieClipButton 
	{
		private var _label:TextField;

		public function LabelButton(label:String, width:Number, height:Number)
		{
			super();
			
			_label = new TextField();
			_label.x = 2;
			_label.y = 2;
			_label.mouseEnabled = false;
			_label.text = label;
			_label.autoSize = TextFieldAutoSize.LEFT;
			addChild(_label);
			
			graphics.beginFill(0x808080, 1);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}

		override public function atClick():void 
		{
			super.atClick();
			
			enabled = true;
		}
	}
}
