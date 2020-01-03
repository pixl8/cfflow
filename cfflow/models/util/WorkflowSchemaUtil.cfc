component singleton {

	variables._timeIntervalMultipliers = {
		  s = 1                  // seconds
		, m = 60                 // minutes
		, h = 60 * 60            // hours
		, d = 60 * 60 * 24       // days
		, w = 60 * 60 * 24 * 7   // weeks
		, y = 60 * 60 * 24 * 365 // years
	};

	public numeric function convertTimeIntervalToSeconds( required string friendlyTime ) {
		var pattern = "^([0-9]+)([smhdwy])$";

		if ( !ReFind( pattern, arguments.friendlyTime ) ) {
			throw( "[#arguments.friendlyTime#] is not a valid time interval.", "cfflow.util.invalid.interval", "Intervals must take the form: {number}{unit} where {unit} is one of: s (seconds), m (minutes), h (hours), d (days), w (weeks), y (years)." );
		}
		var measure = ReReplaceNoCase( arguments.friendlyTime, pattern, "\1" );
		var unit    = ReReplaceNoCase( arguments.friendlyTime, pattern, "\2" );

		return measure * _timeIntervalMultipliers[ unit ];
	}
}