package 
{
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	import screens.shop;
	/**
	 * ...
	 * @author Marcos Vazquez
	 */
	public class ShopButton extends SimpleButton {
		
		private var normal:Sprite = new shop_button();
		private var hover:Sprite = new shop_button_hover();
		private var clicked:Sprite = new shop_button_click();
		private var locked:Sprite = new shop_button_locked();
		
		public var img_:Sprite;
		public var name_:String;
		public var value_:Number;
		public var cost_:uint;
		public var cost_increment_:Number;
		public var level_:int;
		
		public var line1_txt_:TextField;
		public var line2_txt_:TextField;
		
		private var dots_:Vector.<Shape>;
		private var blocked_:Sprite;
		
		
		public function ShopButton(x:int, y:int, img:Sprite=null, name:String=null, value:Number=0, cost:int=0, increment:Number=0, level:int=1) {
			
			super(normal, hover, clicked, normal);
			
			this.x = x;
			this.y = y;
			this.scaleX = 0.7;
			this.scaleY = 0.7;
			this.enabled = true;
			blocked_ = new Sprite();
			Misc.getStage().addChild(this);
			
			if (img && name && cost) {
				//Image
				img_ = img;
				img_.scaleX = 0.5;
				img_.scaleY = 0.5;
				img_.x = this.x + 40;
				img_.y = this.y + 40;
				img.mouseEnabled = false;
				Misc.getStage().addChild(this.img_);
				//Line1 (name+value)
				this.name_ = name;
				this.value_ = value;
				this.line1_txt_ = Misc.getTextField(name_+"  "+value_, this.x-60, this.y + 110, 17, 0xFFFFFF);
				this.line1_txt_.mouseEnabled = false;
				Misc.getStage().addChild(line1_txt_);
				//Line2 (cost)
				this.cost_ = cost;
				this.line2_txt_ = Misc.getTextField("$ " + cost_, this.x - 65, this.y + 130, 17, 0xDDDDDD);
				this.line2_txt_.mouseEnabled = false;
				Misc.getStage().addChild(line2_txt_);
				//increment
				this.cost_increment_ = increment;
				//level
				level_ = level;
				//Draw upgrade level dots
				dots_ = new Vector.<Shape>;
				drawLevelDots();
				
				//Draw lock
				if (level_ >= shop.levels_[0]*3)
					drawLock();
			} else {
				this.downState = locked;
				this.upState = locked;
				this.overState = locked;
				this.hitTestState = locked;
			}
		}
		
		
		public function drawLevelDots():void {
			var color:uint = 0xFFFFFF;
			
			for (var i:uint = 0; i < level_; i++) {
				
				if (i==3)
					color = 0x5555FF;
				else if (i == 6)
					color = 0x55FF55;
				else if (i == 9)
					color = 0xFF5555;
				else if (i == 12)
					color = 0x222222;
					
				var circle:Shape = Shapes.getCircle(this.x + 37 + 40 * (i%3), this.y + 180, 10, color, 1);
				
				
				dots_.push(circle);
			}
		}
		
		public function removeLevelDots():void {
			for (var i:uint=0; i < level_; i++) {
				Misc.getStage().removeChild(dots_.shift());
				
			}
		}
		
		
		public function drawLock():void {
			if (!blocked_.stage) {
				blocked_ = new lock();
				blocked_.x = this.x + 40;
				blocked_.y = this.y + 40;
				Misc.getStage().addChild(blocked_);
			}
		}
		
		
		public function removeLockSprite():void {
			if (blocked_.stage)
				Misc.getStage().removeChild(blocked_);
		}
		
		
		public function remove():void {
			removeLockSprite();
			if (this.stage)
				Misc.getStage().removeChild(this);
		}
	}

}