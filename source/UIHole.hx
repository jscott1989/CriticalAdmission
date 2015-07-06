 package;

 import flixel.FlxSprite;
 import flixel.FlxState;

/**
 * This is a hole in the UI - right now the difference is just the background
 * but in future we may want things to act differently if they're on the UI
 * or in a body
 */
 class UIHole extends Hole {

    public function new(X:Float=0, Y:Float=0, ui:UIElement=null)  {
        super(X, Y);
        // Because a hole contains multiple sprites - we set the background
        // as a contained sprite
        var backgroundSprite = new FlxSprite(0, 0);
        backgroundSprite.loadGraphic("assets/images/UIHole.png");
        add(backgroundSprite);

        // initialize any organs pre-added
        if (ui != null) {
            initInteractable(ui);
        }
    }
 }