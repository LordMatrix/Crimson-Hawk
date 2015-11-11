package 
{
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.display.Shape;
	/**
	 * ...
	 * @author Marcos Vazquez
	 */
	public class Enemy {
		
		public var hp_:Number;
		public var mc_:MovieClip;
		public var fire_probability_:Number;
		
		
		public function Enemy(hp:Number, mc:MovieClip, fire_probability:Number) {
			this.hp_ = hp;
			this.mc_ = mc;
			this.fire_probability_ = fire_probability;
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
	}

}