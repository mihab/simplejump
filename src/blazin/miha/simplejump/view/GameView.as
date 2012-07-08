package blazin.miha.simplejump.view {
	import blazin.miha.simplejump.game.Game;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * GameView class instanties the game and displays it. Dispatches event with type: GAME_OVER
	 */
	public class GameView extends Sprite {
		public static const GAME_OVER : String = "gameOver";
		private var playerWon : Boolean = false;
		private var game : Game;
		private var finalScore : int;

		/**
		 * Instanties and starts the game
		 */
		public function startGame() : void {
			game = new Game();
			addChild(game);
			game.addEventListener(Game.GAME_OVER, gameOver, false, 0, true);
		}

		/**
		 * Return whether player won or lost
		 */
		public function getPlayerWon() : Boolean {
			return playerWon;
		}

		/**
		 * Return the final score of the game, regardless if player won or lost
		 */
		public function getFinalScore() : int {
			return finalScore;
		}

		/**
		 * Removes the game from the display list and dispatches GAME_OVER event
		 */
		private function gameOver(event : Event) : void {
			removeChild(game);
			playerWon = game.getPlayerWon();
			finalScore = game.getFinalScore();
			dispatchEvent(new Event(GAME_OVER));
		}
	}
}
