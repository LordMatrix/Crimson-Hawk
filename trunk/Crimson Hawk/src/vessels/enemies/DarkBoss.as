package vessels.enemies 
{
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.display.Shape;
	/**
	 * ...
	 * @author Marcos Vazquez
	 * 
	 * A class representing a pointy, dark boss
	 */
	public class DarkBoss extends Enemy {
		
		private var frame_:Number;
		private var direction_:int;
		
		
		public function DarkBoss(x:uint, y:uint, hp:Number, fire_probability:Number) {
			var foeMC:MovieClip = new DarkBossMC();
			super(x,y,hp,fire_probability, foeMC);
			points_ = 300;
			frame_ = Misc.random(0, 359);
		}
		
		
		/**
		 * Moves horizontally accross the screen, going faster the more to the left it is. Then it bounces off.
		 * @return	whether it has moved or not
		 */
		override public function move():Boolean {
			if (mc_.x > Misc.getStage().stageWidth - 330) {
				mc_.x -= 2;
				life_bar_.x -= 2;
				direction_ = -1;
			} else if (mc_.x < 10) {
				direction_ = 1;
				mc_.x = 15;
			} else {
				mc_.x += (5000/mc_.x/2) * direction_;
				life_bar_.x += (5000/mc_.x/2) * direction_;
			}
			
			//caculate the probability an enemy will shoot
			if (Math.random() < fire_probability_)
				Shoot();
			
			return true;
		}
		
		
		/// Shoots red balls at random X and Y speeds and angles, towards the left side of the screen  
		override public function Shoot():void {
			var shot_shape:Shape = Shapes.getCircle(0, 0, 8, 0xCC0000, 1);
			TweenMax.to(shot_shape, 0, { blurFilter: { blurX:10 }} );
			
			shot_shape.x = this.mc_.x;
			shot_shape.y = this.mc_.y;
						
			var dx:Number = Misc.random(3, 15) * -1;
			var dy:Number = Math.random() * 10 * Misc.randomSign();
			
			var s:Shot = new Shot(shot_shape, 1, dx, dy, 1);
			GameManager.getInstance().enemy_shots_.push(s);
			Misc.getStage().addChild(s.shape_);
		}
	}

}