package vessels.enemies {
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.display.Shape;
	/**
	 * ...
	 * @author Lord Matrix
	 * A flying saucer that hovers the top of the screen throwing bombs
	 */
	public class Saucer3 extends Enemy {
		
		public function Saucer3(x:uint, y:uint, hp:Number, fire_probability:Number) {
			var foeMC:MovieClip = new saucer3();
			super(x,y,hp,fire_probability,foeMC);
			points_ = 20;
		}
		
		override public function move():Boolean {
			if (mc_.x > 0) {
				
				mc_.x -= 5;
				life_bar_.x -= 5;
				//caculate the probability an enemy will shoot
				if (Math.random() < fire_probability_)
					Shoot();
					
				return true;
			} else {
				return false;
			}
		}
		
		override public function Shoot():void {
			var shot_shape:Shape = Shapes.getRectangle(0, 0, 20, 20, 0xFFFFFF, 0.6);
			TweenMax.to(shot_shape, 0, { blurFilter: { blurY:10 }} );
			
			shot_shape.x = this.mc_.x - this.mc_.width/3;
			shot_shape.y = this.mc_.y;
						
			var s:Shot = new Shot(shot_shape, 1, 0, 10, 1);
			GameManager.getInstance().enemy_shots_.push(s);
			Misc.getStage().addChild(s.shape_);
		}
	}

}