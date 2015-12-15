package screens 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import vessels.ships.Destructor;
	import vessels.ships.Fighter;
	import vessels.ships.Fortress;
	/**
	 * ...
	 * @author Lord Matrix
	 * @brief  This class manages the shop screen
	 */
	public class shop extends MovieClip {
		
		private var backgr_:MovieClip;
		private var points_txt_:TextField;
		private var lives_txt_:TextField;
		//Holds all the shop buttons currently available
		private var buttons_:Vector.<ShopButton>;
		//The button to continue to the next screen
		private var next_:Sprite;
		private var manager_:GameManager = GameManager.getInstance();
		
		//Vector containing the current level of every available upgrade
		public static var levels_:Vector.<int> = new <int>[1, 1, 1, 1, 1, 0];
		
		//This is needed in order to initialize the shot_damage field
		private var shot:Shot = (manager_.spare_shots_.length > 0) ? manager_.spare_shots_[0] : manager_.fired_shots_[0];
		
		//Attributes for base upgrades
		private var images:Vector.<Sprite> = new <Sprite>[new ship2(), new ammo(), new armor(), new speed(), new damage(), new oneup()];
		private var names:Vector.<String> = new <String> ["Fighter", "Ammo", "Armor", "Speed", "Damage", "1UP"];
		private var values:Vector.<Number> = new <Number> [1, manager_.MAX_SHOTS, manager_.ship_.init_hp_, manager_.ship_.speed_, shot.damage_, manager_.lives_];
		private var costs:Vector.<int> = new <int>[200, 30, 30, 50, 70, 300];
		private var cost_increments:Vector.<Number> = new <Number>[3, 1.5, 1.5, 1.5, 1.5, 1];
		
		//Attributes for the second tier upgrades (after buying the "Fighter" ship)
		private var images2:Vector.<Sprite> = new <Sprite>[new shield(), new shield_recharge()];
		private var names2:Vector.<String> = new <String> ["Shield", "Recharge"];
		private var values2:Vector.<Number> = new <Number> [manager_.ship_.init_shield_, manager_.ship_.shield_recharge_];
		private var costs2:Vector.<int> = new <int>[100, 80];
		private var cost_increments2:Vector.<Number> = new <Number>[1.5, 1.3];
		private var levels2:Vector.<int> = new <int>[0, 0];
		
		//Attributes for the third tier upgrades (after buying the "Destructor" ship)
		private var images3:Vector.<Sprite> = new <Sprite>[new missiles(), new missile_damage()];
		private var names3:Vector.<String> = new <String> ["Ammo", "Damage"];
		private var values3:Vector.<Number> = new <Number> [manager_.num_missiles_, manager_.missiles_damage_];
		private var costs3:Vector.<int> = new <int>[120, 130];
		private var cost_increments3:Vector.<Number> = new <Number>[1.5, 1.6];
		private var levels3:Vector.<int> = new <int>[0, 1];
		
		//Attributes for the fourth tier upgrades (after buying the "Fortress" ship)
		private var images4:Vector.<Sprite> = new <Sprite>[new lazers(), new lazer_damage()];
		private var names4:Vector.<String> = new <String> ["Ammo", "Damage"];
		private var values4:Vector.<Number> = new <Number> [manager_.num_lazers_, manager_.lazers_damage_];
		private var costs4:Vector.<int> = new <int>[140, 150];
		private var cost_increments4:Vector.<Number> = new <Number>[1.5, 1.6];
		private var levels4:Vector.<int> = new <int>[0, 1];
		
		
		/**
		 * @brief	Creates a new shop screen
		 */
		public function shop() {
			super();
			trace("shop");
			buttons_ = new Vector.<ShopButton>();
			next_ = new Sprite();
			initScreen();
			addObjects();
			addEventListeners();
		}
		
		
		/**
		 * @brief	Initializes shop's visual elements
		 */
		private function initScreen():void {
		
			backgr_ = new bgshop();
			TweenLite.to(backgr_, 0, { scaleX:2, scaleY:1 } );
			
			manager_ = GameManager.getInstance();
			points_txt_ = Misc.getTextField("Points: "+String(manager_.points_), 0, 0, 20, 0x990000);
			lives_txt_ = Misc.getTextField("Lives: " + String(manager_.lives_), 0, 20, 20, 0x990000);
		}
		
		
		
		/**
		 * @brief 	Creates a new ShopButton and adds it to the stage
		 * 
		 * @param	bx	X coordinate
		 * @param	by	Y coordinate
		 * @param	i	The index to fetch information from in the attribute vectors
		 * @param	index	The index to be stored in the buttons_ vector
		 */
		private function addShopButton(bx:uint, by:uint, i:uint, index:uint):void {
			
			var cost:int
			
			if (index <= images.length - 1) {
					cost = costs[i] * (Math.pow(cost_increments[i], levels_[i]-1))
					buttons_[index] = new ShopButton(bx, by, images[i], names[i], values[i], cost, cost_increments[i], levels_[i]);
				} else {
					buttons_[index] = new ShopButton(bx, by);
				}
		}
		
		
		
		/**
		 * @brief 	Unlocks upgrade buttons
		 * 
		 * @param	level	The level upgrades to be unlocked
		 * @param	exact	If false, the "level" parameters is the minimum level to unlock, otherwise it'll only unlock the exact level specified
		 */
		private function appendAvailableUpdates(level:uint, exact:Boolean = true):void {
			
			if ((!exact && level >= 2) || (exact && level==2)) {
				images = images.concat(images2);
				names = names.concat(names2);
				values = values.concat(values2);
				costs = costs.concat(costs2);
				cost_increments = cost_increments.concat(cost_increments2);
				levels_ = levels_.concat(levels2);
				if (exact) return;
			}
			if ((!exact && level >= 3) || (exact && level==3)) {
				images = images.concat(images3);
				names = names.concat(names3);
				values = values.concat(values3);
				costs = costs.concat(costs3);
				cost_increments = cost_increments.concat(cost_increments3);
				levels_ = levels_.concat(levels3);
				if (exact) return;
			}
			if ((!exact && level >= 4) || (exact && level==4)) {
				images = images.concat(images4);
				names = names.concat(names4);
				values = values.concat(values4);
				costs = costs.concat(costs4);
				cost_increments = cost_increments.concat(cost_increments4);
				levels_ = levels_.concat(levels4);
				if (exact) return;
			}
		}
		
		
		/**
		 * @brief	Creates all available ShopButtons according to levels_[0]
		 */
		private function addShopButtons():void {
			
			//Create shopping buttons
			var index:int;
			var bx:int;
			var by:int;
			var row:int = 0;
			var column:int = 0;
			
			
			//Change the 1st button image and name if ship has been upgraded
			if (levels_[0] == 2) {
				images[0] = new ship3();
				names[0] = "Destructor";
			} else if (levels_[0] >= 3) {
				images[0] = new ship4();
				names[0] = "Fortress";
			}
			
			
			//Unlock buttons if ship upgrades have been bought
			appendAvailableUpdates(levels_[0], false);

			for (var i:uint = 0; i < 12; i++) {
				index = buttons_.length;
				bx = 150 + 250 * column;
				by = 50 + (250 * row);
				
				addShopButton(bx, by, i, index);
				
				column++;
				if (i == 5) {
					row++;
					column = 0;
				}
				
				buttons_[index].addEventListener(MouseEvent.MOUSE_UP, processShopButtonClicked(index));
			}
		}
		
		
		/**
		 * @brief	Creates shop buttons and exit button
		 */
		private function addObjects():void { 
			addChild(backgr_);
			addChild(points_txt_);
			addChild(lives_txt_);
			
			addShopButtons();
			
			
			//Create next level button
			var square:Graphics = Shapes.getRectangle(600, 500, 150, 100, 0x999999, 1.0).graphics;
			next_.graphics.copyFrom(square);
			square.clear();
			Misc.getStage().addChild(next_);
		}
		
		
		
		/**
		 * @brief 	Replaces a locked button by its unlocked counterpart
		 * @param	index	The index to be used in the parameter vectors
		 */
		private function unlockButton(index:uint):void {
			var oldbtn:ShopButton = buttons_[index];
			var newbtn:ShopButton = new ShopButton(oldbtn.x, oldbtn.y, images[index], names[index], values[index], costs[index], cost_increments[index], levels_[index]);
			oldbtn.remove();
			buttons_[index] = newbtn;
			buttons_[index].addEventListener(MouseEvent.MOUSE_UP, processShopButtonClicked(index));
		}
		
		
		/**
		 * @brief	Executes the appropiate action for the ShopButton clicked
		 * @param	index	The position in buttons_ where the clicked button lives
		 * @return	A MouseEvent function that returns void itself
		 */
		private function processShopButtonClicked(index:int):Function {
			return function (e:MouseEvent):void {
				
				var valid:Boolean = false;
				var i:uint;
				
				//Get out if the player hasn't got enough points
				if (buttons_[index].cost_ > manager_.points_)
					return;
				//Get out if the current ship does not allow this upgrade
				if (buttons_[index].level_ >= levels_[0] * 3) {
					buttons_[index].drawLock();
					return;
				}
				//Get out if the selected button is locked
				if (index >= levels_.length)
					return;
					
				switch(index) {
					case 0:
						valid = true;
						//ship upgrade
						manager_.ship_.removeEventListeners();
						var timg:Sprite;
						
						switch(levels_[0]) {
							case 1:
								manager_.ship_ = new Fighter();
								timg = new ship3();
								appendAvailableUpdates(2);
								unlockButton(6);
								unlockButton(7);
								break;
							case 2:
								manager_.ship_ = new Destructor();
								timg = new ship4();
								appendAvailableUpdates(3);
								unlockButton(8);
								unlockButton(9);
								break;
							case 3:
								manager_.ship_ = new Fortress();
								timg = new ship4();
								appendAvailableUpdates(4);
								unlockButton(10);
								unlockButton(11);
								break;
							default:
								trace("Invalid ship. Exiting method.")
								manager_.ship_.addEventListeners();
								return;
								
						}
						
						//remove locks
						for (i=0; i < buttons_.length; i++) {
							buttons_[i].removeLockSprite();
						}
						
						//Set next ship upgrade sprite and name
						Misc.getStage().removeChild(buttons_[index].img_);
						timg.scaleX = 0.3;
						timg.scaleY = 0.3;
						timg.x = buttons_[index].x + 50;
						timg.y = buttons_[index].y + 60;
						buttons_[index].img_ = timg;
						Misc.getStage().addChild(buttons_[index].img_);
						//Resize ingame ship
						manager_.ship_.mc_.scaleX = 0.5;
						manager_.ship_.mc_.scaleY = 0.5;
						break;
					case 1:
						valid = true;
						manager_.MAX_SHOTS++;
						buttons_[index].value_ = manager_.MAX_SHOTS;
						manager_.createShots();
						trace("You can fire " + manager_.MAX_SHOTS + " at once");
						break;
					case 2:
						valid = true;
						manager_.ship_.init_hp_++;
						manager_.ship_.hp_ = manager_.ship_.init_hp_;
						buttons_[index].value_ = manager_.ship_.init_hp_;
						//manager_.LIFEBAR_WIDTH += 10;
						trace("Ship's armor is now "+manager_.ship_.hp_)
						break;
					case 3:
						valid = true;
						//speed
						manager_.ship_.speed_ += 2;
						buttons_[index].value_ = manager_.ship_.speed_;
						trace("Ship's speed is now " + manager_.ship_.speed_);
						break;
					case 4:
						valid = true;
						//damage
						manager_.mergeShots();
						
						for (i=0; i < manager_.MAX_SHOTS; i++) {
							manager_.spare_shots_[i].damage_ += 0.5;
						}
						
						buttons_[index].value_ =  manager_.spare_shots_[0].damage_;
						trace("Shots damage is now " + manager_.spare_shots_[0].damage_);
						break;
					case 5:
						valid = true;
						manager_.lives_++;
						buttons_[index].value_ = manager_.lives_;
						break;
					case 6:
						valid = true;
						//shield
						manager_.ship_.shield_++;
						manager_.ship_.init_shield_++;
						buttons_[index].value_ = manager_.ship_.shield_;
						trace("Ship's shield is now " + manager_.ship_.shield_);
						manager_.ship_.updateShieldGlow();
						break;
					case 7:
						valid = true;
						//Shield recharge
						manager_.ship_.shield_recharge_++;
						buttons_[index].value_ = manager_.ship_.shield_recharge_;
						trace("Ship's recharge rate is now " + manager_.ship_.shield_recharge_);
						break;
					case 8:
						valid = true;
						//Missile ammo
						manager_.num_missiles_++;
						buttons_[index].value_ = manager_.num_missiles_;
						trace("Ship's MISSILE ammo is now " + manager_.num_missiles_);
						break;
					case 9:
						valid = true;
						//Missile damage
						manager_.missiles_damage_ += 2;
						buttons_[index].value_ = manager_.missiles_damage_;
						trace("MISSILE DAMAGE is now " + manager_.missiles_damage_);
						break;
					case 10:
						valid = true;
						//Lazer ammo
						manager_.num_lazers_++;
						buttons_[index].value_ = manager_.num_lazers_;
						trace("Ship's LAZER ammo is now " + manager_.num_lazers_);
						break;
					case 11:
						valid = true;
						//Lazer damage
						manager_.lazers_damage_ += 2;
						buttons_[index].value_ = manager_.lazers_damage_;
						trace("LAZER DAMAGE is now " + manager_.lazers_damage_);
						break;
					default:
						trace("Unknown shop option");
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
					buttons_[index].removeLevelDots();
					buttons_[index].level_++;
					buttons_[index].drawLevelDots();
					//Play cash money sound
					SoundManager.getInstance().playSFX(3);
				}
			}
		}
		
		
		private function addEventListeners():void {
			addEventListener(Event.ENTER_FRAME, loop);
			next_.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownNext);
		}
		
		
		private function onMouseDownNext(e:MouseEvent):void {
			nextScreen();
		}
		
		
		private function loop(e:Event):void {
			
			points_txt_.text = "Points: " + String(manager_.points_);
			lives_txt_.text = "Lives: " + String(manager_.lives_);
		}

		
		private function nextScreen():void { 
			killScreen();
			Misc.getStage().addChild(manager_.ship_.mc_);
			manager_.ship_.restore();
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
			
			for (var i:uint = 0; i < 12; i++) {
				Misc.getStage().removeChild(buttons_[i]);
			
				//remove all button components
				if (buttons_[i].img_ && buttons_[i].img_.stage) {
					Misc.getStage().removeChild(buttons_[i].img_);
					Misc.getStage().removeChild(buttons_[i].line1_txt_);
					Misc.getStage().removeChild(buttons_[i].line2_txt_);
					buttons_[i].removeLevelDots();
					buttons_[i].removeLockSprite();
				}
					
				delete buttons_[i];
				buttons_[i] = null;
			}
			
			Misc.getStage().removeChild(next_);
			next_ = null;
			
		}
	}

}