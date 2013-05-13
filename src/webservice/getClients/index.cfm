<cfcontent type="application/json" /><cfsilent>
<cfset variables.accountid = "2" />
<cfinvoke component="../zapp" method="getClients" returnvariable="clients">
<cfinvokeargument name="accountid" value="#variables.accountid#" />
</cfinvoke>
</cfsilent><cfoutput>#clients#</cfoutput>