component {
	this.name = "CFFlow Test Suite";

	this.mappings[ '/tests'    ] = ExpandPath( "/" );
	this.mappings[ '/testbox'  ] = ExpandPath( "/testbox" );
	this.mappings[ '/cfflow' ] = ExpandPath( "../cfflow" );

	setting requesttimeout=60000;
}
