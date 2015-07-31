package states.playstate;

import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxSpriteFilter;
import flash.filters.GlowFilter;
import flixel.tweens.FlxTween;
/**
 * Clock that shows the current time left in the level
 */
 class Clock extends UIElement {

    public static inline var TEXT_X_OFFSET = 0;
    public static inline var TEXT_Y_OFFSET = 70;

    private var text:FlxText;

    private var filter:FlxSpriteFilter;
    private var redFilter:GlowFilter;
    private var filterTween:FlxTween;

    public function new()  {
        super("Clock");

        // Add some text to the state, and then we can make the text
        // follow the clock sprite
        text = new FlxText(0, 0, width);
        text.font = "assets/fonts/Cabin-Regular.ttf";
        text.alignment = "center";
        text.color = FlxColor.BLACK;
        text.size = 40;

        filter = new FlxSpriteFilter(this);
        redFilter = new GlowFilter(0xFF0000, 1, 50, 50, 1.5, 1);
        filterTween = FlxTween.tween(redFilter, { blurX: 4, blurY: 4 }, 1, { type: FlxTween.PINGPONG });

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

    /**
     * Flash red if below 5 seconds
     */
    private function updateClock() {
        var seconds_remaining = PlayState.getInstance().seconds_remaining;
        if (seconds_remaining <= 5 && PlayState.getInstance().patient != null) {
            if(filter.filters.length == 0){
                filter.addFilter(redFilter);
            }
        }
        else{
            filter.removeFilter(redFilter);
        }

        filter.applyFilters();
    }

    public override function update() {
        text.x = x + TEXT_X_OFFSET;
        text.y = y + TEXT_Y_OFFSET;

        // TODO: Adjust font size to match scale of clock

        updateClock();
        updateText();

        // Always ensure that the text is in front of us in the state
        Utils.bringToFront(PlayState.getInstance().members, text, this);
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