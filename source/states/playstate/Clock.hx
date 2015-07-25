package states.playstate;

 import flixel.text.FlxText;
 import flixel.util.FlxColor;

/**
 * Clock that shows the current time left in the level
 */
 class Clock extends UIElement {

    public static inline var TEXT_X_OFFSET = 0;
    public static inline var TEXT_Y_OFFSET = 70;

    private var text:FlxText;

    public function new()  {
        super("Clock");

        // Add some text to the state, and then we can make the text
        // follow the clock sprite
        text = new FlxText(0, 0, width);
        text.alignment = "center";
        text.color = FlxColor.BLACK;
        text.size = 40;

        updateText();
        PlayState.getInstance().add(text);
    }

    /**
     * Convert seconds remaining into a string and put it on the clock.
     */
    private function updateText() {
        var seconds_remaining = PlayState.getInstance().seconds_remaining;
        if (seconds_remaining >= 0) {
            var minutes = Math.floor(seconds_remaining / 60);
            var seconds = Std.string(Math.floor(seconds_remaining % 60));
            if (seconds.length == 1) {
                seconds = "0" + seconds;
            }
            text.text = minutes + ":" + seconds;
        }
    }

    public override function update() {
        text.x = x + TEXT_X_OFFSET;
        text.y = y + TEXT_Y_OFFSET;

        // Always ensure that the text is in front of us in the state

        Utils.bringToFront(PlayState.getInstance().members, text, this);

        // TODO: Adjust font size to match scale of clock

        updateText();
    }

    private function timeUp() {
        // TODO: Animate
    }

    /**
     * Tidy up the text as it's not being managed by anyone else.
     */
    public override function destroy() {
        PlayState.getInstance().remove(text, true);
        text.destroy();
        super.destroy();
    }
 }