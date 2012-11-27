package blazin.miha.simplejump.game {
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	/**
	 * Main player class that moves around the screen. Dispatches events with type: PLAYER_MOVED, PLAYER_FALLING, JUMP_COMPLETE
	 */
	public class Player extends Sprite {
		public static const PLAYER_MOVED : String = "playerMoved";
		public static const PLAYER_FALLING : String = "playerFalling";
		public static const JUMP_COMPLETE : String = "jumpComplete";
		/**
		 * Time jump started
		 */
		private var jumpStartTime : int;
		/**
		 * Y coordinate of player when the jump started
		 */
		private var jumpStartY : int;
		/**
		 * Whether the player is currently moving up or down
		 */
		private var up : Boolean = true;
		/**
		 * Whether right key is down
		 */
		private var rightDown : Boolean = false;
		/**
		 * Whether left key is down
		 */
		private var leftDown : Boolean = false;
		/**
		 * Time either the left key or right key were pushed down
		 */
		private var timeDown : int;
		/**
		 * X coordinate the player was the either the left or the right key was pushed down
		 */
		private var xDown : int;
		/**
		 * Last player move
		 */
		private var lastPlayerMove : PlayerMove;
		/**
		 * Settings of player
		 */
		private var playerSettings : PlayerSettings;

		/**
		 * Constructor that creates the player with the player settings provided
		 */
		public function Player(playerSettings : PlayerSettings) {
			this.playerSettings = playerSettings;
			addEventListener(Event.ENTER_FRAME, onFrame, false, 0, true);
			draw();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}

		/**
		 * Draws the player box
		 */
		public function draw() : void {
			graphics.clear();
			graphics.beginFill(playerSettings.playerColor);
			graphics.drawRect(0, 0, playerSettings.playerWidth, playerSettings.playerHeight);
			graphics.endFill();
		}

		/**
		 * Starts a jump from the current player Y-coordinate
		 */
		public function jump() : void {
			jumpStartTime = new Date().time;
			jumpStartY = y;
			up = true;
			if (!hasEventListener(Event.ENTER_FRAME)) {
				addEventListener(Event.ENTER_FRAME, onFrame, false, 0, true);
			}
		}

		/**
		 * Stops the jump, leaving the player at the current Y coordinates
		 */
		public function stopJump() : void {
			removeEventListener(Event.ENTER_FRAME, onFrame);
		}

		public function getLastPlayerMove() : PlayerMove {
			return lastPlayerMove;
		}

		/**
		 * Add event listeners to stage when added to it 
		 */
		private function init(event : Event = null) : void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp, false, 0, true);
		}

		/**
		 * Main loop which moves the player both on the X and Y coordinates
		 */
		private function onFrame(event : Event = null) : void {
			var jumpComplete : Boolean = false;
			var currentTime : int = new Date().time;
			var time : int = currentTime - jumpStartTime;
			var lastX : int = x;
			var lastY : int = y;
			if (time < playerSettings.jumpDuration) {
				if (up) {
					if (time >= playerSettings.jumpDuration / 2) {
						y = jumpStartY + playerSettings.jumpHeight;
						up = !up;
					}
				}
				// Simple jump animation based on a quad ease
				if (up) {
					y = jumpStartY + quadEaseOut(time, 0, playerSettings.jumpHeight, playerSettings.jumpDuration / 2);
				} else {
					y = (jumpStartY + playerSettings.jumpHeight) - quadEaseIn(time - playerSettings.jumpDuration / 2, 0, playerSettings.jumpHeight, playerSettings.jumpDuration / 2);
				}
			} else {
				y = jumpStartY;
				up = !up;
				jumpStartTime = new Date().time;
				jumpComplete = true;
			}
			// HANDLE KEYBOARD MOVE
			var newX : int;
			if (rightDown) {
				time = currentTime - timeDown;
				newX = (time * playerSettings.jumpDistance) / playerSettings.jumpDuration + xDown;
				if (newX + playerSettings.playerWidth >= playerSettings.maximumDistance) {
					newX = playerSettings.maximumDistance - playerSettings.playerWidth;
				}
				x = newX;
			}
			if (leftDown) {
				time = currentTime - timeDown;
				newX = xDown - (time * playerSettings.jumpDistance) / playerSettings.jumpDuration;
				if (newX <= 0) {
					newX = 0;
				}
				x = newX;
			}
			lastPlayerMove = new PlayerMove(lastX, x, lastY, y);
			dispatchEvent(new Event(PLAYER_MOVED));
			if (!up) {
				dispatchEvent(new Event(PLAYER_FALLING));
			}
			if (jumpComplete) {
				dispatchEvent(new Event(Player.JUMP_COMPLETE));
			}
		}

		/**
		 * Key down handler, starts to move player if left or right key is pressed
		 */
		private function keyDown(event : KeyboardEvent) : void {
			if (event.keyCode == Keyboard.RIGHT) {
				if (!rightDown) {
					leftDown = false;
					rightDown = true;
					timeDown = new Date().time;
					xDown = x;
				}
			}
			if (event.keyCode == Keyboard.LEFT) {
				if (!leftDown) {
					rightDown = false;
					leftDown = true;
					timeDown = new Date().time;
					xDown = x;
				}
			}
		}

		/**
		 * Key up handler, end player move
		 */
		private function keyUp(event : KeyboardEvent) : void {
			if (event.keyCode == Keyboard.RIGHT) {
				rightDown = false;
			}
			if (event.keyCode == Keyboard.LEFT) {
				leftDown = false;
			}
		}

		/**
		 * Simple quad ease in used for player falling
		 */
		private function quadEaseIn(t : Number, b : Number, c : Number, d : Number) : Number {
			return c * (t /= d) * t + b;
		}

		/**
		 * Simple quad ease out used for player falling raising
		 */
		private function quadEaseOut(t : Number, b : Number, c : Number, d : Number) : Number {
			return -c * (t /= d) * (t - 2) + b;
		}
	}
}
