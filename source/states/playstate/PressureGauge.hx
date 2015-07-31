package states.playstate;

 import flixel.FlxG;
 import flixel.text.FlxText;
 import flixel.util.FlxColor;
 import flixel.util.FlxDestroyUtil;
 import haxe.Timer;
 import sounds.SoundManager;

/**
 * Counter for tracking hospital reputation
 */
 class PressureGauge extends UIElement {

    public var number = 8;
    private var timeout = 0.0;
    public var reputation = 8;
    public var targetBars = 8;

    public var displayedText = new Array<FlxText>();

    public static inline var REPUTATION_ANIMATION_TIME = 0.5;

    public function new()  {
        super("PressureGauge");
        this.label = "Reputation Gauge";
        reputation = PlayState.getInstance().reputation;

        if (reputation <= 0){
            targetBars = 0;
        } else {
            targetBars = Std.int(Math.min(Math.max(1, Std.int(((reputation/100)*7)+1)), 8));
        }
        
        number = targetBars;

        loadGraphic("assets/images/PressureGauge" + number + ".png");
    }

    override function update() {
        super.update();

        timeout += FlxG.elapsed;

        if (timeout >= REPUTATION_ANIMATION_TIME) {
            timeout = 0;
            if (targetBars != number) {
                if (targetBars > number) {
                    number++;
                    SoundManager.getInstance().playSuccess();
                } else {
                    number--;
                    SoundManager.getInstance().playFailure();
                }

                loadGraphic("assets/images/PressureGauge" + number + ".png");
            }
        }

        for (t in displayedText) {
            Utils.bringToFront(PlayState.getInstance().members, t);
        }
    }

    public function reputationChange(change:Int, newReputation:Int, text:String) {
        reputation = newReputation;

        if (reputation <= 0){
            targetBars = 0;
        } else {
            targetBars = Std.int(Math.min(Math.max(1, Std.int(((reputation/100)*7)+1)), 8));
        }

        var changeText:String = Std.string(change);
        if (change >= 0) {
            changeText = "+" + changeText;
        }

        changeText = text + changeText;

        var text = new FlxText(0, 0, 0, changeText, 100);
        text.x = (FlxG.width - 400) - (text.width / 2);
        text.y = 50;

        text.y += 100 * displayedText.length;

        text.font = "assets/fonts/Cabin-Regular.ttf";
        text.color = FlxColor.RED;
        if (change >= 0) {
            text.color = FlxColor.GREEN;
        }
        
        text.borderSize = 3;
        text.borderStyle = FlxText.BORDER_OUTLINE;

        displayedText.push(text);
        PlayState.getInstance().add(text);

        Timer.delay(function f() {
            PlayState.getInstance().remove(text, true);
            displayedText.remove(text);
            flixel.util.FlxDestroyUtil.destroy(text);
        }, 2000);
    }

    override function destroy() {
        super.destroy();

        if (displayedText != null) {
            for (t in displayedText) {
                FlxDestroyUtil.destroy(t);
            }
        }

        displayedText = null;
    }
 }