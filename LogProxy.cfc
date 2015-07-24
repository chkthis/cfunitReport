<cfcomponent name="LogProxy">
	<cffunction name="getTestDetails" access="remote" output="true" returntype="void">
		<cfargument name="id" required="yes">
		<cfset var log = "" />
		
		<cftry>
			<cfset log = createObject("component", "LogFile").init("D:\CFusionMX7\logs\CFUnit.log") />
		
			<cfsetting showdebugoutput="false" enablecfoutputonly="true">
			<cfcontent type="text/xml; utf-8" reset="true" />
			
			<cfoutput>#generateXMLTestData( log, arguments.id )#</cfoutput>
			<cfcatch>
				<cfoutput><?xml version="1.0" encoding="utf-8"?>
				<tests>
					<error><![CDATA[#CFCATCH.Message#: #CFCATCH.Detail#]]></error>
				</tests></cfoutput>
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="getTests" access="remote" output="true" returntype="void">	
		<cfset var log = "" />
		
		<cftry>
			<cfset log = createObject("component", "LogFile").init("D:\CFusionMX7\logs\CFUnit.log") />
		
			<cfsetting showdebugoutput="false" enablecfoutputonly="true">
			<cfcontent type="text/xml; utf-8" reset="true" />
			
			<cfoutput>#generateXMLTests( log )#</cfoutput>
			<cfcatch>
				<cfoutput><?xml version="1.0" encoding="utf-8"?>
				<tests>
					<error><![CDATA[#CFCATCH.Message#: #CFCATCH.Detail#]]></error>
				</tests></cfoutput>
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="generateXMLTests" access="public" output="false" returntype="xml">
		<cfargument name="log" required="yes" type="LogFile">
		
		<cfset var lastID = "" />
		<cfset var line = "" />
		<cfset var xml = "" />
				
		<!--- TODO: Make this dynamic based on CFUnit.log --->
		<cfxml variable="xml">
			<?xml version="1.0" encoding="utf-8"?>
			<tests>
				<cfoutput>
					<cfloop condition="NOT #arguments.log.isLastLine()#">
						<cfset line = arguments.log.getLine() />
						
						<cfif lastID NEQ line.CFUnitID>
							<test>
								<id>#line.cfunitid#</id>
								<status>#line.status#</status>
								<application>#line.application#</application>
								<counters>#line.counts#</counters>
								<time>#line.date# #line.time#</time>
							</test>
							<cfset lastID = line.CFUnitID />
						</cfif>
						
						<cfset line = arguments.log.nextLine() />
					</cfloop>
				</cfoutput>
			</tests>
		</cfxml>
		
		<cfreturn xml />
		
	</cffunction>
	
	
	<cffunction name="generateXMLTestData" access="public" output="false" returntype="xml">
		<cfargument name="log" required="yes" type="LogFile">
		<cfargument name="id" required="yes">
		
		<cfset var line = "" />
		<cfset var xml = "" />
				
		<!--- TODO: Make this dynamic based on CFUnit.log --->
		<cfxml variable="xml">
			<?xml version="1.0" encoding="utf-8"?>
			<tests>
				<cfoutput>
					<cfloop condition="NOT #arguments.log.isLastLine()#">
						<cfset line = arguments.log.getLine() />
						
						<cfif line.cfunitid EQ arguments.id>
							<test>
								<id>#line.cfunitid#</id>
								<threadid>#line.threadid#</threadid>
								<application><![CDATA[#line.application#]]></application>
								<status>#line.status#</status>
								<counters>#line.counts#</counters>
								<date>#line.date#</date>
								<time>#line.time#</time>
								<message><![CDATA[#line.message#]]></message>
							</test>
						</cfif>
						
						<cfset line = arguments.log.nextLine() />
					</cfloop>
				</cfoutput>
			</tests>
		</cfxml>
		
		<cfreturn xml />
		
	</cffunction>
	
</cfcomponent>