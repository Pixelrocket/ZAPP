<cfcontent type="application/json" /><cfsilent>
<cfset variables.clientid = "7" />
<cfinvoke component="../zapp" method="getDailyReports" returnvariable="dailyreports">
	<cfinvokeargument name="clientid" value="#variables.clientid#" />
</cfinvoke>
</cfsilent><cfoutput>#dailyreports#</cfoutput>