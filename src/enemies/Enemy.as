package enemies {
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.display.Shape;
	/**
	 * ...
	 * @author Marcos Vazquez
	 */
	public class Enemy extends Vessel {
		
		public var init_hp_:Number;
		public var hp_:Number;
		public var mc_:MovieClip;
		public var explosion_mc_:MovieClip;
		public var fire_probability_:Number;
		public var points_:Number;
		
		public var life_bar_:Shape;
		public var exploding_:Boolean = false;
		
		public function Enemy(x:uint, y:uint, hp:Number, fire_probability:Number, foeMC:MovieClip) {
			
			this.mc_ = foeMC;
			mc_.x = x;
			mc_.y = y;
			
			this.init_hp_ = hp;
			this.hp_ = hp;
			this.fire_probability_ = fire_probability;
			
			this.life_bar_ = Graphics.getRectangle(0, 0, 40, 5, 0x00cc00, 0.6);
			life_bar_.x = x-20;
			life_bar_.y = y + mc_.height/2 + 5;
			
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
			if (mc_.x > 0 && !exploding_) {
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
		
		
		public function damage(amount:uint):void {
			hp_ -= amount;
			GameManager.getInstance().drawLifeBar(this);
			if (hp_ <= 0 && !exploding_) {
				explode();
				//Add points to the player
				GameManager.getInstance().points_ += this.points_;
				Misc.getStage().removeChild(life_bar_);
			} else {
				TweenLite.to(mc_, 0, { tint:0xff0000 } );
			}
		}
		
		
		public function explode():void {
			Misc.getStage().removeChild(mc_);
						
			explosion_mc_ = new explosion1();
			explosion_mc_.x = mc_.x;
			explosion_mc_.y = mc_.y;
			
			Misc.getStage().addChild(explosion_mc_);
			exploding_ = true;
			
			var explosion_mc:MovieClip = explosion_mc_;
			explosion_mc.addFrameScript(explosion_mc.totalFrames - 1, destroyExplosion);
			explosion_mc_.play();
			
			function destroyExplosion():void {
				explosion_mc.stop();
				Misc.getStage().removeChild(explosion_mc);
			}
		}
	}

}