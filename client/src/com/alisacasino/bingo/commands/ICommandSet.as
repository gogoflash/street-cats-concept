package com.alisacasino.bingo.commands 
{
	
	/**
	 * ...
	 * @author Dmitriy Barabanschikov
	 */
	public interface ICommandSet extends ICommand
	{
		
		function addCommandToSet(command:ICommand):ICommandSet;
	}
	
}