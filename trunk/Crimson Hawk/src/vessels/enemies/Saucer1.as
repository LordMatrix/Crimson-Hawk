package vessels.enemies {
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Lord Matrix
	 */
	public class Saucer1 extends Enemy {
		
		public function Saucer1(x:uint, y:uint, hp:Number, fire_probability:Number) {
			var foeMC:MovieClip = new saucer1();
			super(x,y,hp,fire_probability,foeMC);
			points_ = 2;
		}
		
	}

}