package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.ui.FlxInputText;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import states.playstate.PlayState;

using flixel.util.FlxSpriteUtil;

/**
 * Game's menu. Disabled at the moment.
 */
class GameOverState extends FlxSubState {

	public function new() {
		super();
	}

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void {
		// fill background with black
        var background = new FlxSprite(0,0);
        background.loadGraphic("assets/images/MenuScreen.png");
        add(background);

        var state = PlayState.getInstance();


        var self = this;
        if (states.HighscoreState.isHighscore(state.currentLevel, state.treatedPatients.length)) {
            var gameOverText = new FlxText(400, 1000, 0, "You have a new high score!", 70);
            gameOverText.font = "assets/fonts/Cabin-Bold.ttf";
            gameOverText.color = FlxColor.BLACK;
            add(gameOverText);

            var highscoreName = new FlxInputText(400, 1200, 500, "", 70, FlxColor.BLACK, FlxColor.WHITE);
            add(highscoreName);

            var highscoreButton:FlxButton = null;

            highscoreButton = Utils.createButton("Save", function() {
                states.HighscoreState.addHighscore(highscoreName.text, state.currentLevel, state.treatedPatients.length);
                self.remove(gameOverText);
                self.remove(highscoreName);
                self.remove(highscoreButton);

                var submittedText = new FlxText(500, 1000, 0, "Your score has been saved", 70);
                submittedText.font = "assets/fonts/Cabin-Bold.ttf";
                submittedText.color = FlxColor.BLACK;
                self.add(submittedText);
                
            }, 5);
            highscoreButton.x = 1000;
            highscoreButton.y = 1200;
            add(highscoreButton);
        }

        var logo = new FlxSprite(0,0);
		logo.loadGraphic("assets/images/Logo.png");
		add(logo);

        var dayText = new FlxText(50, 350, 0, "Day " + state.currentLevel, 70);
        dayText.font = "assets/fonts/Cabin-Bold.ttf";
        dayText.color = FlxColor.BLACK;
        add(dayText);

        var infoText = new FlxText(50, 450, 0, state.treatedPatients.length + " patients treated", 40);
        infoText.font = "assets/fonts/Cabin-Regular.ttf";
        infoText.color = FlxColor.BLACK;
        add(infoText);

		var btnMenu = Utils.createButton("Return to Menu", clickMenu, 5);
		btnMenu.x = 300;
		btnMenu.y = FlxG.height - btnMenu.height - 10;
		add(btnMenu);

		var btnRetry = Utils.createButton("Restart", clickRetry, 5);
		btnRetry.x = 800;
		btnRetry.y = FlxG.height - btnRetry.height - 10;
		add(btnRetry);

        var btnHighscores = Utils.createButton("Highscores", clickHighscores, 5);
        btnHighscores.x = 1300;
        btnHighscores.y = FlxG.height - btnHighscores.height - 10;
        add(btnHighscores);

		super.create();

		// Cancel the fade
        FlxG.camera.stopFX();

        //Reset level information
        Levels.populateLevels();
	}

	private function clickMenu():Void {
		FlxG.switchState(new MenuState());
	}	

	private function clickRetry():Void {
		// FlxG.switchState(new PassingToPlayState(PlayState.getInstance().lastSaveState));
        FlxG.switchState(new PassingToPlayState());
	}

    private function clickHighscores():Void {
        openSubState(new states.HighscoreState());
    }	
}