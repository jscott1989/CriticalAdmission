 package;

 import flixel.FlxSprite;
 import flixel.tweens.FlxTween;

 class BodyHole extends Hole {

    public function new(X:Float=0, Y:Float=0, organ:Organ=null)  {
        super(X, Y);
        var backgroundSprite = new FlxSprite(0, 0);
        backgroundSprite.loadGraphic("assets/images/BodyHole.png");
        add(backgroundSprite);

        if (organ != null) {
            initOrgan(organ);
        }
    }

    public override function update() {
        super.update();
    }
 }