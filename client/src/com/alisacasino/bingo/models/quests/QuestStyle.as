package com.alisacasino.bingo.models.quests 
{
	import by.blooddy.crypto.MD5;
	
	public class QuestStyle 
	{
		public static const PURPLE	:uint = 0x6b4ea9; /*фиолетовый*/
		public static const BLUE	:uint = 0x0886ef; /*синий*/
		public static const GREEN	:uint = 0x3eb93e; /*зеленый*/
		public static const RED		:uint = 0xd81f27; /*красный*/
		public static const DARK_BLUE:uint = 0x00e4ff; /*темно-голубой*/
		public static const YELLOW	:uint = 0xffde00; /*желтый*/
		public static const DEEP_BLUE:uint = 0x311b91; /*темно-синий*/
		public static const PINK	:uint = 0xff00f0; /*розовый*/
		public static const ORANGE	:uint = 0xff8400; /*оранжевый*/
		
		
		public var backgroundColor:uint;
		public var progressColor:uint;
		public var textColor:String;
		
		private var _hash:String;
		
		public function QuestStyle(backgroundColor:uint, progressColor:uint, textColor:String) 
		{
			this.backgroundColor = backgroundColor;
			this.progressColor = progressColor;
			this.textColor = textColor;
		}
		
		public function get hash():String {
			if (!_hash)
				_hash = MD5.hash(backgroundColor.toString() + progressColor.toString() + textColor.toString());
			return _hash;
		}
		
		public static function init():void
		{
			allStyles = [];
			styles = {};
			stylesByHash = {};
			
			//add('', 0x6b4ea9/*фиолетовый*/, 0x5aff00/*зеленый*/, '#8ce380'/*зеленый*/);
			//add('', 0x0886ef/*синий*/, 0x5aff00/*зеленый*/, '#ffff00'/*желтый*/);
			//add('', 0x3eb93e/*зеленый*/, 0xff00f0/*лиловый*/, '#ffff00'/*желтый*/);
			//add('', 0xd81f27/*красный*/, 0xffff00/*желтый*/, '#ffff00'/*желтый*/);
			//add('', 0x2accc4/*голубой*/, 0xd9b3ff/*сиреневый*/, '#ffff00'/*желтый*/);
			
			add('', PURPLE/*фиолетовый*/, 0x2be400/*зеленый*/, '#ffff00'/*желтый*/);
			add('', BLUE/*синий*/, 0x2be400/*зеленый*/, '#ffff00'/*желтый*/);
			add('', GREEN/*зеленый*/, 0xff00f0/*лиловый*/, '#ffff00'/*желтый*/);
			add('', RED/*красный*/, 0xffde00/*желтый*/, '#ffff00'/*желтый*/);
			add('', DARK_BLUE/*темно-голубой*/, 0xffce87/*бледно-оранжевый*/, '#ffff00'/*желтый*/);
			add('', YELLOW/*желтый*/, 0x00c0ff/*голубой*/, '#ffff00'/*желтый*/);
			add('', DEEP_BLUE/*темно-синий*/, 0xffde00/*желто-оранжевый*/, '#ffff00'/*желтый*/);
			add('', PINK/*розовый*/, 0x00e4ff/*ярко-голубой*/, '#ffff00'/*желтый*/);
			add('', ORANGE/*оранжевый*/, 0x5feeff/*ярко-голубой*/, '#ffff00'/*желтый*/)
		}
		
		public static function init_old():void
		{
			add(QuestObjective.COLLECT_N_BINGOS, 0x6b4ea9/*фиолетовый*/, 0x5aff00/*зеленый*/, '#8ce380'/*зеленый*/);
			add(QuestObjective.N_BINGO_IN_ROUND, 0x0886ef/*синий*/, 0x5aff00/*зеленый*/, '#ffff00'/*желтый*/);
			add(QuestObjective.USE_N_POWERUPS, 0x3eb93e/*зеленый*/, 0xff00f0/*лиловый*/, '#ffff00'/*желтый*/);
			//add(QuestObjective.CLAIM_N_POWERUPS, 0xef7108/*оранжевый*/, 0x5aff00/*зеленый*/, '#ffffff');
			add(QuestObjective.OPEN_N_CHESTS, 0xd81f27/*красный*/, 0xffff00/*желтый*/, '#ffffff');
			//add(QuestObjective.N_DAUBS, 0xeebb00/*желтый*/, 0x00e4ff/*голубой*/, '#ffffff');
			add(QuestObjective.N_DAUB_STREAKS, 0x2accc4/*голубой*/, 0xd9b3ff/*сиреневый*/, '#ffff00'/*желтый*/);
			
			add(QuestObjective.PLAY_N_GAMES, 0x6b4ea9/*фиолетовый*/, 0x5aff00/*зеленый*/, '#8ce380'/*зеленый*/);
			add(QuestObjective.BURN_N_CARDS, 0x0886ef/*синий*/, 0x5aff00/*зеленый*/, '#ffff00'/*желтый*/);
			add(QuestObjective.COLLECT_N_CARDS, 0x3eb93e/*зеленый*/, 0xff00f0/*лиловый*/, '#ffff00'/*желтый*/);
			add(QuestObjective.COLLECT_N_POINTS, 0x3eb93e/*зеленый*/, 0xff00f0/*лиловый*/, '#ffff00'/*желтый*/);
			//add(QuestObjective.WIN_N_CASH_IN_SCRACTH_CARD, 0xef7108/*оранжевый*/, 0x5aff00/*зеленый*/, '#ffffff');
			add(QuestObjective.OBTAIN_N_CASH_FROM_CHEST, 0xd81f27/*красный*/, 0xffff00/*желтый*/, '#ffffff');
			//add(QuestObjective.OBTAIN_N_POWERUPS_FROM_CHEST, 0xeebb00/*желтый*/, 0x00e4ff/*голубой*/, '#ffffff');
			add(QuestObjective.OBTAIN_N_CUSTOMIZERS_FROM_CHEST, 0x2accc4/*голубой*/, 0xd9b3ff/*сиреневый*/, '#ffff00'/*желтый*/);
		}
		
		public static function getRandomByObjectiveType(type:String):QuestStyle
		{
			var sameTypeStyles:Array;
			if (type in styles) {
				sameTypeStyles = styles[type] as Array;
				return sameTypeStyles[Math.floor(Math.random() * sameTypeStyles.length)] as QuestStyle;
			}
			
			return new QuestStyle(0xD0D0D0, 0xA0A0A0, '#ffffff');
		}
		
		public static function getRandomWidthNewBackgroundColor(excludeQuestsStyles:Array):QuestStyle
		{
			var unusedStyles:Array = [];
			var questStyle:QuestStyle;
			for each(questStyle in stylesByHash) 
			{
				if (excludeQuestsStyles.indexOf(questStyle.backgroundColor) == -1) 
					unusedStyles.push(questStyle);
			}
			
			if (unusedStyles.length > 0)
				return unusedStyles[Math.floor(Math.random() * unusedStyles.length)] as QuestStyle;
				
			
			return allStyles[Math.floor(Math.random() * allStyles.length)] as QuestStyle;
			
			//return new QuestStyle(0xD0D0D0, 0xA0A0A0, '#ffffff');
		}
		
		public static function getRandomAmongBackgroundColors(...colors):QuestStyle
		{
			if (!colors || colors.length == 0)
				return allStyles[Math.floor(Math.random() * allStyles.length)] as QuestStyle;
			
			var styles:Array = [];
			var questStyle:QuestStyle;
			for each(questStyle in stylesByHash) 
			{
				if (colors.indexOf(questStyle.backgroundColor) != -1) 
					styles.push(questStyle);
			}
			
			if (styles.length > 0)
				return styles[Math.floor(Math.random() * styles.length)] as QuestStyle;
			
			return allStyles[Math.floor(Math.random() * allStyles.length)] as QuestStyle;
		}
		
		public static function getByHash(hash:String):QuestStyle
		{
			return hash in stylesByHash ? (stylesByHash[hash] as QuestStyle) : null;
		}
		
		/********************************************************************************************************************************
		* 
		* 
		* 
		********************************************************************************************************************************/
		
		private static var styles:Object = {};
		private static var stylesByHash:Object = {};
		private static var allStyles:Array = [];
		
		public static function add(type:String, backgroundColor:uint, progressColor:uint, textColor:String):void
		{
			var sameTypeStyles:Array;
			if (type in styles) {
				sameTypeStyles = styles[type] as Array;
			}
			else {
				sameTypeStyles = [];
				styles[type] = sameTypeStyles;
			}
			
			var questStyle:QuestStyle = new QuestStyle(backgroundColor, progressColor, textColor);
			stylesByHash[questStyle.hash] = questStyle;
			allStyles.push(questStyle);
			sameTypeStyles.push(questStyle);
		}
	}
}