enum Difficulty{
	Easy;
	Medium;
	Hard;
}

class Config{
	public static var BUTTON_Y_PADDING:Float = 50;

	public static var SECONDS_BETWEEN_ANNOUNCEMENTS:Float = 10;
	public static var SUBTITLE_TIMEOUT:Float = 5;

	public static var SUBTITLE_SIZE:Int = 60;
	public static var SUBTITLE_X_PADDING:Int = 50;
	public static var SUBTITLE_Y_PADDING:Int = 100;

	//USER SELECTED OPTIONS
	public static var DIFFICULTY = Difficulty.Easy;
	public static var SUBTITLES_ON:Bool = true;
	
}