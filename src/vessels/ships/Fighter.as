package vessels.ships 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Marcos Vazquez
	 */
	public class Fighter extends Ship
	{
		
		public function Fighter() {
			
			var shipMC:MovieClip = new ship2();
			
			shipMC.x = 100;
			shipMC.y = Misc.getStage().stageHeight / 2;
			super(3, shipMC);
		}
		
		
		override public function Shoot():void {
			
			if (GameManager.getInstance().spare_shots_.length > 1) {
				var s:Shot = GameManager.getInstance().spare_shots_.pop();
				s.shape_.x = this.mc_.x + this.mc_.width/3;
				s.shape_.y = this.mc_.y - this.mc_.height/3;
				GameManager.getInstance().fired_shots_.push(s);
				
				s = GameManager.getInstance().spare_shots_.pop();
				s.shape_.x = this.mc_.x + this.mc_.width/3;
				s.shape_.y = this.mc_.y + this.mc_.height/3;
				GameManager.getInstance().fired_shots_.push(s);
			}
		}
		
	}

}