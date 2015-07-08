 package;

 import flixel.FlxSprite;
 import flixel.tweens.FlxTween;

/**
 * This is a hole on a body - right now the difference is just the background
 * but in future we may want things to act differently if they're on the UI
 * or in a body
 */
 class BodyHole extends Hole {

    public static var HEALTH_VALUES = [
        "Heart" => [
            "Head" => 60,
            "Chest" => 100,
            "Belly" => 50
        ],
        "Stomach" => [
            "Head" => 60,
            "Chest" => 20,
            "Belly" => 100
        ],
        "Next" => [
            "Head" => 30,
            "Chest" => 60,
            "Belly" => 10
        ],
        "Intercom" => [
            "Head" => 60,
            "Chest" => 10,
            "Belly" => 10
        ],
        "Clipboard" => [
            "Head" => 10,
            "Chest" => 10,
            "Belly" => 10
        ]
    ];

    // The type of hole
    private var type:String;

    /**
     * Get the QOL of this hole (how appropriate the contents are)
     */
    public function getQOL():Int {
        if (interactable == null) {
            return 0;
        }

        var h = HEALTH_VALUES.get(interactable.type);

        if (h == null) {
            h = new Map<String, Int>();
        }

        if (h.get(type) != null) {
            return h.get(type);
        }

        return 0;
    }

    public function new(X:Float=0, Y:Float=0, name:String="", organ:Interactable=null)  {
        super(X, Y);
        // Because a hole contains multiple sprites - we set the background
        // as a contained sprite
        type = name;
        var backgroundSprite = new FlxSprite();
        backgroundSprite.loadGraphic("assets/images/" + type +  "Hole.png");
        add(backgroundSprite);

        // initialize any organs pre-added
        if (organ != null) {
            initInteractable(organ);
        }
    }
 }