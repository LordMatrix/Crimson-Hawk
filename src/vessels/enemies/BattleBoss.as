package vessels.enemies 
{
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.display.Shape;
	/**
	 * ...
	 * @author Lord Matrix
	 */
	public class BattleBoss extends Enemy {
		
		private var frame_:Number;
		private var direction_:int;
		
		
		public function BattleBoss(x:uint, y:uint, hp:Number, fire_probability:Number) {
			var foeMC:MovieClip = new BattleBossMC();
			super(x,y,hp,fire_probability, foeMC);
			points_ = 30;
			frame_ = Misc.random(0, 359);
		}
		
		override public function move():Boolean {
			if (mc_.x > Misc.getStage().stageWidth - 330) {
				mc_.x -= 2;
				life_bar_.x -= 2;
				direction_ = -1;
			} else {
				//Follows ship around
				if (GameManager.getInstance().ship_.mc_.y < this.mc_.y) this.mc_.y -= 3;
				else if (GameManager.getInstance().ship_.mc_.y > this.mc_.y) this.mc_.y += 3;
			}
			
			//caculate the probability an enemy will shoot
			if (Math.random() < fire_probability_)
				Shoot();
			
			return true;
		}
		
		
		override public function Shoot():void {
			
			var manager_:GameManager = GameManager.getInstance();
			
			var shot_shape:Shape = Shapes.getCircle(0, 0, 4, 0x00AAAA, 1);
			TweenMax.to(shot_shape, 0, { blurFilter: { blurX:10 }} );
			
			
			//Shoots directly towards ship
			shot_shape.x = this.mc_.x;
			shot_shape.y = this.mc_.y;
						
			var dx:Number = (manager_.ship_.mc_.x - this.mc_.x) / 40;
			var dy:Number = (manager_.ship_.mc_.y - this.mc_.y) / 40;
			
			var s:Shot = new Shot(shot_shape, 1, dx, dy, 1);
			GameManager.getInstance().enemy_shots_.push(s);
			Misc.getStage().addChild(s.shape_);
		}
	}

}