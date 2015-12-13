package vessels.enemies {
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Marcos Vazquez
	 * 
	 * The base enemy: moves forward and shoots
	 */
	public class Saucer1 extends Enemy {
		
		public function Saucer1(x:uint, y:uint, hp:Number, fire_probability:Number) {
			var foeMC:MovieClip = new saucer1();
			super(x,y,hp,fire_probability,foeMC);
			points_ = 20;
		}
		
	}

}