package states.playstate;

 import flixel.FlxSprite;

/**
 * An organ which can be placed in a hole or left on the table
 */
 class Interactable extends FlxSprite {

    public static var flippableInteractables = [
        "Knee", "Elbow", "Tannoy"
    ];

    // The hole it's contained in (if any)
    private var hole:Hole;

    public var type:String;

    private var canBeFlipped = false;

    public function new(type:String, X:Float=0, Y:Float=0)  {
        super(X, Y);
        this.type = type;
        this.canBeFlipped = flippableInteractables.lastIndexOf(type) != -1;
        // Load the correct type onto this sprite
        loadGraphic("assets/images/" + type + ".png");
    }

    public function setHole(hole:Hole) {
        this.hole = hole;

        if (canBeFlipped && this.hole.requiresFlip) {
            this.flipX = true;
        } else {
            this.flipX = false;
        }
    }

    public function resetHole() {
        this.hole = null;
    }

    public function getHole() {
        return hole;
    }

    public override function update() {
        super.update();
    }

    public function click() {
    }
    
    public function interaction() {
    }
 }