<cfcontent type="application/json" /><cfsilent>
<cfset variables.accountid = "2" />
<cfinvoke component="../zapp" method="getClients" returnvariable="clients">
	<cfinvokeargument name="accountid" value="#variables.accountid#" />
</cfinvoke>
<cfset result = []>
<cfwhile clients.next()>
	<cfset record = {}>
	<cfloop list="#clients.ColumnList#" index="column">
		<cfset record[LCase(column)] = clients.getObject(column)>
	</cfloop>
	<cfset ArrayAppend(result, record)>
</cfwhile>
</cfsilent><cfoutput>#SerializeJSON(result)#</cfoutput>