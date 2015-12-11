package vessels.ships 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Marcos Vazquez
	 */
	public class Destructor extends Ship {
		
		private var missile_counter_:uint = 0;
		
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
			
			missile_counter_++;
			
			trace("L : " + GameManager.getInstance().spare_shots_.length);
			if (GameManager.getInstance().spare_shots_.length == 0)
				LaunchMissile();
			
			if (GameManager.getInstance().spare_shots_.length == 0)
				FireLazer();
		}
		
		
		public function LaunchMissile():void {
			trace("LAUNCHING MISSILE");
		}
		
		public function FireLazer():void {
			trace ("FIRE DA LAZER!");
		}
	}

}