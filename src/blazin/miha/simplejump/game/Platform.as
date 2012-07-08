package blazin.miha.simplejump.game {
	import flash.geom.Point;
	import flash.display.Sprite;

	/**
	 * Platform class that draws a single platform and check for intersects with player moves with it
	 */
	public class Platform extends Sprite {
		/**
		 * Settings of platform
		 */
		private var platformSettings : PlatformSettings;

		/**
		 * Creates the platform given the platform settings
		 */
		public function Platform(platformSettings : PlatformSettings) {
			this.platformSettings = platformSettings;
			draw();
		}

		/**
		 * Draws the platform rectangle
		 */
		public function draw() : void {
			graphics.clear();
			graphics.beginFill(platformSettings.platformColor);
			graphics.drawRect(0, 0, platformSettings.platformWidth, platformSettings.platformHeight);
			graphics.endFill();
		}

		/**
		 * Checks whether the given PlayerMove intersected with this platform
		 */
		public function checkInteresects(player : Player) : Boolean {
			var playerMove : PlayerMove = player.getLastPlayerMove();
			var A : Point = new Point(x, y + platformSettings.platformHeight);
			var B : Point = new Point(x + platformSettings.platformWidth, y + platformSettings.platformHeight);
			var E : Point = new Point(playerMove.fromX, playerMove.fromY);
			var F : Point = new Point(playerMove.toX, playerMove.toY);
			if (lineIntersectLine(A, B, E, F)) {
				return true;
			}
			E = new Point(playerMove.fromX + player.width, playerMove.fromY);
			F = new Point(playerMove.toX + player.width, playerMove.toY);
			if (lineIntersectLine(A, B, E, F)) {
				return true;
			}
			return false;
		}

		/**
		 * Checks whether two line segments intersect
		 */
		private function lineIntersectLine(A : Point, B : Point, E : Point, F : Point) : Boolean {
			var ip : Point;
			var a1 : Number;
			var a2 : Number;
			var b1 : Number;
			var b2 : Number;
			var c1 : Number;
			var c2 : Number;
			a1 = B.y - A.y;
			b1 = A.x - B.x;
			c1 = B.x * A.y - A.x * B.y;
			a2 = F.y - E.y;
			b2 = E.x - F.x;
			c2 = F.x * E.y - E.x * F.y;
			var denom : Number = a1 * b2 - a2 * b1;
			if (denom == 0) {
				return false;
			}
			ip = new Point();
			ip.x = (b1 * c2 - b2 * c1) / denom;
			ip.y = (a2 * c1 - a1 * c2) / denom;
			if (Math.pow(ip.x - B.x, 2) + Math.pow(ip.y - B.y, 2) > Math.pow(A.x - B.x, 2) + Math.pow(A.y - B.y, 2)) {
				return false;
			}
			if (Math.pow(ip.x - A.x, 2) + Math.pow(ip.y - A.y, 2) > Math.pow(A.x - B.x, 2) + Math.pow(A.y - B.y, 2)) {
				return false;
			}

			if (Math.pow(ip.x - F.x, 2) + Math.pow(ip.y - F.y, 2) > Math.pow(E.x - F.x, 2) + Math.pow(E.y - F.y, 2)) {
				return false;
			}
			if (Math.pow(ip.x - E.x, 2) + Math.pow(ip.y - E.y, 2) > Math.pow(E.x - F.x, 2) + Math.pow(E.y - F.y, 2)) {
				return false;
			}
			return true;
		}
	}
}
