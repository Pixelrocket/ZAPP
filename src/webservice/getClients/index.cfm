<cfcontent type="application/json" /><cfsilent>
<cfparam name="url.accountid" default="2" />
<cfinvoke component="../zapp" method="getClients" returnvariable="clients">
	<cfinvokeargument name="accountid" value="#url.accountid#" />
</cfinvoke>
</cfsilent><cfoutput>#clients#</cfoutput>