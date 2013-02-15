﻿package jp.atziluth.utils{
	public class Randomize {
		private static var shuffleList:Array = [];
		private static var shuffleNum:uint;
		private static var tempList:Array = [];
		private static var tempInt:int;
		public static function shuffleArray(arr:Array):Array {
			Randomize.shuffleList = arr;
			Randomize.shuffleNum = Randomize.shuffleList.length;
			while (Randomize.shuffleNum) {
				var m:int = Math.floor(Math.random() * Randomize.shuffleNum);
				var n:int = Randomize.shuffleList[--Randomize.shuffleNum];
				Randomize.shuffleList[Randomize.shuffleNum] = Randomize.shuffleList[m];
				Randomize.shuffleList[m] = n;
			}
			return (Randomize.shuffleList);
		}
		public static function shuffle(shuffleMin:int, shuffleMax:int):Array {
			for (var i:uint; i<shuffleMax; i++) {
				Randomize.tempList[i] = i + shuffleMin;
			}
			Randomize.shuffleList = Randomize.shuffleArray(Randomize.tempList);
			return (Randomize.shuffleList);
		}
		public static function exactRandom(exceptInt:int, randomMin:int, randomMax:int):int {
			do {
				Randomize.tempInt = Randomize.range(randomMin,randomMax);
			} while (Randomize.tempInt==exceptInt);
			return (Randomize.tempInt);
		}
		public static function range(randomMin:int, randomMax:int):int {
			var i:int = Math.floor(Math.random()*(randomMax-randomMin+1))+randomMin;
			return (i);
		}
	}
}