package vessels.enemies 
{
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.display.Shape;
	/**
	 * ...
	 * @author Marcos Vazquez
	 * 
	 * A class representing a big flying saucer boss with an alien inside.
	 */
	public class AlienBoss extends Enemy {
		
		private var frame_:Number;
		private var direction_:int;
		
		private var vibrating_:Boolean;
		private var preparing_:Boolean;
		
		private var fireBall_:Shape;
		
			
		public function AlienBoss(x:uint, y:uint, hp:Number, fire_probability:Number) {
			var foeMC:MovieClip = new AlienBossMC();
			super(x,y,hp,fire_probability, foeMC);
			points_ = 300;
			frame_ = Misc.random(0, 359);
			
			vibrating_ = false;
			preparing_ = false;
		}
		
		/**
		 * Moves this boss according to the following pattern:
		 * 1- Vibrates briefly before teleport
		 * 2- Teleports in range x,y on the right side of the screen
		 * 3- Teleports above ship and fires down, then comes back to position
		 * 
		 * @return A boolean value indicating if it has moved
		 */
		override public function move():Boolean {
			if (mc_.x > Misc.getStage().stageWidth - 330) {
				mc_.x -= 2;
				life_bar_.x -= 2;
				direction_ = -1;
			} else {

				//caculate the probability an enemy will shoot
				if (vibrating_) {
					vibrate();
					if (frame_ == 50) {
						frame_ = 0;
						vibrating_ = false;
						this.mc_.x = GameManager.getInstance().ship_.mc_.x - 20;
						this.mc_.y = 50;
						this.life_bar_.x = GameManager.getInstance().ship_.mc_.x - 20;
						this.life_bar_.y = 50;
						preparing_ = true;
						//Create fireball
						fireBall_ = Shapes.getCircle(0, 0, 2, 0x00CC00, 1);
						fireBall_.x = this.mc_.x + this.mc_.width/2;
						fireBall_.y = this.mc_.y + this.mc_.height/2;
						Misc.getStage().addChild(fireBall_);
					}
				} else if (preparing_) {
					if (frame_ < 20) {
						growShot();
					} else {
						Shoot();
						preparing_ = false;
						vibrating_ = false;
					}
				} else if (Math.random() < fire_probability_) {
					//Shoot();
					frame_ = 0;
					vibrating_ = true;
				} else if (Math.random() > 0.90) {
					var posx:uint = Misc.random(Misc.getStage().stageWidth - 300, Misc.getStage().stageWidth - 50);
					var posy:uint = Misc.random(30, Misc.getStage().stageHeight - 100);
					this.mc_.x = posx;
					this.mc_.y = posy;
					this.life_bar_.x = posx;
					this.life_bar_.y = posy;
				}
			}
			
			
			
			return true;
		}
		
		
		/// @brief Shoots down using fireBall_ 
		override public function Shoot():void {
			Misc.getStage().removeChild(fireBall_);
			
			TweenMax.to(fireBall_, 0, { blurFilter: { blurY:10 }} );
			
			var s:Shot = new Shot(fireBall_, 1, 0, 15, 1);
			GameManager.getInstance().enemy_shots_.push(s);
			Misc.getStage().addChild(s.shape_);
		}
		
		
		/// @brief Makes the Sprite jitter horizontally
		public function vibrate():void {
			if (frame_ % 2 == 0) this.mc_.x -= 7;
			else this.mc_.x += 7;
			
			frame_++;
		}
		
		
		/// @brief Makes fireBall_ bigger
		private function growShot():void {
			
			Misc.getStage().removeChild(fireBall_);
			fireBall_.height += 3;
			fireBall_.width += 3;
			Misc.getStage().addChild(fireBall_);
			
			frame_++;
		}
	}

}