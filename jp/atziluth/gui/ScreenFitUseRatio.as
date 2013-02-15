﻿package jp.atziluth.gui{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import org.casalib.util.RatioUtil;
	public function ScreenFitUseRatio(stage:Stage, _mc:MovieClip):void {
		var imageSize:Rectangle = new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
		var imageBounds:Rectangle = new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
		var resultSize:Rectangle = RatioUtil.scaleToFit(imageSize,imageBounds);
		_mc.width = resultSize.width;
		_mc.height = resultSize.height;
	}
}