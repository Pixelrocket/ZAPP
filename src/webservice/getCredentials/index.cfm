<cfcontent type="application/json" /><cfsilent>
<cfparam name="url.frmUsername" default="hilhorst" />
<cfparam name="url.frmPassword" default="171049" />
<cfinvoke component="../zapp" method="getCredentials" returnvariable="credentials">
	<cfinvokeargument name="username" value="#url.frmUsername#" />
	<cfinvokeargument name="password" value="#url.frmPassword#" />
</cfinvoke>
</cfsilent><cfoutput>#credentials#</cfoutput>