 package;

 import flixel.FlxG;
 import flixel.text.FlxText;
 import haxe.Timer;

/**
 * Clock that shows the current time left in the level
 */
 class Clock extends UIElement {

    private var _text:FlxText;
    private var _end_time:Float;

    private var _active:Bool = true;

    public function new(X:Float=0, Y:Float=0, state:PlayState, seconds_remaining=300)  {
        super(X, Y, "Clock", state);

        _end_time = Timer.stamp() + seconds_remaining;

        // Add some text to the state, and then we can make the text
        // follow the clock sprite
        _text = new FlxText(0, 0, width); // x, y, width
        _text.alignment = "center";
        _text.size = 40;

        updateText();
        state.add(_text);
    }

    private function getSecondsRemaining() {
        var seconds_remaining = _end_time - Timer.stamp();
    }

    /**
     * Convert seconds remaining into a string and put it on the clock.
     */
    private function updateText() {
        var seconds_remaining = getSecondsRemaining();
        if (seconds_remaining <= 0) {
                _active = false;
                timeUp();
        } else {
            var minutes = Math.floor(seconds_remaining / 60);
            var seconds = Std.string(Math.floor(seconds_remaining % 60));
            if (seconds.length == 1) {
                seconds = "0" + seconds;
            }
            _text.text = minutes + ":" + seconds;
        }
    }

    public override function update() {
        _text.x = x;
        _text.y = y + 10;

        // Always ensure that the text is in front of us in the state

        PlayState.bringToFront(state.members, _text, this);

        // TODO: Adjust font size to match scale of clock

        if (_active) {
            updateText();
        }
    }

    private function timeUp() {
        // TODO: Animate
    }

    /**
     * Tidy up the text as it's not being managed by anyone else.
     */
    public override function destroy() {
        state.clockRemoved(this, getSecondsRemaining());
        state.remove(_text, true);
        _text.destroy();
        super.destroy();
    }
 }