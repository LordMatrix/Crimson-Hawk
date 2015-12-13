package vessels.enemies {
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import vessels.Vessel;
	/**
	 * ...
	 * @author Marcos Vazquez
	 * 
	 * A class that represents all common attributes and methods for enemy ships
	 */
	public class Enemy extends vessels.Vessel {
		
		public var fire_probability_:Number;
		public var points_:Number;
		
		
		/**
		 * This constructor will be called by every subclass of enemy
		 * @param	x	x coordinate
		 * @param	y	y coordinate	
		 * @param	hp	health points
		 * @param	fire_probability	the probability that the enemy will shoot, every frame
		 * @param	foeMC	MovieClip for this enemy
		 */
		public function Enemy(x:uint, y:uint, hp:Number, fire_probability:Number, foeMC:MovieClip) {
			
			this.mc_ = foeMC;
			mc_.x = x;
			mc_.y = y;
			
			this.init_hp_ = hp;
			this.hp_ = hp;
			this.fire_probability_ = fire_probability;
			
			this.life_bar_ = Shapes.getRectangle(0, 0, 40, 5, 0x00cc00, 0.6);
			life_bar_.x = x-20;
			life_bar_.y = y + mc_.height/2 + 5;
			
			TweenMax.to(this.life_bar_, 0, { blurFilter: { blurX:3 }} );
			
			Misc.getStage().addChild(life_bar_);
		}
		
		
		/**
		 * @brief	Shoots a straight beam to the left side of the screen
		 */
		override public function Shoot():void {
			var shot_shape:Shape = Shapes.getEllipse(0, 0, 25, 8, 0x990000, 0.6);
			TweenMax.to(shot_shape, 0, { blurFilter: { blurX:10 }} );
			
			shot_shape.x = this.mc_.x - this.mc_.width/3;
			shot_shape.y = this.mc_.y;
						
			var s:Shot = new Shot(shot_shape, 1, -15, 0, 1);
			GameManager.getInstance().enemy_shots_.push(s);
			Misc.getStage().addChild(s.shape_);
		}
		
		
		/// @brief	Moves straight left and pseudo-randomly shoots
		override public function move():Boolean {
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
		
		
		/**
		 * Damages this enemy, plays a hit sound, and makes it explode if it's hp<=0
		 * @param	amount	How many points of damage are inflicted
		 */
		override public function damage(amount:uint):void {
			hp_ -= amount;
			this.drawLifeBar();
			SoundManager.getInstance().playSFX(1);
			
			if (hp_ <= 0 && !exploding_) {
				explode();
				//Add points to the player
				GameManager.getInstance().points_ += this.points_;
				Misc.getStage().removeChild(life_bar_);
			} else {
				TweenLite.to(mc_, 0, { tint:0xff0000 } );
			}
		}
		
		
		/**
		 * @brief deletes explosion animation and removes the enemy from scene
		 */
		override public function destroyExplosion():void {
			explosion_mc_.stop();
			Misc.getStage().removeChild(explosion_mc_);
			//remove from enemies vector
			var index:uint = GameManager.getInstance().active_enemies_.indexOf(this);
			GameManager.getInstance().active_enemies_.splice(index, 1);
			trace("INDEX: " + index);
		}
		
	}

}