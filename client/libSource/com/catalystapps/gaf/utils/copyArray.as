package com.catalystapps.gaf.utils
{
	/**
	 * @private
	 */
	public function copyArray(from: Array, to: Array): void
	{
		var l: uint = from.length;

		for (var i: uint = 0; i < l; ++i)
		{
			to[i] = from[i];
		}
	}
}