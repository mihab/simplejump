package blazin.miha.simplejump {
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	import blazin.miha.simplejump.view.EndView;
	import blazin.miha.simplejump.view.GameView;
	import blazin.miha.simplejump.view.StartView;

	import flash.events.Event;
	import flash.display.Sprite;

	/**
	 * Main class of Simple Jump game
	 */
	[SWF(frameRate="30")]
	public class SimpleJump extends Sprite {
		private var startView : StartView;
		private var gameView : GameView;
		private var endView : EndView;
		private var applicationWidth : int = 500;

		public function SimpleJump() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}

		/**
		 * Initializes game
		 */
		private function init(event : Event = null) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(Event.RESIZE, resize);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP;
			resize();
		}

		/**
		 * Resizes and sets up the elements
		 */
		private function resize(event : Event = null) : void {
			removeChildren();
			var stageBackground : Sprite = new Sprite();
			stageBackground.graphics.beginFill(0xe0ffff);
			stageBackground.graphics.drawRect(0, 0, applicationWidth, stage.stageHeight);
			addChild(stageBackground);
			startView = new StartView(applicationWidth, stage.stageHeight);
			startView.addEventListener(StartView.PLAY_CLICKED, startGame, false, 0, true);
			addChild(startView);
			gameView = new GameView();
			gameView.addEventListener(GameView.GAME_OVER, gameOver, false, 0, true);
			endView = new EndView(applicationWidth, stage.stageHeight);
			endView.addEventListener(EndView.BACK_TO_START_CLICKED, backToStart, false, 0, true);
		}

		/**
		 * Start game after player clicked the play button
		 */
		private function startGame(event : Event) : void {
			stage.removeEventListener(Event.RESIZE, resize);
			removeChild(startView);
			addChild(gameView);
			gameView.startGame();
		}

		/**
		 * Shows the game results
		 */
		private function gameOver(event : Event) : void {
			removeChild(gameView);
			addChild(endView);
			endView.setResult(gameView.getPlayerWon(), gameView.getFinalScore());
		}

		/**
		 * Resets game back to start view
		 */
		private function backToStart(event : Event) : void {
			removeChild(endView);
			addChild(startView);
		}
	}
}
