﻿package jp.atziluth.gui{
	import flash.display.DisplayObjectContainer;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.system.Capabilities;
	import jp.atziluth.utils.Cleaner;
	public class BitmapTexture extends Sprite {
		private static var scope:DisplayObjectContainer;
		private static var w:uint;
		private static var h:uint;
		private static var bmd:BitmapData;
		private static var sp:Sprite;
		public static function draw($scope:DisplayObjectContainer, w:uint=0, h:uint=0, p1:uint=2, p2:uint=0, p3:uint=1):void {
			if ($scope == null) {
				return;
			}
			BitmapTexture.initialize($scope, w, h);
			var bmd:BitmapData = new BitmapData(p1,p1,true,0x00FFFFFF);
			bmd.lock();
			bmd.setPixel32(p2, p2, 0xFF000000);
			bmd.setPixel32(p3, p3, 0xFF000000);
			bmd.unlock();
			BitmapTexture.bmd = bmd;
			BitmapTexture.beginFill();
			BitmapTexture.addStage();
		}
		public static function load($scope:DisplayObjectContainer, w:uint=0, h:uint=0):void {
			if ($scope == null) {
				return;
			}
			BitmapTexture.initialize($scope, w, h);
			var bmd:BitmapData = new BitmapTexturePattern(0,0);
			BitmapTexture.bmd = bmd;
			BitmapTexture.beginFill();
			BitmapTexture.addStage();
		}
		private static function initialize($scope:DisplayObjectContainer, w:uint, h:uint):void {
			BitmapTexture.scope = $scope;
			w ? BitmapTexture.w = w:BitmapTexture.w = Capabilities.screenResolutionX;
			h ? BitmapTexture.h = h:BitmapTexture.h = Capabilities.screenResolutionY;
		}
		private static function beginFill():void {
			var sp:Sprite = new Sprite();
			sp.graphics.beginBitmapFill(BitmapTexture.bmd, null, true, true);
			sp.graphics.drawRect(0, 0, BitmapTexture.w, BitmapTexture.h);
			sp.graphics.endFill();
			BitmapTexture.sp = sp;
		}
		private static function addStage():void {
			if (BitmapTexture.scope.numChildren) {
				Cleaner.deleteContainer(BitmapTexture.scope, 0, null);
			}
			BitmapTexture.scope.addChildAt(BitmapTexture.sp, 0);
		}
	}
}