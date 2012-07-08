package blazin.miha.simplejump.view {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.display.Sprite;

	/**
	 * Start view with player button. Dispatches event with type: PLAY_CLICKED
	 */
	public class StartView extends Sprite {
		public static const PLAY_CLICKED : String = "playClicked";
		private var viewWidth : int;
		private var viewHeight : int;
		private var playButton : TextField;

		/**
		 * Creates the component and all child components
		 */
		public function StartView(viewWidth : int, viewHeight : int) {
			this.viewWidth = viewWidth;
			this.viewHeight = viewHeight;
			draw();
			playButton = new TextField();
			playButton.background = true;
			playButton.selectable = false;
			playButton.backgroundColor = 0x87cefa;
			playButton.addEventListener(MouseEvent.MOUSE_DOWN, function(event : Event) : void {
				playButton.backgroundColor = 0x1e90ff;
			});
			playButton.addEventListener(MouseEvent.MOUSE_OVER, function(event : Event) : void {
				playButton.backgroundColor = 0x00bfff;
			});
			playButton.addEventListener(MouseEvent.MOUSE_OUT, function(event : Event) : void {
				playButton.backgroundColor = 0x87cefa;
			});
			playButton.addEventListener(MouseEvent.MOUSE_UP, function(event : Event) : void {
				playButton.backgroundColor = 0x00bfff;
			});
			playButton.addEventListener(MouseEvent.CLICK, function(event : Event) : void {
				dispatchEvent(new Event(PLAY_CLICKED));
			});
			var format : TextFormat = new TextFormat();
			format.font = "Verdana";
			format.color = 0x000000;
			format.size = 35;
			format.align = "center";
			playButton.defaultTextFormat = format;
			playButton.width = 150;
			playButton.height = 50;
			playButton.x = viewWidth / 2 - 75;
			playButton.y = viewHeight / 2 - 25;
			playButton.text = "PLAY!";
			addChild(playButton);
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
	}
}
