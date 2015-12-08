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
		
		public static var levels_:Vector.<int> = new <int>[1, 1, 1, 1, 1];
		
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
			
			var shot:Shot = (manager_.spare_shots_.length > 0) ? manager_.spare_shots_[0] : manager_.fired_shots_[0];
			
			//Create shopping buttons
			var index:int;
			var bx:int;
			var by:int;
			var row:int = 0;
			var column:int = 0;
			var images:Vector.<Sprite> = new <Sprite>[new ammo(), new armor(), new speed(), new damage(), new shield()];
			var names:Vector.<String> = new <String> ["Ammo", "Armor", "Speed", "Damage", "Shield"];
			var values:Vector.<Number> = new <Number> [manager_.MAX_SHOTS, manager_.ship_.init_hp_, manager_.ship_.speed_, shot.damage_, 0];
			var costs:Vector.<int> = new <int>[30, 30, 50, 70, 100];
			var cost_increments:Vector.<Number> = new <Number>[1.5, 1.5, 1.5, 1.5, 1.5];

			for (var i:uint = 0; i < 8; i++) {
				index = buttons_.length;
				bx = 150 + 300 * column;
				by = 50 + (250 * row);
				
				var cost:int
				
				if (index <= images.length - 1) {
					cost = costs[i] * (Math.pow(cost_increments[i], levels_[i]-1))
					buttons_[index] = new ShopButton(bx, by, images[i], names[i], values[i], cost, cost_increments[i]);
				} else {
					buttons_[index] = new ShopButton(bx, by);
				}
				
				column++;
				if (i == 3) {
					row++;
					column = 0;
				}
				
				buttons_[index].addEventListener(MouseEvent.MOUSE_UP, processShopButtonClicked(index));
			}
			
			//Create next level button
			var square:Graphics = Shapes.getRectangle(600, 500, 150, 80, 0x999999, 1.0).graphics;
			next_.graphics.copyFrom(square);
			square.clear();
			Misc.getStage().addChild(next_);
		}
		
		
		private function processShopButtonClicked(index:int):Function {
			return function (e:MouseEvent):void {
				
				var valid:Boolean = false;
				
				//Get out if the player hasn't got enough points
				if (buttons_[index].cost_ > manager_.points_)
					return;
					
				switch(index) {
					case 0:
						valid = true;
						manager_.MAX_SHOTS++;
						buttons_[index].value_ = manager_.MAX_SHOTS;
						manager_.createShots();
						trace("You can fire " + manager_.MAX_SHOTS + " at once");
						break;
					case 1:
						valid = true;
						manager_.ship_.init_hp_++;
						manager_.ship_.hp_ = manager_.ship_.init_hp_;
						buttons_[index].value_ = manager_.ship_.init_hp_;
						trace("Ship's armor is now "+manager_.ship_.hp_)
						break;
					case 2:
						valid = true;
						//speed
						manager_.ship_.speed_ += 2;
						buttons_[index].value_ = manager_.ship_.speed_;
						trace("Ship's speed is now " + manager_.ship_.speed_);
						break;
					case 3:
						valid = true;
						//damage
						manager_.mergeShots();
						
						for (var i:uint= 0; i < manager_.MAX_SHOTS; i++) {
							manager_.spare_shots_[i].damage_ += 0.5;
						}
						
						buttons_[index].value_ =  manager_.spare_shots_[0].damage_;
						trace("Shots damage is now " + manager_.spare_shots_[0].damage_);
						break;
					case 4:
						//shield
						break;
					case 5:
						break;
					case 6:
						break;
					case 7:
						break;
				}
				
				if (valid) {
					//Substract money from player
					manager_.points_ -= buttons_[index].cost_;
					//add a level to this button
					shop.levels_[index]++;
					//Refresh buttons
					buttons_[index].line1_txt_.text = buttons_[index].name_ +"  " + buttons_[index].value_;
					buttons_[index].cost_ *= buttons_[index].cost_increment_;
					buttons_[index].line2_txt_.text = "$ " + buttons_[index].cost_;
				}
			}
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
			manager_.resetLevel();
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
				
				if (buttons_[i].img_ && buttons_[i].img_.stage) {
					Misc.getStage().removeChild(buttons_[i].img_);
					Misc.getStage().removeChild(buttons_[i].line1_txt_);
					Misc.getStage().removeChild(buttons_[i].line2_txt_);
				}
					
				delete buttons_[i];
				buttons_[i] = null;
			}
			
			Misc.getStage().removeChild(next_);
			next_ = null;
			
			
		}
	}

}