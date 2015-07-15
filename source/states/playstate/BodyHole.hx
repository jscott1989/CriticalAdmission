 package states.playstate;

 import flixel.FlxSprite;

/**
 * This is a hole on a body - right now the difference is just the background
 * but in future we may want things to act differently if they're on the UI
 * or in a body
 */
 class BodyHole extends Hole {

    // The type of hole
    public var type:String;

    public function new(X:Float=0, Y:Float=0, type:String="", interactable:Interactable=null, requiresFlip:Bool=false, hidden:Bool=false)  {
        this.type = type;
        var backgroundSprite = new FlxSprite();
        backgroundSprite.loadGraphic("assets/images/" + type +  "Hole.png");
        super(backgroundSprite, interactable, requiresFlip, X, Y);

        highlightSprite = new FlxSprite();
        highlightSprite.loadGraphic("assets/images/" + type +  "HoleHighlight.png");
        highlightSprite.alpha = 0.5;

        if (hidden) {
            hide();
        }
    }

    override function update() {

    }
 }