﻿package jp.atziluth.gui{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	public class RelativeLayout extends DisplayObject {
		private static var aimX:int;
		private static var aimY:int;
		private static var _x:int;
		private static var _y:int;
		private static var _width:uint;
		private static var _height:uint;
		private static var rectangle:Rectangle;
		public static function setPos(stage:Stage,$scope:DisplayObject,position:String="center",marginX:int=0,marginY:int=0,w:uint=0,h:uint=0):void {
			if ($scope == null) {
				return;
			}
			RelativeLayout.setSize($scope,w,h);
			switch (position) {
				case "center" :
				case "cm" :
					RelativeLayout.aimX = Math.floor(stage.stageWidth / 2 - RelativeLayout._width / 2) + marginX;
					RelativeLayout.aimY = Math.floor(stage.stageHeight / 2 - RelativeLayout._height / 2) + marginY;
					break;
				case "top" :
				case "ct" :
					RelativeLayout.aimX = Math.floor(stage.stageWidth / 2 - RelativeLayout._width / 2) + marginX;
					RelativeLayout.aimY = marginY;
					break;
				case "right" :
				case "rm" :
					RelativeLayout.aimX = Math.floor(stage.stageWidth - RelativeLayout._width) - marginX;
					RelativeLayout.aimY = Math.floor(stage.stageHeight / 2 - RelativeLayout._height / 2) + marginY;
					break;
				case "bottom" :
				case "cb" :
					RelativeLayout.aimX = Math.floor(stage.stageWidth / 2 - RelativeLayout._width / 2) + marginX;
					RelativeLayout.aimY = Math.floor(stage.stageHeight - RelativeLayout._height) - marginY;
					break;
				case "left" :
				case "lm" :
					RelativeLayout.aimX = marginX;
					RelativeLayout.aimY = Math.floor(stage.stageHeight / 2 - RelativeLayout._height / 2) + marginY;
					break;
				case "righttop" :
				case "rt" :
					RelativeLayout.aimX = Math.floor(stage.stageWidth - RelativeLayout._width) - marginX;
					RelativeLayout.aimY = marginY;
					break;
				case "rightbottom" :
				case "rb" :
					RelativeLayout.aimX = Math.floor(stage.stageWidth - RelativeLayout._width) - marginX;
					RelativeLayout.aimY = Math.floor(stage.stageHeight - RelativeLayout._height) - marginY;
					break;
				case "leftbottom" :
				case "lb" :
					RelativeLayout.aimX = marginX;
					RelativeLayout.aimY = Math.floor(stage.stageHeight - RelativeLayout._height) - marginY;
					break;
				case "lefttop" :
				case "lt" :
				default :
					RelativeLayout.aimX = marginX;
					RelativeLayout.aimY = marginY;
					break;
			}
			RelativeLayout.point($scope, RelativeLayout.aimX, RelativeLayout.aimY);
		}
		public static function resize($scope:DisplayObject,w:uint=0,h:uint=0):void {
			if ($scope == null) {
				return;
			}
			RelativeLayout.setSize($scope,w,h);
			$scope.width = RelativeLayout._width;
			$scope.height = RelativeLayout._height;
		}
		public static function point($scope:DisplayObject,posX:int,posY:int):void {
			if ($scope == null) {
				return;
			}
			RelativeLayout.setPoint(posX, posY);
			$scope.x = RelativeLayout._x;
			$scope.y = RelativeLayout._y;
		}
		public static function rect($scope:DisplayObject,posX:int,posY:int,w:uint=0,h:uint=0):void {
			if ($scope == null) {
				return;
			}
			RelativeLayout.setPoint(posX, posY);
			RelativeLayout.setSize($scope,w,h);
			RelativeLayout.rectangle = new Rectangle(
			  RelativeLayout._x,RelativeLayout._y,RelativeLayout._width,RelativeLayout._height
			);
			$scope.x = RelativeLayout.rectangle.x;
			$scope.y = RelativeLayout.rectangle.y;
			$scope.width = RelativeLayout.rectangle.width;
			$scope.height = RelativeLayout.rectangle.height;
		}
		private static function setSize($scope:DisplayObject,w:uint, h:uint):void {
			w ? RelativeLayout._width = w:RelativeLayout._width = $scope.width;
			h ? RelativeLayout._height = h:RelativeLayout._height = $scope.height;
		}
		private static function setPoint(posX:int,posY:int):void {
			RelativeLayout._x = posX;
			RelativeLayout._y = posY;
		}
	}
}