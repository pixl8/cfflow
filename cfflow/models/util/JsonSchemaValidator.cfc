component singleton=true accessors=true {

	property name="schemaFilePath" type="string" default="";
	property name="schemaBaseUri"  type="string" default="";

// PUBLIC API METHODS
	public struct function validate( required string json ) {
		var validator = _getValidator();
		var results = {
			"error" = {},
			"valid" = true
		};

		try {
			validator.validate( _obj( "org.json.JSONObject" ).init( arguments.json ) );
		} catch ( org.everit.json.schema.ValidationException e ) {
			results.valid = false;
			results.error = {
				  "violationCount"     = e.violationCount          ?: ""
				, "pointerToViolation" = e.pointerToViolation      ?: "##"
				, "message"            = e.message                 ?: ""
				, "keyword"            = e.keyWord                 ?: ""
				, "allMessages"        = _toCfArray( e.allMessages ?: [] )
			};
		}

		return results;
	}

// PRIVATE HELPERS
	private any function _setupSchemaValidator() {
		var schema    = FileRead( getSchemaFilePath() );
		var schemaObj = _obj( "org.json.JSONObject" ).init( _obj( "org.json.JSONTokener" ).init( schema ) );
		var schemaLoader = _obj( "org.everit.json.schema.loader.SchemaLoader" ).builder()
			.schemaJson( schemaObj )
			.resolutionScope( getSchemaBaseUri() )
			.build();

		_setValidator( schemaLoader.load().build() );

		return _getValidator();
	}

	private any function _obj( required string class ) {
		return CreateObject( "java", arguments.class, _getLib() );
	}

	private array function _getLib() {
		var libDir = GetDirectoryFromPath( GetCurrentTemplatePath() ) & "jsonlib";
		return DirectoryList( libDir, false, "path", "*.jar" );
	}

	private array function _toCfArray( javaArr ) {
		var cfArray = [];

		for( var entry in arguments.javaArr ) {
			ArrayAppend( cfArray, entry );
		}

		return cfArray;
	}

// GETTERS AND SETTERS
	private any function _getValidator() {
		return _validator ?: _setupSchemaValidator();
	}
	private void function _setValidator( required any validator ) {
		_validator = arguments.validator;
	}

}