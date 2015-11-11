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
		
		public var shots:Vector.<Shot>;
		
		public function Enemy(hp:Number, mc:MovieClip, fire_probability:Number) {
			this.hp_ = hp;
			this.mc_ = mc;
			this.fire_probability_ = fire_probability;
			
			shots = new Vector.<Shot>();
		}
		
		public function Shoot():void {
			var shot_shape:Shape = Graphics.getEllipse(0, 0, 25, 8, 0x990000, 0.6);
			TweenMax.to(shot_shape, 0, { blurFilter: { blurX:10 }} );
			
			shot_shape.x = this.mc_.x - this.mc_.width/3;
			shot_shape.y = this.mc_.y;
						
			var s:Shot = new Shot(shot_shape, 1, -15, 0, 1);
			this.shots.push(s);
			Misc.getStage().addChild(s.shape_);
		}
		
		public function moveShots():void {
			
			var i:uint = 0;
			
			for each (var s:Shot in shots) {
				if (s.shape_.x > 0) {
					s.shape_.x += s.speedX_;
					//s.shape_.y += s.speedY_;
				} else  {
					Misc.getStage().removeChild(s.shape_);
					shots.splice(i, 1);
				}
				
				i++;
			}
		}
		
	}

}