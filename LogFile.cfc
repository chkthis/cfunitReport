<cfcomponent displayname="LogFile" hint="LogFile is a model object used to access a CFUnit log file.">
	
	<cffunction name="init" access="public" returntype="LogFile" output="false" hint="LogFile constructor – will read a file from the server and parse it for later access.">
		<cfargument name="fileName" type="string" required="true" />
		
		<cfset var fileContent = "" />
		<cfset var file = arrayNew( 1 ) />
		<cfset var i = 0 />
		<cfset var tempLine = structNew() />
		
		<cffile action="read" file="#fileName#" variable="fileContent">
		<cfset fileContent = listToArray(fileContent, chr(13)&chr(10)) />
		
		<cfloop from="1" to="#arrayLen( fileContent )#" index="i">
			
			<cfset fileContent[i] = replace(fileContent[i], """,,""", ""","""",""", "all") />
			
			<cfset tempLine = structNew() />
			
			<cfset tempLine[ "Severity" ] = listNextUnqualified( fileContent[i] ) />
			<cfset fileContent[i] = listDeleteAt(fileContent[i], 1) />
			
			<cfset tempLine[ "ThreadID" ] = listNextUnqualified( fileContent[i] ) />
			<cfset fileContent[i] = listDeleteAt(fileContent[i], 1) />
			
			<cfset tempLine[ "Date" ] = listNextUnqualified( fileContent[i] ) />
			<cfset fileContent[i] = listDeleteAt(fileContent[i], 1) />
			
			<cfset tempLine[ "Time" ] = listNextUnqualified( fileContent[i] ) />
			<cfset fileContent[i] = listDeleteAt(fileContent[i], 1) />
			
			<cfset tempLine[ "Application" ] = listNextUnqualified( fileContent[i] ) />
			<cfset fileContent[i] = listDeleteAt(fileContent[i], 1) />
			
			<cfif len( fileContent[i] ) GT 2 AND fileContent[i] NEQ """Message""">
				<cfset fileContent[i] = mid( fileContent[i], 2, len( fileContent[i] )-2 ) />
				
				<cfif listLen(fileContent[i], "|") GTE 3>
					<cfset tempLine[ "CFUnitID" ] = listGetAt( fileContent[i], "1", "|") />
					<cfset tempLine[ "Status" ] = listGetAt( fileContent[i], "2", "|") />
					<cfset tempLine[ "Counts" ] = listGetAt( fileContent[i], "3", "|") />
					
					<cfif listLast(fileContent[i], "|") EQ tempLine[ "Counts" ]>
						<cfset tempLine[ "Message" ] = "" />
					<cfelse>
						<cfset tempLine[ "Message" ] = listLast(fileContent[i], "|") />
					</cfif>
					
										
					<cfset arrayAppend(file, tempLine)>
				</cfif>
			</cfif>
			
		</cfloop>
		
		<cfset setFile( file ) />
		<cfset setCurrentLine( 1 ) />
		
		<cfreturn this />
	</cffunction>

	<cffunction name="listNextUnqualified" access="private" returntype="string" hint="Gets the next element in a list, and removes the first and last characters to 'unqualify' the element (see: ListQualify() ).">
		<cfargument name="list" required="true" hint="The list">
		<cfreturn mid( listFirst( arguments.list ), 2, len(listFirst( arguments.list ))-2 ) />
	</cffunction>

	<cffunction name="getLine" access="public" returntype="struct" output="false" hint="Returns the current line from the log file. Use nextLine() to move to the next line.">
		<cfset var f = getFile() />
		<cfreturn f[ getCurrentLine() ] />
	</cffunction>

	<cffunction name="setLineCount" access="private" returntype="void" output="false" hint="Sets the number of lines in this file">
		<cfargument name="lineCount" type="numeric" required="true" hint="Line count" />
		<cfset variables.lineCount = arguments.lineCount />
	</cffunction>
	
	<cffunction name="getLineCount" access="public" returntype="numeric" output="false" hint="Returns the number of lines in this file">
		<cfreturn variables.lineCount />
	</cffunction>

	<cffunction name="setCurrentLine" access="public" returntype="void" output="false" hint="Sets the index of the current line. Use getLine() to read the line.">
		<cfargument name="line" type="numeric" required="true" hint="New line index" />
		
		<cfif arguments.line GT getLineCount()>
			<cfset variables.line = getLineCount() />
		<cfelseif arguments.line LT 1>
			<cfset variables.line = 1 />
		<cfelse>
			<cfset variables.line = arguments.line />
		</cfif>
		
	</cffunction>
	
	<cffunction name="getCurrentLine" access="public" returntype="numeric" output="false" hint="Returns the index of the current line.">
		<cfreturn variables.line />
	</cffunction>

	<cffunction name="setFile" access="private" returntype="void" output="false" hint="Sets the log file. Will automatically reset the line count.">
		<cfargument name="file" type="array" required="true" hint="A pre-parsed file (an array of structures)" />
		<cfset setLineCount( arrayLen(arguments.file) ) />
		<cfset variables.file = arguments.file />
	</cffunction>
	
	<cffunction name="getFile" access="private" returntype="array" output="false" hint="Returns the log file.">
		<cfreturn variables.file />
	</cffunction>
	
	<cffunction name="nextLine" access="public" returntype="void" output="false" hint="Moves to the next line. Use getLine() to read the line.">
		<cfif isLastLine()>
			<cfset getLineCount() />
		<cfelse>
			<cfset setCurrentLine( getCurrentLine()+1 ) />
		</cfif>
		
	</cffunction>
	
	<cffunction name="isLastLine" access="public" returntype="boolean" output="false" hint="Returns true if the file has more lines.">
		<cfreturn yesNoFormat( getCurrentLine() GTE getLineCount() ) />
	</cffunction>
</cfcomponent>