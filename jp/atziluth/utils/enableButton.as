﻿package jp.atziluth.utils{
	import flash.display.Sprite;
	public function enableButton(_sp:Sprite, b:Boolean):void {
		_sp.mouseChildren = b;
		_sp.mouseEnabled = b;
	}
}