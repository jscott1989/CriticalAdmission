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

	private var GRABBED_SCALE = 1.3;
	private var DEFAULT_SCALE = 1;
	private var CLICK_TIMEOUT = 0.2;

	// General scene items
	private var _table:FlxSprite;

	// The thing currently being dragged (if any)
	private var _dragging:Organ;
	private var _drag_offset_x:Float;
	private var _drag_offset_y:Float;
	private var _drag_started:Float;

	// Patient
	private var _patient:Patient;

	// Holes
	private var _holes:Array<Hole>;
	override public function create():Void
	{
		FlxG.debugger.visible = true;

		// Scene
		_table = new FlxSprite(420,-1);
		_table.loadGraphic("assets/images/Table.png");
		add(_table);

		// Holes
 		_holes = new Array<Hole>();
 		
 		addHole(new UIHole(10, 10, new Next(200, 200, this)));

 		// Organs
 		addOrgan(new Organ(440, 20, "Heart", this));
 		addOrgan(new Organ(440, 140, "Stomach", this));

		super.create();
	}

	public function addHole(hole:Hole) {
		_holes.push(hole);
		add(hole);

		if (hole._organ != null) {
			addOrgan(hole._organ);
		}
	}

	public function addOrgan(organ:Organ) {
		add(organ);
		MouseEventManager.add(organ, onMouseDown, onMouseUp); 
	}

	public function removeHole(hole:Hole) {
		_holes.remove(hole);
		remove(hole, true);

		if (hole._organ != null) {
			removeOrgan(hole._organ);
		}
	}

	public function removeOrgan(organ:Organ) {
		remove(organ, true);
		MouseEventManager.remove(organ);
	}
	
	/**
	 * Clean up resources
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		if (_dragging != null && (Timer.stamp() - _drag_started > CLICK_TIMEOUT)) {
			// Deal with dragging

			if (_dragging.hole != null) {
				// If it was in a hole, remove it
				FlxG.log.add("remove from hole");
				_dragging.hole.removeOrgan();
				// FlxG.log.add(_holes);
			}

			// maintain offset
			_dragging.x = FlxG.mouse.x + _drag_offset_x;
			_dragging.y = FlxG.mouse.y + _drag_offset_y;

			if (!FlxG.mouse.pressed) {
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

				if (distance < hole.width && hole.isEmpty()) {
					// if the distance is small enough
					// Add the _dragging to the _hole
					hole.addOrgan(_dragging);
					placed = true;
					break;
				}
			}

			if (!placed && _dragging.x < _table.x) {
				// If it's not on the table and not placed, put it on the table
				FlxTween.tween(_dragging, {x: (_table.x + 20)}, 0.1);
			}

		}

		FlxTween.tween(_dragging.scale, {x: DEFAULT_SCALE, y: DEFAULT_SCALE}, 0.1);
		_dragging = null;
	}

	public function nextPatient() {
		if (_patient != null) {
			FlxTween.tween(_patient, {y: 0-(_patient.height)}, 1, {complete: patientOut});
		} else {
			addNewPatient();
		}
	}

	public function patientOut(tween:FlxTween) {
		FlxG.log.add("PATIENT OUT");

		for (hole in _patient._holes) {
 			removeHole(hole);
 		}

		// Unload patient
		_patient.destroy();
		_patient = null;

		addNewPatient();
	}



	public function addNewPatient() {
		// Patient
		_patient = new Patient(200, FlxG.height, this);

		// _patient = new Patient(200, 100, this);

		add(_patient);
		for (hole in _patient._holes) {
 			addHole(hole);
 		}

 		FlxTween.tween(_patient, {y: 20}, 1);
	}
}