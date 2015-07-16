package states.playstate;

 import flixel.FlxG;
 import flixel.util.FlxRandom;

/**
 * Counter for tracking hospital reputation
 */
 class PressureGauge extends UIElement {

    private var number = 8;

    public function new(X:Float=0, Y:Float=0)  {
        super("PressureGauge", X, Y);
    }

    override function update() {
        var v = Std.int(Math.min(8, Math.max(0, Math.floor((PlayState.getInstance().reputation / 100) * 8))));

        if (v != number) {
            number = v;
            loadGraphic("assets/images/PressureGauge" + v + ".png");
        }
    }
 }