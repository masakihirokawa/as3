﻿package jp.atziluth.gui{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Graphics;
	import jp.atziluth.utils.Cleaner;
	public class DrawTexture extends Sprite {
		public static function init($scope:DisplayObject, $color:uint=0x000000, col:uint=100, row:uint=100, w:uint=1, h:uint=1, intervalX:uint=2, intervalY:uint=2, $alpha:Number=1):void {
			if ($scope == null) {
				return;
			}
			var shape:Shape = new Shape();
			var scope:Sprite = Sprite($scope);
			var g:Graphics = shape.graphics;
			function _beginFill():void {
				g.beginFill($color, $alpha);
			}
			function _drawRect():void {
				function drawTextureY():void {
					for (var Y:uint; Y<(row/h); Y++) {
						drawTextureX(Y);
					}
				}
				function drawTextureX(Y:uint):void {
					for (var X:uint; X<(col/w); X++) {
						if (X % intervalX == Y % intervalY) {
							g.drawRect(X*w, Y*h, w, h);
						}
					}
				}
				drawTextureY();
			}
			function addShape($scope:Sprite, $shape:Shape):void {
				if ($scope.numChildren) {
					Cleaner.deleteSprite($scope, 0, null);
				}
				$scope.addChildAt($shape, 0);
				$scope.cacheAsBitmap = true;
			}
			_beginFill();
			_drawRect();
			addShape(scope, shape);
		}
	}
}