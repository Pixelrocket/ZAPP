<cfcontent type="application/json" /><cfsilent>
<cfset variables.username = "averschuur" />
<cfset variables.password = "huurcave-4711" />
<cfinvoke component="../zapp" method="getCredentials" returnvariable="credentials">
	<cfinvokeargument name="username" value="#variables.username#" />
	<cfinvokeargument name="password" value="#variables.password#" />
</cfinvoke>
<cfset result = []>
<cfwhile credentials.next()>
	<cfset record = {}>
	<cfloop list="#credentials.ColumnList#" index="column">
		<cfset record[LCase(column)] = credentials.getObject(column)>
	</cfloop>
	<cfset ArrayAppend(result, record)>
</cfwhile>
</cfsilent><cfoutput>#SerializeJSON(result)#</cfoutput>