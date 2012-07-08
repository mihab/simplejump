package blazin.miha.simplejump.game {
	/**
	 * Contains the Player settings
	 */
	public class PlayerSettings {
		/**
		 * Duration of one player jump in miliseconds
		 */
		public var jumpDuration : int = 2000;
		/**
		 * Vertical distance in pixels of one player jump
		 */
		public var jumpHeight : int = 200;
		/**
		 * Horizontal distance in pixels of one player jump
		 */
		public var jumpDistance : int = 200;
		/**
		 * Player width
		 */
		public var playerWidth : int = 50;
		/**
		 * Player height
		 */
		public var playerHeight : int = 50;
		/**
		 * Color of player box
		 */
		public var playerColor : int = 0x000000;
		/**
		 * Maximum horizontal distance the player can move (from 0)
		 */
		public var maximumDistance : int = 500;
	}
}
