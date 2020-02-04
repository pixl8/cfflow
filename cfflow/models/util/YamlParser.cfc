component singleton {

	function deserialize( required string content ) {
		var yamlLoader = CreateObject( "java", "org.yaml.snakeyaml.Yaml", _getLib() );
		return toCF( yamlLoader.load( arguments.content ) );
	}

	function toCF( map ) {
		if ( isNull( arguments.map ) ) {
			return;
		}

		// if we're in a loop iteration and the array item is simple, return it
		if ( isSimpleValue( arguments.map ) ) {
			if ( ReFind( "^(true|false)$", arguments.map ) ) {
				return arguments.map == "true";
			}
			return arguments.map;
		}

		if ( isArray( map ) ) {
			var cfObj = [];
			for( var obj in arguments.map ) {
				arrayAppend( cfObj, toCF( obj ) );
			}
		} else {
			var cfObj = {};
			try {
				cfObj.putAll( arguments.map );
			} catch ( any e ) {
				return arguments.map;
			}

			// loop our keys to ensure first-level items with sub-documents objects are converted
			for ( var key in cfObj ) {
				if ( ! isNull( cfObj[ key ] ) ) {
					cfObj[ key ] = toCF( cfObj[ key ] );
				}
			}
		}

		return cfObj;
	}

	function _getLib() {
		var libDir = GetDirectoryFromPath( GetCurrentTemplatePath() ) & "yamllib/";
		return DirectoryList( libDir, false, "path", "*.jar" );
	}
}
