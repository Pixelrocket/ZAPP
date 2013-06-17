<cfcontent type="application/json" /><cfsilent>
<cfset variables.username = "averschuur" />
<cfset variables.password = "huurcave-4711" />
<cfinvoke component="../zapp" method="getCredentials" returnvariable="credentials">
	<cfinvokeargument name="username" value="#variables.username#" />
	<cfinvokeargument name="password" value="#variables.password#" />
</cfinvoke>
</cfsilent><cfoutput>#credentials#</cfoutput>