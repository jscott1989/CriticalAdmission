 package;

 import flixel.FlxSprite;
 import flixel.text.FlxText;
 import flixel.util.FlxColor;

/**
 * An organ which can be placed in a hole or left on the table
 */
 class Organ extends FlxSprite {

    // The hole it's contained in (if any)
    public var hole:Hole;

    // The game state it's contained in (for button clicks)
    public var state:PlayState;

    public function new(X:Float=0, Y:Float=0, type:String, pState:PlayState)  {
        super(X, Y);
        // Load the correct type onto this sprite
        loadGraphic("assets/images/" + type + ".png");
        state = pState;
    }

    public override function update() {
        super.update();
    }

    public function click() {
    }
 }