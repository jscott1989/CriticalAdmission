package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSave;

using flixel.util.FlxSpriteUtil;

class HighscoreState extends FlxSubState {

    private var background:FlxSprite;
    private var logo:FlxSprite;
    private var highScores:FlxSprite;
    private var h1:FlxSprite;
    private var h2:FlxSprite;
    private var h3:FlxSprite;
    private var h4:FlxSprite;
    private var btnBack:FlxButton;

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

    /**
     * Function that is called up when to state is created to set it up. 
     */
    override public function create():Void {

        h1 = new FlxSprite(0, 1100);
        h2 = new FlxSprite(0, 1100);
        h3 = new FlxSprite(0, 1100);
        h4 = new FlxSprite(0, 1100);
        h1.loadGraphic("assets/images/h1.png");
        h2.loadGraphic("assets/images/h2.png");
        h3.loadGraphic("assets/images/h3.png");
        h4.loadGraphic("assets/images/h4.png");

        // Fill background with black
        background = new FlxSprite(0,0);
        background.loadGraphic("assets/images/MenuScreen.png");
        add(background);

        logo = new FlxSprite(0,0);
        logo.loadGraphic("assets/images/Logo.png");
        add(logo);

        highScores = new FlxSprite(0,270);
        highScores.loadGraphic("assets/images/highscores.png");
        add(highScores);

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
        var highScoreIcon:FlxSprite = null;
        if (score == 0) {
            highScoreIcon = h1;
        } else if (score == 1) {
            highScoreIcon = h2;
        } else if (score == 2) {
            highScoreIcon = h3;
        } else {
            highScoreIcon = h4;
        }

        highScoreIcon.x = 50 + 500 * score;
        add(highScoreIcon);

        if (name.length > 9) {
            name = name.substr(0,9);
        }

        var name = new FlxText(highScoreIcon.x + highScoreIcon.width + 10, highScoreIcon.y, 350, name, 50);
        name.font = "assets/fonts/Cabin-Bold.ttf";
        name.color = FlxColor.BLACK;
        add(name);

        var days = new FlxText(highScoreIcon.x + highScoreIcon.width + 10, name.y + name.height + 10, 350, "Day " + Std.string(level), 40);
        days.font = "assets/fonts/Cabin-Regular.ttf";
        days.color = FlxColor.BLACK;
        add(days);

        var patients = new FlxText(highScoreIcon.x + highScoreIcon.width + 10, days.y + days.height + 10, 350, "Treated " + Std.string(patients) + " patients", 35);
        patients.font = "assets/fonts/Cabin-Regular.ttf";
        patients.color = FlxColor.BLACK;
        add(patients);
    }

    private function clickBack():Void {
        close();
    }

    override function destroy() {
        super.destroy();
        background = FlxDestroyUtil.destroy(background);
        logo = FlxDestroyUtil.destroy(logo);
        highScores = FlxDestroyUtil.destroy(highScores);
        h1 = FlxDestroyUtil.destroy(h1);
        h2 = FlxDestroyUtil.destroy(h2);
        h3 = FlxDestroyUtil.destroy(h3);
        h4 = FlxDestroyUtil.destroy(h4);
        btnBack = FlxDestroyUtil.destroy(btnBack);
    }
}