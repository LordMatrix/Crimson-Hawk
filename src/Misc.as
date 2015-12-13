package  
{
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author Marcos Vazquez
	 */
	//Static class
	
	public class Misc {
		
		private static var _main:*;
		private static var _stage:Stage;
		private static var _stageHeight:uint;
		private static var _stageWidth:uint;
		
		
		public static function setMain(main:*) :void {
			_main = main;
			_stage = main.stage;
			_stageHeight = main.stage.stageHeight;
			_stageWidth = main.stage.stageWidth;
		}
		
		public static function getMain():* {
			return _main;
		}
		
		static public function getStage():Stage {
			return _stage;
		}
		
		static public function getStageHeight():uint {
			return _stageHeight;
		}
		
		static public function getStageWidth():uint {
			return _stageWidth;
		}
		
		static public function getTextField(msg:String, x:uint, y:uint, size:uint, color:uint):TextField {
			
			var text:TextField = new TextField();
			text.x = x;
			text.y = y;
			text.width = size*10 + 100;
			text.height = size*2;
			
			var format:TextFormat = new TextFormat();
			format.size = size;
			format.align = TextFormatAlign.CENTER;
			format.color = color;
			
			text.defaultTextFormat = format;
			text.text = msg;
			
			return text;
		}
		
		static public function random(min:uint, max:uint):uint {
			return (Math.floor(Math.random() * (max - min + 1)) + min);
		}
		
		static public function randomSign():int {
			if (Math.random() < 0.5) return 1;
			else return -1;
		}
	}

}