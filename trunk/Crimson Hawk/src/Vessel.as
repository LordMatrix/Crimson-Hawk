package {
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.display.Shape;
	/**
	 * ...
	 * @author Marcos Vazquez
	 */
	public class Vessel 
	{
		
		public function Vessel() {
			public var init_hp_:Number;
			public var hp_:Number;
			public var mc_:MovieClip;
			public var explosion_mc_:MovieClip;
			public var fire_probability_:Number;
			public var points_:Number;
			
			public var life_bar_:Shape;
			public var exploding_:Boolean = false;
			
		}
		
	}

}