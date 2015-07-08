package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.plugin.MouseEventManager;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import haxe.Timer;

using flixel.util.FlxSpriteUtil;

/**
 * The main playstate set in the surgery room.
 */
class PlayState extends FlxState {

	// Consants
	// Scaling when picking things up
	public static inline var GRABBED_SCALE = 1.3;
	public static inline  var DEFAULT_SCALE = 1;

	public static inline  var UI_HOLE_HEIGHT = 200;
	public static inline  var UI_HOLE_WIDTH = 190;

	// How long do we need to hold to make it a drag (seconds)
	public static inline  var CLICK_TIMEOUT = 0.2;

	public static inline var BLOOD_DRIP_TIMEOUT = 0.2;

	//Default level time; tweak for testing
	private var LEVEL_TIME:Float = 60;

	//Level and score counter for Game Over screen
	private var _levelCounter:Int = 0;
	private var _score:Int = 0;
	//Store all the patients "fixed" this level for interim screen
	private var _thisLevelScore:Array<Patient>;


	private var _gameover:Bool = false; //has the player lost yet?
	private var _active:Bool = false; // is the scene playing?
	// (it's not when we're throwing overlays to start/end level)

	// General scene items
	private var _background:FlxSprite;
	private var _table:FlxSprite;
	private var _clock:Clock;

	public var _seconds_remaining:Float;
	private var _seconds_since_drip:Float;

	// The thing currently being dragged (if any)
	private var _dragging:Organ;
	private var _drag_offset_x:Float;
	private var _drag_offset_y:Float;
	private var _drag_started:Float;

	// Patient
	private var _addingPatient:Bool;
	private var _patient:Patient;

	// Holes to check for drop targets
	private var _holes:Array<Hole>;

	//Checking for Intercom messages
	private var intercomCounter:Float = 0;
	private var SECONDS_BETWEEN_ANNOUNCEMENTS:Float = 15;

    private static var instance:PlayState;
  
    public static inline function getInstance() {
        if (instance == null) {
            return instance = new PlayState();
        } else {
            return instance;
        }
    }

	override public function create():Void
	{
		// Enable debugger if in debug mode
		FlxG.debugger.visible = true;

		// Scene
		_background = new FlxSprite(0,0);
		_background.loadGraphic("assets/images/Background.png");
		add(_background);

		_table = new FlxSprite(1300,0);

		// Holes
 		_holes = new Array<Hole>();
 		
 		// TODO: Set up the correct number for additional UI elements
 		addHole(new UIHole(40, 0, new Next(0, 0)));
        addHole(new UIHole(_table.x - UI_HOLE_WIDTH - 50 , 10, new Intercom(0, 0)));

        _clock = new Clock(0, 0);
        
        addHole(new UIHole(40, 100 + UI_HOLE_HEIGHT, _clock));
        addHole(new UIHole(_table.x - UI_HOLE_WIDTH - 50, 100 + UI_HOLE_HEIGHT, null));

        addHole(new UIHole(40, 200 + (UI_HOLE_HEIGHT * 2), null));
        addHole(new UIHole(_table.x - UI_HOLE_WIDTH - 50, 200 + (UI_HOLE_HEIGHT * 2), null));

 		// Organs
 		addInteractable(new Organ(_table.x + 100, _table.y + 100, "Heart"));
 		addInteractable(new Organ(_table.x + 100, _table.y + 100 + UI_HOLE_HEIGHT, "Heart"));
 		addInteractable(new Organ(_table.x + 100, _table.y + 100 + (UI_HOLE_HEIGHT * 2), "Lungs"));
 		addInteractable(new Organ(_table.x + 100, _table.y + 100 + (UI_HOLE_HEIGHT * 3), "Guts"));

 		nextLevel();

		super.create();
	}

	public function isActive(){
		return _active;
	}

	/**
	 * A clock has gone off.
	 */
	public function clockFinished() {
		_active = false;
		//FlxG.camera.fade(FlxColor.BLACK, .33);
		removePatient(function() {
			openSubState(new IntrimState(_levelCounter, _score, _thisLevelScore));
		});
	}

	/**
	 * Start the next level
	 */
	public function nextLevel() {
		// Reset the clock
		_seconds_remaining = LEVEL_TIME;//* LEVEL_MODIFIER //scales time based on level
		_active = true;
		_levelCounter++;
		_thisLevelScore = new Array<Patient>();
	}

	/**
	 * Add a hole to the game
	 */
	public function addHole(hole:Hole) {

		// Add to drop list
		_holes.push(hole);

		// Add to renderer
		add(hole);

		if (hole._inter != null) {
			// If there's an organ, add that too
			addInteractable(hole._inter);
		}
	}

	/**
	 * Add an organ to the game
	 */
	public function addInteractable(inter:Interactable) {
		// Add to renderer
		add(inter);

		// Watch for drag
		MouseEventManager.add(inter, onMouseDown, onMouseUp); 
	}

	/**
	 * Remove a hole from the game
	 */
	public function removeHole(hole:Hole) {
		// Remove from drop targets
		_holes.remove(hole);

		// Remove from renderer
		remove(hole, true);

		if (hole._inter != null) {
			// Remove organ if needed
			removeInteractable(hole._inter);
		}
	}

	/**
	 * Remove an interactable from the game
	 */
	public function removeInteractable(inter:Interactable) {
		// Remove from renderer
		remove(inter, true);

		// Stop watching for drag
		MouseEventManager.remove(inter);
	}

