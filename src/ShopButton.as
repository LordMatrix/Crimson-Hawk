package 
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
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
		private var cost_:uint;
		
		
		public function ShopButton(x:int, y:int, img:Sprite=null, txt:TextField=null) {
			
			super(normal, hover, clicked, normal);
			
			this.x = x;
			this.y = y;
			this.scaleX = 0.7;
			this.scaleY = 0.7;
			this.enabled = true;
			Misc.getStage().addChild(this);
			
			if (img) {
				img_ = img;
				img_.scaleX = 0.5;
				img_.scaleY = 0.5;
				img_.x = this.x + 40;
				img_.y = this.y + 40;
				
				Misc.getStage().addChild(this.img_);
			} else {
				this.downState = locked;
				this.upState = locked;
				this.overState = locked;
				this.hitTestState = locked;
			}
		}
		
	}

}