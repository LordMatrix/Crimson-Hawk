package screens 
{
	import com.greensock.TweenLite;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Lord Matrix
	 */
	public class shop extends MovieClip {
		
		private var backgr_:MovieClip;
		private var manager_:GameManager;
		private var points_txt_:TextField;
		private var lives_txt_:TextField;
		private var buttons_:Vector.<ShopButton>;
		private var next_:Sprite;
		
		public function shop() {
			super();
			trace("shop");
			buttons_ = new Vector.<ShopButton>();
			next_ = new Sprite();
			initScreen();
			addObjects();
			addEventListeners();
		}
		
		private function initScreen():void {
		
			backgr_ = new bgshop();
			TweenLite.to(backgr_, 0, { scaleX:2, scaleY:1 } );
			
			manager_ = GameManager.getInstance();
			points_txt_ = Misc.getTextField("Points: "+String(manager_.points_), 0, 0, 20, 0x990000);
			lives_txt_ = Misc.getTextField("Lives: " + String(manager_.lives_), 0, 20, 20, 0x990000);
		}
		
		private function addObjects():void { 
			addChild(backgr_);
			addChild(points_txt_);
			addChild(lives_txt_);
			
			//Create shopping buttons
			var index:int;
			var bx:int;
			var by:int;
			var row:int = 0;
			var column:int = 0;
			for (var i:uint = 0; i < 8; i++) {
				index = buttons_.length;
				bx = 150 + 300 * column;
				by = 50 + (250 * row);
				
				buttons_[index] = new ShopButton(bx, by, new ammo());
				
				column++;
				if (i == 3) {
					row++;
					column = 0;
				}
			}
			
			//Create next level button
			next_.graphics.copyFrom(Shapes.getRectangle(600, 500, 150, 80, 0x999999, 1.0).graphics);
			addChild(next_);
		}
		
		
		private function addEventListeners():void {
			addEventListener(Event.ENTER_FRAME, loop);
			next_.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownNext);
		}
		
		
		private function onMouseDownNext(e:MouseEvent):void {
			trace("ROLLING");
			nextScreen();
		}
		
		
		private function loop(e:Event):void {
			
			points_txt_.text = "Points: " + String(manager_.points_);
			lives_txt_.text = "Lives: " + String(manager_.lives_);
		}

		
		private function nextScreen():void { 
			killScreen();
			Misc.getStage().addChild(manager_.ship_.mc_);
			manager_.reset();
			Misc.getMain().loadScreen(2);
		}
		
		private function killScreen():void {
			removeEventListeners();
			removeObjects();
		}
		
		private function removeEventListeners():void {
			removeEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function removeObjects():void {
			
			removeChild(backgr_);
			backgr_ = null;
			
			for (var i:uint = 0; i < 8; i++) {
				Misc.getStage().removeChild(buttons_[i]);
				Misc.getStage().removeChild(buttons_[i].img_);
				delete buttons_[i];
				buttons_[i] = null;
			}
			
			removeChild(next_);
			next_ = null;
		}
	}

}