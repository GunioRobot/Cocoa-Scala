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
	
	def update(key: K, v: V) {
		map.synchronized {
			map(key) = v
		}
	}
	
	def contains(key: K) = map.contains(key)
}

private[cocoa] object Cache {
	def opt[K,V](gen: K=>Option[V]) = new Cache[K,V](gen)
	def strict[K,V](gen: K=>V) = new Cache[K,V](key => {
		val v = gen(key)
		if (v == null) None
		else Some(v)
	})
}