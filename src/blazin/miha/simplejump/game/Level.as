package blazin.miha.simplejump.game {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.display.Sprite;

	/**
	 * Level game class that contains the player and platform. Dispatches events with type: GAME_OVER, SCORE_CHANGE
	 */
	public class Level extends Sprite {
		public static const GAME_OVER : String = "gameOver";
		public static const SCORE_CHANGE : String = "scoreChange";
		/**
		 * Settings of level
		 */
		private var levelSettings : LevelSettings;
		/**
		 * Settings of player
		 */
		private var playerSettings : PlayerSettings;
		/**
		 * Settings of platform
		 */
		private var platformSettings : PlatformSettings;
		/**
		 * Array containing all the platform in ascending (Y) order
		 */
		private var platforms : Array = new Array();
		/**
		 * Player instance
		 */
		private var player : Player;
		/**
		 * Y coordinate of camera when it started moving
		 */
		private var cameraStartY : int;
		/**
		 * Y coordinate where camera should move
		 */
		private var cameraEndY : int;
		/**
		 * Time of camera move start
		 */
		private var cameraStartTime : int;
		/**
		 * Timer used for camera animation
		 */
		private var cameraTimer : Timer = new Timer(10);
		/**
		 * Whether player won or lost
		 */
		private var playerWon : Boolean = false;
		/**
		 * Last platform the player jumped on
		 */
		private var lastPlatform : Platform;
		/**
		 * Player score
		 */
		private var score : int = 0;

		/**
		 * Creates a new level given the level, player and platform settings. Also generates the platforms and add the player
		 */
		public function Level(levelSettings : LevelSettings, playerSettings : PlayerSettings, platformSettings : PlatformSettings) {
			this.levelSettings = levelSettings;
			this.playerSettings = playerSettings;
			this.platformSettings = platformSettings;
			cameraTimer.addEventListener(TimerEvent.TIMER, moveCameraAnimation, false, 0, true);
			draw();
			generatePlatforms();
			addPlayer();
		}

		/**
		 * Draws the level background
		 */
		public function draw() : void {
			graphics.clear();
			graphics.beginFill(levelSettings.levelColor);
			graphics.drawRect(0, 0, levelSettings.levelWidth, levelSettings.levelHeight);
			graphics.endFill();
		}

		/**
		 * Return whether the player won or lost
		 */
		public function getPlayerWon() : Boolean {
			return playerWon;
		}

		/**
		 * Returns the player score
		 */
		public function getScore() : int {
			return score;
		}

		/**
		 * Randomly generates the platforms
		 */
		private function generatePlatforms() : void {
			var lastPlatformX : int = 0;
			var lastPlatformY : int = 0;
			var platform : Platform = new Platform(platformSettings);
			lastPlatform = platform;
			addChild(platform);
			platforms.push(platform);
			platform.x = lastPlatformX = levelSettings.levelWidth / 2 - platformSettings.platformWidth / 2;
			var end : Boolean = false;
			while (!end) {
				var distance : int = Math.random() * (playerSettings.jumpDistance - playerSettings.playerWidth);
				var direction : int = Math.round(Math.random());
				var newX : int = 0;
				if (direction == 0) {
					// left
					newX = lastPlatformX - distance;
					if (newX <= 0) {
						newX = 0;
					}
				} else {
					// right
					newX = lastPlatformX + distance;
					if (newX + platformSettings.platformWidth >= levelSettings.levelWidth) {
						newX = levelSettings.levelWidth - platformSettings.platformWidth;
					}
				}
				var newY : int = lastPlatformY + Math.random() * (playerSettings.jumpHeight - playerSettings.playerHeight);
				if (newY - lastPlatformY < platformSettings.platformHeight) {
					newY = lastPlatformY + platformSettings.platformHeight;
				}
				if (newY >= levelSettings.levelHeight - platformSettings.platformHeight - playerSettings.playerHeight - playerSettings.jumpHeight) {
					newY = levelSettings.levelHeight - platformSettings.platformHeight - playerSettings.playerHeight - playerSettings.jumpHeight;
					end = true;
				}
				if (end) {
					var lastPlatformSettings : PlatformSettings = new PlatformSettings();
					lastPlatformSettings.platformColor = platformSettings.platformColor;
					lastPlatformSettings.platformHeight = platformSettings.platformHeight;
					lastPlatformSettings.platformWidth = levelSettings.levelWidth;
					platform = new Platform(lastPlatformSettings);
					platform.x = 0;
				} else {
					platform = new Platform(platformSettings);
					platform.x = newX;
				}
				addChild(platform);
				platforms.push(platform);
				platform.y = newY;
				lastPlatformX = newX;
				lastPlatformY = newY;
			}
		}

		/**
		 * Configures the player and adds him to the stage
		 */
		private function addPlayer() : void {
			player = new Player(playerSettings);
			addChild(player);
			player.x = levelSettings.levelWidth / 2 - playerSettings.playerWidth / 2;
			player.jump();
			player.addEventListener(Player.PLAYER_FALLING, playerFalling, false, 0, true);
			player.addEventListener(Player.JUMP_COMPLETE, jumpComplete, false, 0, true);
		}

		/**
		 * Handler when player falling. Checks for intersects with platforms
		 */
		private function playerFalling(event : Event) : void {
			var platform : Platform = checkIntersects();
			if (platform != null) {
				player.y = platform.y + platformSettings.platformHeight;
				player.jump();
				moveCamera();
				updateScore(platform);
				checkGameOver(platform);
			}
		}

		/**
		 * Handler for player jump complete. Checks for game over
		 */
		private function jumpComplete(event : Event) : void {
			checkGameOver();
		}

		/**
		 * Check if interesects, starting from up to bottom. The first platform that intersects is returned, or null if none intersects
		 */
		private function checkIntersects() : Platform {
			for (var i : int = platforms.length - 1; i >= 0; i--) {
				var platform : Platform = platforms[i];
				if (platform.checkInteresects(player)) {
					return platform;
				}
			}
			return null;
		}

		/**
		 * Checks for game over. This can be in 2 cases: player reached the end or player missed the platform on jump complete
		 */
		private function checkGameOver(platform : Platform = null) : void {
			if (platform == null) {
				platform = checkIntersects();
			}
			if (platform == null) {
				dispatchEvent(new Event(GAME_OVER));
				player.stopJump();
			} else {
				if (platform == platforms[platforms.length - 1]) {
					playerWon = true;
					dispatchEvent(new Event(GAME_OVER));
					player.stopJump();
				}
			}
		}

		/**
		 * Updates the score when player successfully jumped on a platform and dispatches appropriate event
		 */
		private function updateScore(platform : Platform) : void {
			if (platform != lastPlatform) {
				lastPlatform = platform;
				score += levelSettings.platformScorePoints;
				dispatchEvent(new Event(Level.SCORE_CHANGE));
			}
		}

		/**
		 * Start to move camera
		 */
		private function moveCamera() : void {
			cameraStartY = -y;
			cameraEndY = player.y - platformSettings.platformHeight;
			cameraStartTime = new Date().time;
			cameraTimer.reset();
			cameraTimer.start();
		}

		/**
		 * Simple camera animation to follow the player
		 */
		private function moveCameraAnimation(event : Event) : void {
			var currentTime : int = new Date().time;
			var time : int = currentTime - cameraStartTime;
			var duration : int = playerSettings.jumpDuration / 2;
			if (time < duration) {
				// Simple linear easing
				var newY : int = cameraStartY + linear(time, 0, cameraEndY - cameraStartY, duration);
				y = -newY;
			} else {
				y = -cameraEndY;
				cameraTimer.reset();
			}
		}

		/**
		 * Simple linear easing
		 */
		private function linear(t : Number, b : Number, c : Number, d : Number) : Number {
			return c * t / d + b;
		}
	}
}