	override public function update():Void
	{
		if (_gameover){
			FlxG.switchState(new GameOverState(_levelCounter, _score));
		}

		else if (_active) {
			if (_dragging != null && (Timer.stamp() - _drag_started > CLICK_TIMEOUT)) {
				// Deal with dragging

				if (_dragging.hole != null) {
					// If it was in a hole, remove it
					_dragging.hole.removeInteractable();
				}

				// maintain offset
				_dragging.x = FlxG.mouse.x + _drag_offset_x;
				_dragging.y = FlxG.mouse.y + _drag_offset_y;

				if (!FlxG.mouse.pressed) {
					// If we're not pressing any more - stop dragging
					onMouseUp(_dragging);
				}
			}

			//Intercom code
			intercomCounter += FlxG.elapsed;
			if (intercomCounter >= SECONDS_BETWEEN_ANNOUNCEMENTS){
				for (hole in _holes){
					if (Type.getClass(hole._inter) == Intercom){
						var intercom:Intercom = cast(hole._inter, Intercom);
						intercom.generateMessage();
					}
				}
				intercomCounter = 0;
			}

			// Timer
			_seconds_remaining -= FlxG.elapsed;
			if (_seconds_remaining <= 0) {
				clockFinished();
			}

			// Drips
			if (_dragging != null && Type.getClass(_dragging) == Organ) {
				_seconds_since_drip += FlxG.elapsed;
				if (_seconds_since_drip >= BLOOD_DRIP_TIMEOUT) {
					dripBlood(FlxG.mouse.x, FlxG.mouse.y);
					_seconds_since_drip = 0;
				}
			}
		}

		super.update();
	}

	/**
	 * Place some blood on the floor.
	 */
	function dripBlood(x:Float, y:Float) {
		var numberOfDrops = Std.random(10);

		for (i in 0...numberOfDrops) {
			var vx = x + (Std.random(100) - 50);
			var vy = y + (Std.random(100) - 50);
			_background.drawCircle(vx, vy, Std.random(100) + 1, 0x22FF0000);
		}
	}

	/**
	 * There has been a mouse press on an organ
	 */
	function onMouseDown(sprite:FlxSprite) {
		_drag_started = Timer.stamp();
		_seconds_since_drip = 0;
		_dragging = cast sprite;
		_drag_offset_x = _dragging.x - FlxG.mouse.x;
		_drag_offset_y = _dragging.y - FlxG.mouse.y;

		// Make it bigger when grabbed
		FlxTween.tween(_dragging.scale, {x: GRABBED_SCALE, y: GRABBED_SCALE}, 0.1);

		// Bring to front
		Utils.bringToFront(members, _dragging);
	}

	/**
	 * Mouse up on an organ
	 */
	function onMouseUp(sprite:FlxSprite) {
        if (_dragging != null) {
            if (Timer.stamp() - _drag_started < CLICK_TIMEOUT) {
                // We're clicking not dragging
                var organ:Organ = cast sprite;
                organ.click();
            } else {
                var placed = false; // Figure out if we're dropping on something
                var minDistance:Float = 99999;
                var minHole:Hole = null;

                for (hole in _holes) {
                    // Check each hole
                    var distance = new FlxPoint(hole.x, hole.y).distanceTo(new FlxPoint(_dragging.x, _dragging.y));

                    if (hole.isEmpty() && distance < minDistance) {
                    	minDistance = distance;
                    	minHole = hole;
                    }
                }

                if (minDistance < minHole.width) {
                    // if the distance is small enough
                    // Add the _dragging to the _hole
                    minHole.addInteractable(_dragging);
                    placed = true;
                }

                if (!placed && _dragging.x < _table.x) {
                    // If it's not on the table and not placed, put it on the table
                    FlxTween.tween(_dragging, {x: (_table.x + 20)}, 0.1);
                }

            }

            // Resize to default
            FlxTween.tween(_dragging.scale, {x: DEFAULT_SCALE, y: DEFAULT_SCALE}, 0.1);

            // No longer dragging
            _dragging = null;
        }
	}

	/**
	 * Remove the patient from surgery
	 */
	public function removePatient(callback:Void->Void) {
		if (_patient != null) {
			// If we have one, get rid of them first
			FlxTween.tween(_patient, {y: 0-(_patient.height)}, 1, {complete: function(t:FlxTween) {

				_score++;// Still record them if the clock timed out?
				_thisLevelScore.push(_patient);
				//Destroy patient here or once the score is displayed?
				//destroyPatient();
				//If not here, better destroy them all in start_new
				callback();
			}});
		} else {
			// Otherwise just move on
			callback();
		}
	}

	/**
	 * Call for the next patient
	 */
	public function nextPatient() {
		if (!_addingPatient) { // Avoid spamming patients
			_addingPatient = true;
			removePatient(addNewPatient);
		}
	}

	/**
	 * Remove the patient from memory
	 */
	public function destroyPatient() {
		// Remove their holes
		for (hole in _patient._holes) {
 			removeHole(hole);
 		}

		// Unload patient
		_patient.destroy();
		_patient = null;
	}

	/*
	 * The new patient has moved on to the screen
	 */
	public function patientAdded(tween:FlxTween) {
		_addingPatient = false;
	}

	/**
	 * Generate a new patient and tween them on to the screen. */
	public function addNewPatient() {
		// Patient
		_patient = new Patient(300, FlxG.height);

		// Add to renderer
		add(_patient);

		// Add each hole
		for (hole in _patient._holes) {
 			addHole(hole);
 		}

 		// Move on to screen
 		FlxTween.tween(_patient, {y: 20}, 1, {"complete": patientAdded});
	}
}