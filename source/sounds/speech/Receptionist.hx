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
		AssetPaths.Filler29__wav => "A delivery of basketballs has been signed for"
	];

	public static var FILLER_KEYS = Utils.mapKeys(FILLER);

	public static var INTRODUCTIONS:Map<String, String> = [
		AssetPaths.Intro1__wav => "Doctors are reminded that donated organs are stored on the table to the right of surgery",
		AssetPaths.Intro2__wav => "Doctors should take care when removing organs from patients' bodies",
		AssetPaths.Intro3__wav => "We are happy to announce that we now stock a wide range of prosthetic knees, elbows and stomachs! Ask your doctor for details",
		AssetPaths.Intro4__wav => "Doctors are reminded that, in dire situations, improvisation may be necessary"
	];

	public static var PERFORMANCE:Map<String, String> = [
		AssetPaths.Performance_good__wav => "Good job doctor! He said he's never felt better!",
		AssetPaths.Performance_bad__wav => "Doctor, you're supposed to be making these people better!"
	];


}