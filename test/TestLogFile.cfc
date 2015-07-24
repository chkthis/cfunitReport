<cfcomponent name="TestFileReader" extends="net.sourceforge.cfunit.framework.TestCase">

	<cffunction name="setUp" returntype="void" access="public">
		<cfset variables.webroot = ExpandPath("/") />
		<cfset variables.absDir = ExpandPath("../") />
		<cfset variables.cfcPath = listChangeDelims( replaceNoCase(absDir,webroot, ""), ".", "\")  />
	</cffunction>

	<cffunction name="testReadLine" returntype="void" access="public">
		<cfset fileName = expandPath(".")&"\testFile.xlog">		
		<cfset fr = createObject("component", variables.cfcPath&".LogFile").init( fileName ) />
		
		<cfset assertFalse("LogFile.isLastLine() returned true before getting any lines", fr.isLastLine() ) />
		<cfset assertEquals("LogFile.cfc does not parse the correct number of lines", 12, fr.getLineCount() ) />
		
		<cfloop from="1" to="#fr.getLineCount()#" index="i">
			<cfset assertTrue("LogFile.getLine() did not return a structure.", isStruct( fr.getLine() ) ) />
			<cfset fr.nextLine() />
		</cfloop>
		
		<cfset assertTrue("LogFile.isLastLine() returned false after looping the entire file", fr.isLastLine() ) />
		
		<cfset fr.nextLine() />
		<cfset assertEquals("LogFile.nextLine() allowed to exceed the file line count", 12, fr.getCurrentLine() ) />
		
		<cfset fr.setCurrentLine( 100 )>
		<cfset assertEquals("LogFile.setCurrentLine() allowed to exceed the file line count", 12, fr.getCurrentLine() ) />
		
		<cfset fr.setCurrentLine( -1 )>
		<cfset assertEquals("LogFile.setCurrentLine() allowed a negitive number.", 1, fr.getCurrentLine() ) />
		
	</cffunction>
</cfcomponent>