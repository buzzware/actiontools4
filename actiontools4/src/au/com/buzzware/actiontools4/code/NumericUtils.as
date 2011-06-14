/**
 * Created by IntelliJ IDEA.
 * User: gary
 * Date: 13/06/11
 * Time: 7:56 PM
 * To change this template use File | Settings | File Templates.
 */
package au.com.buzzware.actiontools4.code {
public class NumericUtils {
	public function NumericUtils() {
	}

	public static function randomInt(aRange:int):int {
		return Math.floor(Math.random() * aRange)
	}

	public static function randomIntRange(aFrom:int, aTo:int):int {
		return aFrom + randomInt(aTo - aFrom + 1)
	}
}
}
