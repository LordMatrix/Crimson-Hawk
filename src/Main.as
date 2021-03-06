//SoundAS gestiona sonidos (github)
//texture packer para crear spritesheets
package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import screens.game;
	import screens.gameover;
	import screens.shop;
	import screens.welcome;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import com.greensock.*;
	
	/**
	 * ...
	 * @author Marcos Vazquez
	 * 
	 * The main class where everything begins
	 */
	public class Main extends Sprite 
	{
		
		private var miMC:MovieClip = new MovieClip();
		private var welcomeScreen:welcome;
		private var gameScreen:game;
		private var shopScreen:shop;
		private var gameOverScreen:gameover;
		
		/**
		 * @brief The program's entry point
		 */
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * @brief 	sets this instance as main and loads the welcome screen
		 * @param	e ADDED_TO_STAGE event
		 */
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			trace("Main");
			Misc.setMain(this);
			loadScreen(1);
		}
		
		
		/**
		 * @brief 	Loads a new screen and starts playing its music
		 * @param	num	Screen number to be loaded
		 */
		public function loadScreen(num:uint):void {
			switch(num) {
				case 1:
					SoundManager.getInstance().playMusic(0);
					welcomeScreen = new welcome();
					addChild(welcomeScreen);
					break;
				case 2:
					var level:uint = GameManager.getInstance().current_level_;
					SoundManager.getInstance().playMusic((level - 1) % 4 + 1);
					GameManager.getInstance().current_level_++;
					gameScreen = new game();
					addChild(gameScreen);
					break;
				case 3:
					SoundManager.getInstance().playMusic(0);
					shopScreen = new shop();
					addChild(shopScreen);
					break;
				case 4:
					SoundManager.getInstance().playMusicOnce(5);
					gameOverScreen = new gameover();
					addChild(gameOverScreen);
					//Restart shop levels
					shop.levels_ = new <int>[1, 1, 1, 1, 1, 0];
					break;
				default:
					trace ("Screen unknown");
			}
		}
		
	}
	
}