package enemies 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Lord Matrix
	 */
	public class HeadBoss extends Enemy {
		
		private var frame_:Number;
		
		public function HeadBoss(x:uint, y:uint, hp:Number, fire_probability:Number) {
			var foeMC:MovieClip = new HeadBossMC();
			super(x,y,hp,fire_probability, foeMC);
			points_ = 30;
			frame_ = Misc.random(0, 359);
		}
		
		override public function move():Boolean {
			if (mc_.x > Misc.getStage().stageWidth - 100) {
				mc_.x -= 2;
				life_bar_.x -= 2;
			} else {
				frame_ += 0.1;
				mc_.y -= Math.sin(frame_) * 12;
				life_bar_.y -= Math.sin(frame_) * 12;
			}
			
			//caculate the probability an enemy will shoot
			if (Math.random() < fire_probability_)
				Shoot();
			
			return true;
		}
	}

}