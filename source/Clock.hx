 package;

 import flixel.FlxG;
 import flixel.text.FlxText;

/**
 * Clock that shows the current time left in the level
 */
 class Clock extends UIElement {

    private var _text:FlxText;
    private var _seconds_remaining:Float;

    public function new(X:Float=0, Y:Float=0, state:PlayState, seconds_remaining=300)  {
        super(X, Y, "Clock", state);

        _seconds_remaining = seconds_remaining;

        // Add some text to the state, and then we can make the text
        // follow the clock sprite
        _text = new FlxText(0, 0, width); // x, y, width
        _text.alignment = "center";
        _text.size = 20;

        updateText();
        state.add(_text);
    }

    /**
     * Convert seconds remaining into a string and put it on the clock.
     */
    private function updateText() {
        var minutes = Math.floor(_seconds_remaining / 60);
        var seconds = Std.string(Math.floor(_seconds_remaining % 60));
        if (seconds.length == 1) {
            seconds = "0" + seconds;
        }
        _text.text = minutes + ":" + seconds;
    }

    public override function update() {
        _text.x = x;
        _text.y = y + 50;

        // Always ensure that the text is in front of us in the state
        var spriteIndex = state.members.indexOf(this);
        var textIndex = state.members.indexOf(_text);

        if (spriteIndex > textIndex) {
            // Move text to spriteIndex
            state.members[textIndex] = state.members[spriteIndex - 1];
            state.members[spriteIndex - 1] = this;
            state.members[spriteIndex] = _text;
        }

        // TODO: Adjust font size to match scale of clock

        // TODO: This is inconsistent - find a more reliable timer in FlxG.
        _seconds_remaining -= FlxG.elapsed;

        updateText();
    }

    /**
     * Tidy up the text as it's not being managed by anyone else.
     */
    public override function destroy() {
        state.remove(_text, true);
        _text.destroy();
        super.destroy();
    }
 }