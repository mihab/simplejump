package blazin.miha.simplejump.game {
	/**
	 * Helper class representing one player move
	 */
	public class PlayerMove {
		public var fromX : int;
		public var toX : int;
		public var fromY : int;
		public var toY : int;

		/**
		 * Accepts coordinates of the player move
		 */
		public function PlayerMove(fromX : int, toX : int, fromY : int, toY : int) {
			this.fromX = fromX;
			this.toX = toX;
			this.fromY = fromY;
			this.toY = toY;
		}
	}
}
