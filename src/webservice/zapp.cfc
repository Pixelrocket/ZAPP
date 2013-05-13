<cfcomponent output="false">

	<!--- Variables for component --->
	<cfset this.datasource = "ds_zilliz_test" />
	<cfset this.passwordkey = "Z2OIhfkjsyIJKHH23GfjhfkuIYUW" />

	<!--- Validate user login --->
	<cffunction name="getCredentials" access="remote" returntype="any" output="false" hint="Validate user login">
		<cfargument name="username" required="yes" type="string" />
		<cfargument name="password" required="yes" type="string" />
		<cfset var passwordEncrypted = Encrypt(arguments.password, this.passwordkey) />
		<cfquery name="qrySelect" datasource="#this.datasource#" cachedwithin="#CreateTimeSpan(0,0,0,0)#">
			SELECT				cue_id AS accountid
								, cue_first_name AS firstname
								, cue_infix AS infix
								, cue_last_name AS lastname
								, cue_email_address AS emailaddress
								, aus_id AS userid
								, COUNT(cuc_id) AS noofclients
			FROM				aut_user
									LEFT OUTER JOIN ctr_crowner
										ON aut_user.aus_ccr_id = ctr_crowner.ccr_id
									LEFT OUTER JOIN cmp_employee
										ON aut_user.aus_cem_id = cmp_employee.cem_id
											 LEFT OUTER JOIN rel_contact
												ON cmp_employee.cem_rco_id = rel_contact.rco_id
									LEFT OUTER JOIN cmp_user_extranet
										ON aut_user.aus_cue_id = cmp_user_extranet.cue_id
										AND cue_active = 1
											LEFT OUTER JOIN cmp_user_extranet_clients
												ON cmp_user_extranet.cue_id = cmp_user_extranet_clients.cuc_cue_id
			WHERE				aus_username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" />
								AND aus_password_encoded = <cfqueryparam cfsqltype="cf_sql_varchar" value="#passwordEncrypted#" />
								AND aus_active = 1
								AND ccr_active = 1
			GROUP BY			cue_id
								, cue_first_name
								, cue_infix
								, cue_last_name
								, cue_email_address
								, aus_id
		</cfquery>
		<cfif qrySelect.recordcount NEQ 1 OR qrySelect.cue_id EQ "" OR qrySelect.aantal_clienten EQ 0>
			<cfset var returnVariable = ["access denied"] />
		<cfelse>
			<cfset var returnVariable = qrySelect />
		</cfif>
		<cfreturn serializejson(returnVariable) />
	</cffunction>

</cfcomponent>