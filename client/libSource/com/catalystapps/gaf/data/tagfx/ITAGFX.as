/**
 * Created by Nazar on 12.01.2016.
 */
package com.catalystapps.gaf.data.tagfx
{
	import flash.events.IEventDispatcher;
	import flash.geom.Point;

	import starling.textures.Texture;

	/**
	 * @private
	 */
	public interface ITAGFX extends IEventDispatcher
	{
		function get texture(): Texture;
		function get textureSize(): Point;
		function get textureScale(): Number;
		function get textureFormat(): String;
		function get sourceType(): String;
		function get source(): *;
		function get ready(): Boolean;
	}
}
