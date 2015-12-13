package vessels.ships 
{
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import vessels.Vessel;
	/**
	 * ...
	 * @author Marcos Vazquez
	 * 
	 * The fourth and final ship
	 */
	public class Fortress extends Ship {
		
		public function Fortress() {
			
			var shipMC:MovieClip = new ship4();
			var oldship:Ship = GameManager.getInstance().ship_;
			
			shipMC.x = 100;
			shipMC.y = Misc.getStage().stageHeight / 2;
			super(oldship.init_hp_, shipMC, oldship.speed_, oldship.init_shield_);
			updateShieldGlow();
		}
		
		
		/**
		 * Shoots 8 beams at once.
		 * Shoots missiles if the upgrade has been bought.
		 * Shoots insta-lazers if the upgrade has been bought.
		 */
		override public function Shoot():void {
			
			var manager_:GameManager = GameManager.getInstance();
			var num_targets:int;
			var target:Vessel;
			var i:uint;
			
			//Fire lazers if all shots are available
			if (manager_.fired_shots_.length == 0 && manager_.lazers_.length == 0) {
				//Get a lazer target
				num_targets = manager_.active_enemies_.length;
				
				if (num_targets > 0) {
					for (i = 0; i < manager_.num_lazers_; i++) {
						target = manager_.active_enemies_[i % num_targets];
						FireLazer(target);
					}
				}
				
			}
			
			//Fire regular shots
			if (GameManager.getInstance().spare_shots_.length > 7) {
				
				var s:Shot;
				
				for (var h:uint = 1; h < 5; h++) {
					s = manager_.spare_shots_.pop();
					s.shape_.x = this.mc_.x + this.mc_.width/2;
					s.shape_.y = this.mc_.y - this.mc_.height/h;
					manager_.fired_shots_.push(s);
					
					s = manager_.spare_shots_.pop();
					s.shape_.x = this.mc_.x + this.mc_.width/2;
					s.shape_.y = this.mc_.y + this.mc_.height/h;
					manager_.fired_shots_.push(s);
				}
				
				SoundManager.getInstance().playSFX(0);
			}
			
			//fire missiles
			if (GameManager.getInstance().spare_shots_.length == GameManager.getInstance().MAX_SHOTS - 8 && GameManager.getInstance().missiles_.length == 0) {
				//Get a missile target
				num_targets = manager_.active_enemies_.length;
				
				if (num_targets > 0) {
					for (var i:uint = 0; i < GameManager.getInstance().num_missiles_; i++) {
						var target_index:uint = i % num_targets;
						LaunchMissile(target_index);
					}
				}
				
			}
			
		}

	}

}