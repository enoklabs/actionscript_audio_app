package com.reymadrid.utils
{
	public class RoundNumber
	{
		public function RoundNumber()
		{
			super();
		}
		public static function roundToDecimal(value:Number, decimalPlace:int):Number{
			var modifier:int = Math.pow(10, decimalPlace);
			value = (value * modifier);
			value = Math.round(value);
			value = (value / modifier);
			return (value);
		}
		
		public static function randomWithinRange(low:int, high:int):int{
			var range:int = ((high - low) + 1);
			var num:int = Math.floor(((Math.random() * range) + low));
			return (num);
		}
		
		public static function constrainToRange(value:Number, low:Number, high:Number):Number{
			if (value < low){
				value = low;
			} else {
				if (value > high){
					value = high;
				};
			};
			return (value);
		}
	}
}