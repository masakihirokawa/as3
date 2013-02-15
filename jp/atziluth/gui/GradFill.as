﻿package jp.atziluth.gui{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.InterpolationMethod;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import jp.atziluth.utils.Cleaner;
	import jp.atziluth.utils.AtTween;
	public class GradFill extends Sprite {
		private var container:Sprite;
		private var shape:Shape;
		private var g:Graphics;
		private var m:Matrix;
		private var gradientType:String;
		private var fadein:Function = AtTween.fadein;
		private var deletePastSprite:Function = function($scope:Sprite){Cleaner.deleteSprite($scope,1,null)};
		public function init(
		    stage:Stage, 
		    $scope:Sprite, 
		    $color:Array, 
		    $alpha:Array, 
		    $type:String="GradientType.LINEAR", 
		    r:Number=0, 
		    w:uint=480, 
		    h:uint=480, 
		    $tx:Number=0, 
		    $ty:Number=0, 
		    $scaleX:Number=1, 
		    $scaleY:Number=1,
		    isTween:Boolean=true
		):void {
			container = new Sprite();
			shape = new Shape();
			g = shape.graphics;
			m = new Matrix();
			with (m) {
				identity();
				rotate(r);
				tx = $tx;
				ty = $ty;
				scale($scaleX,$scaleY);
			}
			with (g) {
				beginGradientFill(
				    convertGradientType($type),
				    [$color[0],$color[1]],
				    [$alpha[0],$alpha[1]],
				    [0,255],
				    m,
				    SpreadMethod.PAD,
				    InterpolationMethod.LINEAR_RGB,
				    0.0
				);
				drawRect(0, 0, w, h);
			}
			addGradation($scope,container,shape);
			isTween ? fadeinGradation(container):deletePastSprite($scope);
		}
		private function addGradation($scope:Sprite,container:Sprite, shape:Shape):void {
			if ($scope.numChildren) {
				Cleaner.deleteSprite($scope,0,null);
			}
			$scope.addChildAt(container,$scope.numChildren);
			container.addChildAt(shape,container.numChildren);
		}
		private function fadeinGradation($scope:Sprite):void {
			fadein($scope,1,"Strong.easeInOutCubic",0,deletePastSprite($scope));
		}
		private function convertGradientType(str:String):String {
			switch (str) {
				case "GradientType.LINEAR" :
				case "LINEAR" :
				case "linear" :
					gradientType = GradientType.LINEAR;
					break;
				case "GradientType.RADIAL" :
				case "RADIAL" :
				case "radial" :
					gradientType = GradientType.RADIAL;
					break;
				default :
					gradientType = GradientType.LINEAR;
					break;
			}
			return (gradientType);
		}
	}
}