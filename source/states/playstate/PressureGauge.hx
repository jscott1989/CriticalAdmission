package states.playstate;

 import flixel.FlxG;
 import flixel.text.FlxText;
 import flixel.util.FlxColor;
 import haxe.Timer;
 import sounds.SoundManager;

/**
 * Counter for tracking hospital reputation
 */
 class PressureGauge extends UIElement {

    public var number = 8;
    private var timeout = 0.0;
    public var reputation = 8;
    public var v = 8;

    public static inline var REPUTATION_ANIMATION_TIME = 0.5;

    public function new()  {
        super("PressureGauge");
        this.label = "Reputation Gauge";
    }

    override function update() {
        super.update();

        if (reputation == 8) {
            return; //weirdest thing... when i figure out why it randomly sets to 8... fix this.
        }

        if (reputation == 0){
            v = 0;
        } else {
            v = Std.int(Math.min(Math.max(1, Std.int(((reputation/100)*7)+1)), 8));
        }

        timeout += FlxG.elapsed;

        if (timeout >= REPUTATION_ANIMATION_TIME) {
            timeout = 0;
            if (v != number) {
                if (v > number) {
                    number++;
                    SoundManager.getInstance().playSuccess();
                } else {
                    number--;
                    SoundManager.getInstance().playFailure();
                }

                loadGraphic("assets/images/PressureGauge" + number + ".png");
            }
        }
    }

    public function reputationChange(change:Int, newReputation:Int) {
        reputation = newReputation;

        var changeText:String = Std.string(change);
        if (change >= 0) {
            changeText = "+" + changeText;
        }

        var text = new FlxText(x + width / 2, y + height / 2, 0, changeText, 200);

        text.x -= text.width / 2;
        text.y -= text.height / 2;

        text.x += Std.random(300) - 150;
        text.y += Std.random(300) - 150;

        text.font = "assets/fonts/Cabin-Bold.ttf";
        text.color = FlxColor.RED;
        if (change >= 0) {
            text.color = FlxColor.GREEN;
        }
        PlayState.getInstance().add(text);

        Timer.delay(function f() {
            PlayState.getInstance().remove(text, true);
            flixel.util.FlxDestroyUtil.destroy(text);
        }, 2000);
    }
 }