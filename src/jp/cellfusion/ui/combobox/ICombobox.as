package jp.cellfusion.ui.combobox{	import mx.collections.IList;	import flash.events.IEventDispatcher;	/**	 * @author Mk-10:cellfusion	 */	public interface ICombobox extends IEventDispatcher 	{		/**		 * ドロップダウンリストへの参照		 */		function get dropdown():IList;				/**		 * リスト内の項目の数を取得する		 */		function get length():uint;				/**		 * スクロールバーを持たないドロップダウンリストに表示できる最大の行数を取得または設定します		 */		function get rowCount():uint;		function set rowCount(value:uint):void;				/**		 * ドロップダウンリストで選択されているアイテムのインデックスを取得または設定する		 */		function get selectedIndex():int;		function set selectedIndex(value:int):void;				/**		 * ドロップダウンリストで選択されているアイテムの値を取得または設定する		 */		function get selectedItem():*;		function set selectedItem(value:*):void;				/**		 * アイテムのリストの末尾にアイテムを追加する		 */		function addItem(item:*):*;				/**		 * 指定されたインデックス位置のリストにアイテムを挿入します		 */		function addItemAt(item:*, index:uint):*;				/**		 * ドロップダウンリストを閉じます		 */		function close():void;				/**		 * 指定されたインデックス位置のアイテムを取得します		 */		function getItemAt(index:uint):*;				/**		 * ドロップダウンリストを開く		 */		function open():void;				/**		 * リストから全てのアイテムを削除します		 */		function removeAll():void;				/**		 * 指定されたアイテムをリストから削除します		 */		function removeItem(item:*):*;				/**		 * 指定されたインデックス位置のアイテムを削除します		 */		function removeItemAt(index:uint):*;				/**		 * 指定されたインデックス位置にあるアイテムを別のアイテムで置き換えます		 */		function replaceItemAt(item:*, index:uint):*;	}}