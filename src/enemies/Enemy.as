package enemies {
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.display.Shape;
	/**
	 * ...
	 * @author Marcos Vazquez
	 */
	public class Enemy {
		
		public var init_hp_:Number;
		public var hp_:Number;
		public var mc_:MovieClip;
		public var fire_probability_:Number;
		public var points_:Number;
		
		public var life_bar_:Shape;
		
		
		public function Enemy(x:uint, y:uint, hp:Number, fire_probability:Number) {
			
			this.init_hp_ = hp;
			this.hp_ = hp;
			this.fire_probability_ = fire_probability;
			
			this.life_bar_ = Graphics.getRectangle(0, 0, 40, 5, 0x00cc00, 0.6);
			life_bar_.x = x-20;
			life_bar_.y = y+18;
			
			TweenMax.to(this.life_bar_, 0, { blurFilter: { blurX:3 }} );
			
			Misc.getStage().addChild(life_bar_);
		}
		
		public function Shoot():void {
			var shot_shape:Shape = Graphics.getEllipse(0, 0, 25, 8, 0x990000, 0.6);
			TweenMax.to(shot_shape, 0, { blurFilter: { blurX:10 }} );
			
			shot_shape.x = this.mc_.x - this.mc_.width/3;
			shot_shape.y = this.mc_.y;
						
			var s:Shot = new Shot(shot_shape, 1, -15, 0, 1);
			GameManager.getInstance().enemy_shots_.push(s);
			Misc.getStage().addChild(s.shape_);
		}
		
		public function move():Boolean {
			if (mc_.x > 0) {
				mc_.x -= 10;
				life_bar_.x -= 10;
				
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