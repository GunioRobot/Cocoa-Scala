package cocoa

import scala.collection.mutable.HashMap

/**
 * A simple caching class that creates new elements on demand
 * when there is a cache miss.  This class is thread-safe.
 */
private[cocoa] class Cache[K,V](gen: K=>Option[V]) {
	private val map = new HashMap[K,V]
	
	def apply(key: K): Option[V] = {
		map.synchronized {
			map.get(key) orElse {
				gen(key) match {
					case None => None
					case Some(value) =>
						map(key) = value
						Some(value)
				}
			}
		}
	}
}