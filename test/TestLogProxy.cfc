<cfcomponent name="TestLogProxy" extends="net.sourceforge.cfunit.framework.TestCase">
	
	<cffunction name="setUp" returntype="void" access="public">
		<cfset variables.webroot = ExpandPath("/") />
		<cfset variables.absDir = ExpandPath("../") />
		<cfset variables.cfcPath = listChangeDelims( replaceNoCase(absDir,webroot, ""), ".", "\")  />
	</cffunction>
	
	<cffunction name="testGenerateXMLTests" returntype="void" access="public">
		<cfset var logFileName = expandPath(".")&"\testFile.xlog" />
		<cfset var xmlFileName = expandPath(".")&"\testFile.xml" />
		
		<cfset var proxy = createObject("component", variables.cfcPath&".LogProxy") />
		<cfset var expect = "" />
		
		<cfset var logFile = createObject("component", variables.cfcPath&".LogFile").init( logFileName ) />
		
		<cffile action="read" file="#xmlFileName#" variable="expect">
		
		<cfset assertEquals("generateXMLTests() failed", expect, toString( proxy.generateXMLTests( logFile ) ) ) />
		
	</cffunction>

</cfcomponent>