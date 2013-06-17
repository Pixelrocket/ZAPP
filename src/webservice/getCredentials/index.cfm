<cfcontent type="application/json" /><cfsilent>
<cfset variables.username = "hilhorst" />
<cfset variables.password = "171049" />
<cfinvoke component="../zapp" method="getCredentials" returnvariable="credentials">
	<cfinvokeargument name="username" value="#variables.username#" />
	<cfinvokeargument name="password" value="#variables.password#" />
</cfinvoke>
</cfsilent><cfoutput>#credentials#</cfoutput>