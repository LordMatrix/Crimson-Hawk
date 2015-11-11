package screens 
{
	import adobe.utils.CustomActions;
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author Lord Matrix
	 */
	public class select extends MovieClip
	{
		private var fondoMC:MovieClip;
		private var jakeMC:MovieClip;
		private var finnMC:MovieClip;
		private var logoMC:MovieClip;
		private var selectText:TextField;
		private var nickBox:TextField;
		private var GoSignMC:MovieClip;
		
		
		public function select() {
			super();
			trace("select");
			initScreen();
			addEventListeners();
			addObjects();
		}
		
		
		private function initScreen():void {
			fondoMC = new fondoCharacter();
			jakeMC = new Jake();
			finnMC = new Finn();
			logoMC = new logoCharacter();
			
			selectText = Misc.getTextField("Select your character", (Misc.getStageWidth() / 2) - 170, 50);
			nickBox = createNickBox();
			
			GoSignMC = new Go();
		}
		
		private function createNickBox():TextField {
			var textBox:TextField = new TextField();
			
			textBox.type = "input";
			
			var format:TextFormat = new TextFormat();
			format.size = 23;
			format.align = TextFormatAlign.CENTER;
			format.color = 0x000000;
			textBox.defaultTextFormat = format;
			
			textBox.x = (Misc.getStageWidth() / 2) - 170;
			textBox.y = Misc.getStageHeight() - 100;
			textBox.text = "Your nickname";
			textBox.border = true;
			textBox.width = 300;
			textBox.height = 50;
			textBox.background = true;
			textBox.backgroundColor = 0xF5F1DE;
			
			return textBox;
		}
		
		private function addObjects():void { 
			addChild(fondoMC);
			
			jakeMC.x = (Misc.getStageWidth() / 2) - 220;
			jakeMC.y = Misc.getStageHeight() - 320;
			addChild(jakeMC);
			
			finnMC.x = (Misc.getStageWidth() / 2) + 30;
			finnMC.y = Misc.getStageHeight() - 400;
			addChild(finnMC);
			
			logoMC.x = Misc.getStageWidth() - 200;
			logoMC.y = 20;
			addChild(logoMC);
			
			addChild(selectText);
			addChild(nickBox);
			
			GoSignMC.x = 650;
			GoSignMC.y = Misc.getStageHeight() - 90;
			addChild(GoSignMC);
		}
		
		
		private function addEventListeners():void {
			
			jakeMC.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverJake);
			finnMC.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverFinn);
			jakeMC.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownJake);
			finnMC.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownFinn);
			
			nickBox.addEventListener(FocusEvent.FOCUS_IN, onFocusInNickBox);
			nickBox.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutNickBox);
			
			GoSignMC.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownGoSign);
		}
		
		private function onMouseOverJake(e:MouseEvent):void {
			TweenMax.to(jakeMC, 0, {blurFilter:{blurX:7, blurY:7, quality:3, remove:true}});
			TweenMax.to(finnMC, 0.25, {blurFilter:{blurX:7, blurY:7, quality:3}});
		}
		
		private function onMouseOverFinn(e:MouseEvent):void {
			TweenMax.to(finnMC, 0, {blurFilter:{blurX:7, blurY:7, quality:3, remove:true}});
			TweenMax.to(jakeMC, 0.25, {blurFilter:{blurX:7, blurY:7, quality:3}});
		}
		
		private function onMouseDownFinn(e:MouseEvent):void {
			TweenMax.to(jakeMC, 0, {glowFilter:{color:0xff0000, alpha:1, blurX:20, blurY:20, strength:1, quality:3, remove:true}});
			TweenMax.to(finnMC, 0.25, { glowFilter: { color:0xff0000, alpha:1, blurX:20, blurY:20, strength:1, quality:3 }} );
			Misc.getMain().character = 1;
		}
		
		private function onMouseDownJake(e:MouseEvent):void {
			TweenMax.to(finnMC, 0, {glowFilter:{color:0xff0000, alpha:1, blurX:20, blurY:20, strength:1, quality:3, remove:true}});
			TweenMax.to(jakeMC, 0.25, { glowFilter: { color:0xff0000, alpha:1, blurX:20, blurY:20, strength:1, quality:3 }} );
			Misc.getMain().character = 0;
		}
		
		private function onFocusInNickBox(e:FocusEvent):void {
			nickBox.text = '';
		}
		
		private function onFocusOutNickBox(e:FocusEvent):void {
			if (nickBox.text == '')
				nickBox.text = 'Your nickname';
		}
		
		private function onMouseDownGoSign(e:MouseEvent):void {
			Misc.getMain().nick = nickBox.text;
			nextScreen();
		}
		
		
		private function nextScreen():void { 
			killScreen();
			Misc.getMain().loadScreen(3);
		}
		
		private function killScreen():void {
			removeEventListeners();
			removeObjects();
		}
		
		private function removeEventListeners():void {
			jakeMC.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOverJake);
			finnMC.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOverFinn);
			jakeMC.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownJake);
			finnMC.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownFinn);
		}
		
		private function removeObjects():void {
			removeChild(fondoMC);
			fondoMC = null;
			removeChild(jakeMC);
			jakeMC = null;
			removeChild(finnMC);
			finnMC = null;
			removeChild(logoMC);
			logoMC = null;
			removeChild(selectText);
			selectText = null;
			removeChild(nickBox);
			nickBox = null;
			removeChild(GoSignMC);
			GoSignMC = null;
		}
	}

}