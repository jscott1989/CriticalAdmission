 package;

 import flixel.FlxSprite;
 import flixel.tweens.FlxTween;

 class Hole extends FlxSprite {

    private var _organ:Organ;

    public function new(X:Float=0, Y:Float=0)  {
        super(X, Y);
        loadGraphic("assets/images/Hole.png");
    }

    public override function update() {
        super.update();
    }

    public function isEmpty() {
        return _organ == null;
    }

    public function addOrgan(organ:Organ) {
        _organ = organ;
        _organ.hole = this;
        FlxTween.tween(_organ, {x: x + ((width - organ.width)/2), y: y + ((height - organ.height)/2)}, 0.1);

    }

    public function removeOrgan() {
        _organ.hole = null;
        _organ = null;
    }
 }