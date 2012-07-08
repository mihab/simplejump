package blazin.miha.simplejump.game {
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.display.Sprite;

	/**
	 * Main game class that instanties the the level and scoreboard. Dispatches event with type: GAME_OVER
	 */
	public class Game extends Sprite {
		public static const GAME_OVER : String = "gameOver";
		/**
		 * Whether player won or lost
		 */
		private var playerWon : Boolean = false;
		/**
		 * Sprite level holder so the Level sprite can safely moving into negative Y coordinates
		 */
		private var levelHolder : Sprite;
		/**
		 * Level instance
		 */
		private var level : Level;
		/**
		 * Score board used for displaying the current score
		 */
		private var scoreBoard : TextField;
		/**
		 * Current player score
		 */
		private var score : int = 0;

		/**
		 * Constructor that creates the level and scoreboard
		 */
		public function Game() {
			levelHolder = new Sprite();
			levelHolder.y = 50;
			addChild(levelHolder);
			var levelSettings : LevelSettings = new LevelSettings();
			level = new Level(levelSettings, new PlayerSettings(), new PlatformSettings());
			levelHolder.addChild(level);
			level.addEventListener(Level.GAME_OVER, gameOver, false, 0, true);
			level.addEventListener(Level.SCORE_CHANGE, updateScore, false, 0, true);
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			var format : TextFormat = new TextFormat();
			format.font = "Verdana";
			format.color = 0x000000;
			format.size = 35;
			format.align = "center";
			scoreBoard = new TextField();
			scoreBoard.selectable = false;
			scoreBoard.background = true;
			scoreBoard.backgroundColor = 0xafffff;
			scoreBoard.defaultTextFormat = format;
			scoreBoard.width = levelSettings.levelWidth;
			scoreBoard.height = 50;
			scoreBoard.text = "Score : 0";
			addChild(scoreBoard);
		}

		/**
		 * Whether player won or lost
		 */
		public function getPlayerWon() : Boolean {
			return playerWon;
		}

		/**
		 * Get final score of game, regardless if player won or lost
		 */
		public function getFinalScore() : int {
			return score;
		}

		/**
		 * Gives focus to level when added to stage
		 */
		private function init(event : Event = null) : void {
			level.focusRect = false;
			stage.focus = level;
		}

		/**
		 * Game over event handler. Dispatches appropriate event
		 */
		private function gameOver(event : Event) : void {
			removeChild(levelHolder);
			playerWon = level.getPlayerWon();
			score = level.getScore();
			dispatchEvent(new Event(GAME_OVER));
		}

		/**
		 * Updates the score board when level score changes
		 */
		private function updateScore(event : Event) : void {
			score = level.getScore();
			scoreBoard.text = "Score : " + score;
		}
	}
}
