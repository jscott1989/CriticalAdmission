package sounds.speech;

class Receptionist {

	public static var FILLER:Map<String, String> = [
		AssetPaths.Filler1__wav => "Doctors are reminded that...uhm...maybe connect this bit to that bit?",
		AssetPaths.Filler2__wav => "Doctors are reminded to keep calm and carry on",
		AssetPaths.Filler3__wav => "All staff are reminded to wash their hands regularly",
		AssetPaths.Filler4__wav => "Doctors: please ensure your tools are left on the table, and not inside the patient",
		AssetPaths.Filler5__wav => "Staff anouncement: Don't panic",
		AssetPaths.Filler6__wav => "Staff anouncement: Don't panic",
		AssetPaths.Filler7__wav => "Doctor required in surgery",
		AssetPaths.Filler8__wav => "Doctor required in surgery",
		AssetPaths.Filler9__wav => "Doctor to Emergency",
		AssetPaths.Filler10__wav => "Doctor to the Emergency room",
		AssetPaths.Filler11__wav => "Nurse required in Surgery",
		AssetPaths.Filler12__wav => "Nurse to Emergency",
		AssetPaths.Filler13__wav => "Nurse to the Emergency room",
		AssetPaths.Filler14__wav => "Nurse to the Emergency room",
		AssetPaths.Filler15__wav => "Patients are asked to be patient",
		AssetPaths.Filler16__wav => "Patients are asked to be patient",
		AssetPaths.Filler17__wav => "Patients are asked to wait quietly",
		AssetPaths.Filler18__wav => "Patients are asked to wait quietly",
		AssetPaths.Filler19__wav => "Patients are requested to wait quietly",
		AssetPaths.Filler20__wav => "Staff members are reminded to rest frequently",
		AssetPaths.Filler21__wav => "WiFi is now available in all of our Operating Theatres",
		AssetPaths.Filler22__wav => "Pay no attention to the journalists by the gate",
		AssetPaths.Filler23__wav => "Remember: nobody likes a tattletale",
		AssetPaths.Filler24__wav => "Patients are reminded not to leave organs in the corridors",
		AssetPaths.Filler25__wav => "Staff members are reminded that organs are expensive; stationary is not",
		AssetPaths.Filler26__wav => "We are not liable for misplaced bodyparts. Finders keepers",
		AssetPaths.Filler27__wav => "Contrary to rumours, we are not a bionics factory",
		AssetPaths.Filler28__wav => "No smoking in the hospital, please",
		AssetPaths.Filler29__wav => "A delivery of basketballs has been signed for",
		AssetPaths.Intro1__wav => "Doctors are reminded that donated organs are stored on the table to the right of surgery",
		AssetPaths.Intro2__wav => "Doctors should take care when removing organs from patients' bodies",
		AssetPaths.Intro3__wav => "We are happy to announce that we now stock a wide range of prosthetic knees, elbows and stomachs! Ask your doctor for details",
		AssetPaths.Intro4__wav => "Doctors are reminded that, in dire situations, improvisation may be necessary"
	];

	public static var FILLER_KEYS = Utils.mapKeys(FILLER);

	public static var VIP_INCOMING:Map<String, String> = [
		AssetPaths.VIP1__wav => "Staff announcement: A VIP has entered the hospital",
		AssetPaths.VIP2__wav => "VIP incoming",
		AssetPaths.VIP3__wav => "VIP incoming",
	];

	public static var VIP_INCOMING_KEYS = Utils.mapKeys(VIP_INCOMING);

	public static var VIP_LEAVING:Map<String, String> = [
		AssetPaths.VIP4__wav => "The VIP has left the hospital",
		AssetPaths.VIP5__wav => "The VIP has left the hospital",
	];

	public static var VIP_LEAVING_KEYS = Utils.mapKeys(VIP_LEAVING);

	public static var VIP_HAPPY:Map<String, String> = [
		AssetPaths.VIP6__wav => "The VIP said their treatment was excellent",
		AssetPaths.VIP7__wav => "The VIP said their treatment was excellent",
	];

	public static var VIP_HAPPY_KEYS = Utils.mapKeys(VIP_HAPPY);

	public static var VIP_UNHAPPY:Map<String, String> = [
		AssetPaths.VIP8__wav => "The VIP said their treatment was awful",
		AssetPaths.VIP9__wav => "The VIP said their treatment was awful",
	];

	public static var VIP_UNHAPPY_KEYS = Utils.mapKeys(VIP_UNHAPPY);

	public static var HIGH_REPUTATION:Map<String, String> = [
		AssetPaths.Reputation1__wav => "Patients are really loving our hospital",
		AssetPaths.Reputation2__wav => "Our reputation is as high as it's ever been",
	];

	public static var HIGH_REPUTATION_KEYS = Utils.mapKeys(HIGH_REPUTATION);

	public static var LOW_REPUTATION:Map<String, String> = [
		AssetPaths.Reputation3__wav => "Our reputation is poor. Do try to improve",
		AssetPaths.Reputation4__wav => "Our hospital is under intense scrutiny. Do be careful",
	];

	public static var LOW_REPUTATION_KEYS = Utils.mapKeys(LOW_REPUTATION);


}