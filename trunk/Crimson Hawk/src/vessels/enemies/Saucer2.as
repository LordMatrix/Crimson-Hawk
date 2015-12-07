package vessels.enemies {
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Lord Matrix
	 * A flying saucer that moves following a sinoidal path
	 */
	public class Saucer2 extends Enemy {
		
		private var frame_:Number;
		
		public function Saucer2(x:uint, y:uint, hp:Number, fire_probability:Number) {
			var foeMC:MovieClip = new saucer2();
			super(x,y,hp,fire_probability,foeMC);
			points_ = 1;
			frame_ = Misc.random(0, 359);
		}
		
		override public function move():Boolean {
			if (mc_.x > 0) {
				frame_ += 0.1;
				
				mc_.x -= 10;
				life_bar_.x -= 10;
				mc_.y -= Math.sin(frame_) * 12
				life_bar_.y -= Math.sin(frame_)*12;
				//caculate the probability an enemy will shoot
				if (Math.random() < fire_probability_)
					Shoot();
					
				return true;
			} else {
				return false;
			}
		}
		
	}

}