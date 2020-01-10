component singleton {

// CONSTRUCTOR
	public any function init(
		  required string schemaFilePath
		, required string schemaBaseUri
	) {
		_setupSchemaValidator( argumentCollection=arguments );

		return this;
	}

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
	private void function _setupSchemaValidator(
		  required string schemaFilePath
		, required string schemaBaseUri
	) {

		var schema    = FileRead( arguments.schemaFilePath );
		var schemaObj = _obj( "org.json.JSONObject" ).init( _obj( "org.json.JSONTokener" ).init( schema ) );
		var schemaLoader = _obj( "org.everit.json.schema.loader.SchemaLoader" ).builder()
			.schemaJson( schemaObj )
			.resolutionScope( arguments.schemaBaseUri )
			.build();

		_setValidator( schemaLoader.load().build() );
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
		return _validator;
	}
	private void function _setValidator( required any validator ) {
		_validator = arguments.validator;
	}

}