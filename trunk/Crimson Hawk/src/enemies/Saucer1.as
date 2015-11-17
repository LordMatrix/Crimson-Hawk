package enemies {
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Lord Matrix
	 */
	public class Saucer1 extends Enemy {
		
		public function Saucer1(x:uint, y:uint, hp:Number, fire_probability:Number) {
			super(x,y,hp,fire_probability);
			var foeMC:MovieClip = new saucer1();
			foeMC.x = x;
			foeMC.y = y;
			this.mc_ = foeMC;
		}
		
	}

}