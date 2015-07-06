package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.plugin.MouseEventManager;
import flixel.tweens.FlxTween;
import flixel.util.FlxPoint;
import haxe.Timer;

/**
 * The main playstate set in the surgery room.
 */
class PlayState extends FlxState {

	// Consants
	// Scaling when picking things up
	public static inline var GRABBED_SCALE = 1.3;
	public static inline  var DEFAULT_SCALE = 1;

	// How long do we need to hold to make it a drag (seconds)
	public static inline  var CLICK_TIMEOUT = 0.2;

	// General scene items
	private var _table:FlxSprite;

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

	override public function create():Void
	{
		// Enable debugger if in debug mode
		FlxG.debugger.visible = true;

		// Scene
		_table = new FlxSprite(900,50);
		_table.loadGraphic("assets/images/Table.png");
		add(_table);

		// Holes
 		_holes = new Array<Hole>();
 		
 		// TODO: Set up the correct number for additional UI elements
 		addHole(new UIHole(10, 10, new Next(200, 200, this)));
        addHole(new UIHole(750, 10, new Intercom(200, 200, this)));
        
        addHole(new UIHole(10, 200, null));
        addHole(new UIHole(750, 200, null));
        addHole(new UIHole(10, 400, null));
        addHole(new UIHole(750, 400, null));

 		// Organs
 		addOrgan(new Organ(440, 20, "Heart", this));
 		addOrgan(new Organ(440, 140, "Stomach", this));

		super.create();
	}

	/**
	 * Add a hole to the game
	 */
	public function addHole(hole:Hole) {

		// Add to drop list
		_holes.push(hole);

		// Add to renderer
		add(hole);

		if (hole._organ != null) {
			// If there's an organ, add that too
			addOrgan(hole._organ);
		}
	}

	/**
	 * Add an organ to the game
	 */
	public function addOrgan(organ:Organ) {
		// Add to renderer
		add(organ);

		// Watch for drag
		MouseEventManager.add(organ, onMouseDown, onMouseUp); 
	}

	/**
	 * Remove a hole from the game
	 */
	public function removeHole(hole:Hole) {
		// Remove from drop targets
		_holes.remove(hole);

		// Remove from renderer
		remove(hole, true);

		if (hole._organ != null) {
			// Remove organ if needed
			removeOrgan(hole._organ);
		}
	}

	/**
	 * Remove an organ from the game
	 */
	public function removeOrgan(organ:Organ) {
		// Remove from renderer
		remove(organ, true);

		// Stop watching for drag
		MouseEventManager.remove(organ);
	}

	override public function update():Void
	{
		if (_dragging != null && (Timer.stamp() - _drag_started > CLICK_TIMEOUT)) {
			// Deal with dragging

			if (_dragging.hole != null) {
				// If it was in a hole, remove it
				_dragging.hole.removeOrgan();
			}

			// maintain offset
			_dragging.x = FlxG.mouse.x + _drag_offset_x;
			_dragging.y = FlxG.mouse.y + _drag_offset_y;

			if (!FlxG.mouse.pressed) {
				// If we're not pressing any more - stop dragging
				onMouseUp(_dragging);
			}
		}
		super.update();
	}

	/**
	 * There has been a mouse press on an organ
	 */
	function onMouseDown(sprite:FlxSprite) {
		_drag_started = Timer.stamp();
		_dragging = cast sprite;
		_drag_offset_x = _dragging.x - FlxG.mouse.x;
		_drag_offset_y = _dragging.y - FlxG.mouse.y;

		// Make it bigger when grabbed
		FlxTween.tween(_dragging.scale, {x: GRABBED_SCALE, y: GRABBED_SCALE}, 0.1);

		// Bring to front
		members[members.indexOf(_dragging)] = members[members.length-1];
		members[members.length-1] = _dragging;
	}

	/**
	 * Mouse up on an organ
	 */
	function onMouseUp(sprite:FlxSprite) {
		if (Timer.stamp() - _drag_started < CLICK_TIMEOUT) {
			// We're clicking not dragging
			var organ:Organ = cast sprite;
			organ.click();
		} else {
			var placed = false; // Figure out if we're dropping on something

			for (hole in _holes) {
				// Check each hole
				var distance = new FlxPoint(hole.x, hole.y).distanceTo(new FlxPoint(_dragging.x, _dragging.y));

				// TODO: This assumes circular holes - if not - change
				if (distance < hole.width && hole.isEmpty()) {
					// if the distance is small enough
					// Add the _dragging to the _hole
					hole.addOrgan(_dragging);
					placed = true;
					break; // No need to look at other holes
				}
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

	/**
	 * Call for the next patient
	 */
	public function nextPatient() {
		if (!_addingPatient) { // Avoid spamming patients
			_addingPatient = true;
			if (_patient != null) {
				// If we have one, get rid of them first
				FlxTween.tween(_patient, {y: 0-(_patient.height)}, 1, {complete: patientOut});
			} else {
				// Otherwise just add the new one
				addNewPatient();
			}
		}
	}

	/**
	 * The previous patient has left the screen
	 */
	public function patientOut(tween:FlxTween) {
		// Remove their holes
		for (hole in _patient._holes) {
 			removeHole(hole);
 		}

		// Unload patient
		_patient.destroy();
		_patient = null;

		// Create a new patient
		addNewPatient();
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
		_patient = new Patient(500, FlxG.height, this);

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