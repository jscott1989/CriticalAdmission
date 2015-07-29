package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSave;

using flixel.util.FlxSpriteUtil;

class HighscoreState extends FlxSubState {

    public static function isHighscore(level:Int, patients:Int) {
        var highscores = new FlxSave();
        highscores.bind("highscores");

        return (highscores.data.score4_name == null ||
            (level > highscores.data.score4_level) ||
            (level == highscores.data.score4_level && patients > highscores.data.score4_patients)
            );
    }

    public static function addHighscore(name:String, level:Int, patients:Int) {
        var highscores = new FlxSave();
        highscores.bind("highscores");

        if (highscores.data.score4_name == null ||
            (level > highscores.data.score4_level) ||
            (level == highscores.data.score4_level && patients > highscores.data.score4_patients)
            ) {


            if (highscores.data.score3_name == null ||
            (level > highscores.data.score3_level) ||
            (level == highscores.data.score3_level && patients > highscores.data.score3_patients)
            ) {
                // Move 3 to 4
                highscores.data.score4_name = highscores.data.score3_name;
                highscores.data.score4_level = highscores.data.score3_level;
                highscores.data.score4_patients = highscores.data.score3_patients;

                if (highscores.data.score2_name == null ||
                    (level > highscores.data.score2_level) ||
                    (level == highscores.data.score2_level && patients > highscores.data.score2_patients)
                ) {
                    // Move 2 to 3
                    highscores.data.score3_name = highscores.data.score2_name;
                    highscores.data.score3_level = highscores.data.score2_level;
                    highscores.data.score3_patients = highscores.data.score2_patients;

                    if (highscores.data.score1_name == null ||
                        (level > highscores.data.score1_level) ||
                        (level == highscores.data.score1_level && patients > highscores.data.score1_patients)
                    ) {
                        // Move 1 to 2
                        highscores.data.score2_name = highscores.data.score1_name;
                        highscores.data.score2_level = highscores.data.score1_level;
                        highscores.data.score2_patients = highscores.data.score1_patients;

                        // Put the new one in 1
                        highscores.data.score1_name = name;
                        highscores.data.score1_level = level;
                        highscores.data.score1_patients = patients;
                    } else {
                        // Put the new one in 2
                        highscores.data.score2_name = name;
                        highscores.data.score2_level = level;
                        highscores.data.score2_patients = patients;
                    }
                } else {
                    // Put the new one in 3
                    highscores.data.score3_name = name;
                    highscores.data.score3_level = level;
                    highscores.data.score3_patients = patients;
                }
            } else {
                // Put the new one in 4
                highscores.data.score4_name = name;
                highscores.data.score4_level = level;
                highscores.data.score4_patients = patients;
            }
        }

        highscores.flush();
    }
    
    private var btnBack:FlxButton;

    /**
     * Function that is called up when to state is created to set it up. 
     */
    override public function create():Void {
        // Fill background with black
        var background = new FlxSprite(0,0);
        background.loadGraphic("assets/images/MenuScreen.png");
        add(background);

        var logo = new FlxSprite(0,0);
        logo.loadGraphic("assets/images/Logo.png");
        add(logo);

        btnBack = Utils.createButton("Back", clickBack, 5);
        btnBack.screenCenter();
        btnBack.y = 1400;
        add(btnBack);

        super.create();


        var highscores = new FlxSave();
        highscores.bind("highscores");

        if (highscores.data.score1_name != null) {
            createHighScore(0, highscores.data.score1_name, highscores.data.score1_level, highscores.data.score1_patients);
        } else {
            var noHighScores = new FlxText(800, 1100, 600, "No high scores yet", 60);
            noHighScores.font = "assets/fonts/Cabin-Bold.ttf";
            noHighScores.color = FlxColor.BLACK;
            add(noHighScores);
        }

        if (highscores.data.score2_name != null) {
            createHighScore(1, highscores.data.score2_name, highscores.data.score2_level, highscores.data.score2_patients);
        }
        if (highscores.data.score3_name != null) {
            createHighScore(2, highscores.data.score3_name, highscores.data.score3_level, highscores.data.score3_patients);
        }
        if (highscores.data.score4_name != null) {
            createHighScore(3, highscores.data.score4_name, highscores.data.score4_level, highscores.data.score4_patients);
        }

        // Cancel the fade
        FlxG.camera.stopFX();
    }

    private function createHighScore(score:Int, name:String, level:Int, patients:Int) {
        var highScoreIcon = new FlxSprite(50 + 500 * score, 1100);
        highScoreIcon.loadGraphic("assets/icon.png");
        add(highScoreIcon);

        var name = new FlxText(highScoreIcon.x + highScoreIcon.width + 10, highScoreIcon.y - 20, 300, name, 50);
        name.font = "assets/fonts/Cabin-Bold.ttf";
        name.color = FlxColor.BLACK;
        add(name);

        var days = new FlxText(highScoreIcon.x + highScoreIcon.width + 10, name.y + name.height + 10, 300, "Day " + Std.string(level), 40);
        days.font = "assets/fonts/Cabin-Regular.ttf";
        days.color = FlxColor.BLACK;
        add(days);

        var patients = new FlxText(highScoreIcon.x + highScoreIcon.width + 10, days.y + days.height + 10, 300, "Treated " + Std.string(patients) + " patients", 35);
        patients.font = "assets/fonts/Cabin-Regular.ttf";
        patients.color = FlxColor.BLACK;
        add(patients);
    }

    private function clickBack():Void {
        close();
    }

    /**
     * Function that is called once every frame.
     */
    override public function update():Void {
        super.update();
    }   
}