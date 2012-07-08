package blazin.miha.simplejump.view {
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.display.Sprite;

	/**
	 * Final view that displays the game results. Dispatches event with type: BACK_TO_START_CLICKED
	 */
	public class EndView extends Sprite {
		public static const BACK_TO_START_CLICKED : String = "backToStartClicked";
		private var viewWidth : int;
		private var viewHeight : int;
		private var backToStartButton : TextField;
		private var resultTextField : TextField;
		private var scoreTextField : TextField;

		/**
		 * Creates the component and all child components
		 */
		public function EndView(viewWidth : int, viewHeight : int) {
			this.viewWidth = viewWidth;
			this.viewHeight = viewHeight;
			draw();
			backToStartButton = new TextField();
			backToStartButton.background = true;
			backToStartButton.selectable = false;
			backToStartButton.backgroundColor = 0x87cefa;
			backToStartButton.addEventListener(MouseEvent.MOUSE_DOWN, function(event : Event) : void {
				backToStartButton.backgroundColor = 0x1e90ff;
			});
			backToStartButton.addEventListener(MouseEvent.MOUSE_OVER, function(event : Event) : void {
				backToStartButton.backgroundColor = 0x00bfff;
			});
			backToStartButton.addEventListener(MouseEvent.MOUSE_OUT, function(event : Event) : void {
				backToStartButton.backgroundColor = 0x87cefa;
			});
			backToStartButton.addEventListener(MouseEvent.MOUSE_UP, function(event : Event) : void {
				backToStartButton.backgroundColor = 0x00bfff;
			});
			backToStartButton.addEventListener(MouseEvent.CLICK, function(event : Event) : void {
				dispatchEvent(new Event(BACK_TO_START_CLICKED));
			});
			var format : TextFormat = new TextFormat();
			format.font = "Verdana";
			format.color = 0x000000;
			format.size = 35;
			format.align = "center";
			backToStartButton.defaultTextFormat = format;
			backToStartButton.width = 300;
			backToStartButton.height = 50;
			backToStartButton.x = viewWidth / 2 - 150;
			backToStartButton.y = viewHeight / 2 + 25;
			backToStartButton.text = "BACK TO START";
			addChild(backToStartButton);
			resultTextField = new TextField();
			resultTextField.selectable = false;
			resultTextField.defaultTextFormat = format;
			resultTextField.width = viewWidth;
			resultTextField.height = 50;
			resultTextField.y = viewHeight / 2 - 75;
			addChild(resultTextField);
			scoreTextField = new TextField();
			scoreTextField.selectable = false;
			scoreTextField.defaultTextFormat = format;
			scoreTextField.width = viewWidth;
			scoreTextField.height = 50;
			scoreTextField.y = viewHeight / 2 - 25;
			addChild(scoreTextField);
		}

		/**
		 * Draws the background for the view
		 */
		public function draw() : void {
			graphics.clear();
			graphics.beginFill(0xe0ffff);
			graphics.drawRect(0, 0, viewWidth, viewHeight);
			graphics.endFill();
		}

		/**
		 * Set whether the player won or lost along with the final score
		 */
		public function setResult(won : Boolean, score : int) : void {
			if (won) {
				resultTextField.text = resultTextField.text = "Game Over. You Won!";
			} else {
				resultTextField.text = resultTextField.text = "Game Over. You Lost!";
			}
			scoreTextField.text = "Final Score: " + score;
		}
	}
}
