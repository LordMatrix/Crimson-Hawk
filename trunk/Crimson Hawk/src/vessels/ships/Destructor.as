package vessels.ships 
{
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import vessels.Vessel;
	/**
	 * ...
	 * @author Marcos Vazquez
	 */
	public class Destructor extends Ship {
		
		
		public function Destructor() {
			
			var shipMC:MovieClip = new ship3();
			var oldship:Ship = GameManager.getInstance().ship_;
			
			shipMC.x = 100;
			shipMC.y = Misc.getStage().stageHeight / 2;
			super(oldship.init_hp_, shipMC, oldship.speed_, oldship.init_shield_);
			updateShieldGlow();
		}
		
		
		override public function Shoot():void {
			
			if (GameManager.getInstance().spare_shots_.length > 3) {
				
				var s:Shot = GameManager.getInstance().spare_shots_.pop();
				s.shape_.x = this.mc_.x + this.mc_.width/3;
				s.shape_.y = this.mc_.y - this.mc_.height/2;
				GameManager.getInstance().fired_shots_.push(s);
				
				s = GameManager.getInstance().spare_shots_.pop();
				s.shape_.x = this.mc_.x + this.mc_.width/2;
				s.shape_.y = this.mc_.y - this.mc_.height/3;
				GameManager.getInstance().fired_shots_.push(s);
				
				s = GameManager.getInstance().spare_shots_.pop();
				s.shape_.x = this.mc_.x + this.mc_.width/3;
				s.shape_.y = this.mc_.y + this.mc_.height/2;
				GameManager.getInstance().fired_shots_.push(s);
				
				s = GameManager.getInstance().spare_shots_.pop();
				s.shape_.x = this.mc_.x + this.mc_.width/2;
				s.shape_.y = this.mc_.y + this.mc_.height/3;
				GameManager.getInstance().fired_shots_.push(s);
				
				SoundManager.getInstance().playSFX(0);
			}
			
			
			if (GameManager.getInstance().spare_shots_.length == GameManager.getInstance().MAX_SHOTS - 4 && GameManager.getInstance().missiles_.length == 0) {
				//Get a missile target
				var num_targets:int = GameManager.getInstance().active_enemies_.length;
				
				if (num_targets > 0) {
					for (var i:uint = 0; i < GameManager.getInstance().num_missiles_; i++) {
						var target:Vessel = GameManager.getInstance().active_enemies_[i % num_targets];
						LaunchMissile(target);
					}
				}
				
			}
		}
		
	}

}