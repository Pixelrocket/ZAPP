<cfcomponent output="false">

	<!--- Variables for component --->
	<cfif Find("railo",cgi.server_name)>
		<cfset this.datasource = "zapp" />
	<cfelseif FindNoCase("localhost",cgi.server_name) EQ 0>
		<cfset this.datasource = "ds_zilliz_test" />
	<cfelse>
		<cfset this.datasource = "ds_zilliz" />
	</cfif>
	<cfset this.passwordkey = "Z2OIhfkjsyIJKHH23GfjhfkuIYUW" />

	<!--- Validate user login --->
	<cffunction name="getCredentials" access="remote" returnformat="JSON" output="false" hint="Validate user login">
		<cfargument name="username" required="yes" type="string" />
		<cfargument name="password" required="yes" type="string" />
		<cfset var passwordEncrypted = Encrypt(arguments.password,this.passwordkey) />
		<cfquery name="qrySelect" datasource="#this.datasource#" cachedwithin="#CreateTimeSpan(0,0,0,0)#">
			SELECT
					cue_id AS accountid
			,		cue_first_name AS firstname
			,		cue_infix AS infix
			,		cue_last_name AS lastname
			,		cue_email_address AS emailaddress
			,		aus_id AS userid
			,		COUNT(cuc_id) AS noofclients
			FROM
					aut_user
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
			WHERE
					aus_username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" />
			AND
					aus_password_encoded = <cfqueryparam cfsqltype="cf_sql_varchar" value="#passwordEncrypted#" />
			AND
					aus_active = 1
			AND
					ccr_active = 1
			GROUP BY
					cue_id
			,		cue_first_name
			,		cue_infix
			,		cue_last_name
			,		cue_email_address
			,		aus_id
		</cfquery>
		<cfscript>
			var queryConvertedToArray = [];
			for( var i=1; i LTE qrySelect.recordcount; i++ ) {
				queryConvertedToArray[i] = {};
				queryConvertedToArray[i]["accountid"] = qrySelect.accountid[i];
				queryConvertedToArray[i]["firstname"] = qrySelect.firstname[i];
				queryConvertedToArray[i]["infix"] = qrySelect.infix[i];
				queryConvertedToArray[i]["lastname"] = qrySelect.lastname[i];
				queryConvertedToArray[i]["emailaddress"] = qrySelect.emailaddress[i];
				queryConvertedToArray[i]["userid"] = qrySelect.userid[i];
				queryConvertedToArray[i]["noofclients"] = qrySelect.noofclients[i];
			}
		</cfscript>
		<cfreturn serializejson(queryConvertedToArray) />
	</cffunction>

	<!--- Get clients from account --->
	<cffunction name="getClients" access="remote" returnformat="JSON" output="false" hint="Get clients from account">
		<cfargument name="accountid" required="yes" type="string" />
		<cfquery name="qrySelect" datasource="#this.datasource#" cachedwithin="#CreateTimeSpan(0,0,0,0)#">
			SELECT
					ccl_id AS clientid
			,		ccl_aanspreektitel AS clientnameinformal
			,		rco_relatie_opgemaakt AS clientnameformal
			,		rco_photo AS photo
			,		rco_gender AS gender
			FROM
					cmp_user_extranet_clients
				LEFT OUTER JOIN ccc_client
					ON cmp_user_extranet_clients.cuc_ccl_id = ccc_client.ccl_id
				LEFT OUTER JOIN rel_contact
					ON ccc_client.ccl_rco_id = rel_contact.rco_id
			WHERE
					cuc_cue_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.accountid#" />
			AND
					ccl_active = 1
		</cfquery>
		<cfscript>
			var queryConvertedToArray = [];
			for( var i=1; i LTE qrySelect.recordcount; i++ ) {
				queryConvertedToArray[i] = {};
				queryConvertedToArray[i]["clientid"] = qrySelect.clientid[i];
				queryConvertedToArray[i]["clientnameinformal"] = qrySelect.clientnameinformal[i];
				queryConvertedToArray[i]["clientnameformal"] = qrySelect.clientnameformal[i];
				queryConvertedToArray[i]["photo"] = qrySelect.photo[i];
				queryConvertedToArray[i]["gender"] = qrySelect.gender[i];
			}
		</cfscript>
		<cfreturn serializejson(queryConvertedToArray) />
	</cffunction>

	<!--- Get daily reports from clients --->
	<cffunction name="getDailyReports" access="remote" returnformat="JSON" output="false" hint="Get daily reports from clients">
		<cfargument name="clientid" required="yes" type="string" />
		<cfquery name="qrySelect" datasource="#this.datasource#" cachedwithin="#CreateTimeSpan(0,0,0,0)#">
			SELECT
					cdo_id AS dossierid
			,		cem_first_name AS employeefirstname
			,		cem_infix AS employeeinfix
			,		cem_last_name AS employeelastname
			,		cue_first_name AS userfirstname
			,		cue_infix AS userinfix
			,		cue_last_name AS userlastname
			,		mma_id AS dossiermapid
			,		mma_map AS dossiermap
			,		cdo_date
			,		cdo_subject
			,		cdo_dossier
			,		cdo_intranet
			,		cdo_date_added
			FROM
					ccc_dossier
				LEFT OUTER JOIN aut_user
					ON ccc_dossier.cdo_aus_id = aut_user.aus_id
				LEFT OUTER JOIN cmp_user_extranet
					ON aut_user.aus_cue_id = cmp_user_extranet.cue_id
				LEFT OUTER JOIN cmp_employee
					ON aut_user.aus_cem_id = cmp_employee.cem_id
				LEFT OUTER JOIN rel_contact
					ON aut_user.aus_rco_id = rel_contact.rco_id
				LEFT OUTER JOIN map_map
					ON ccc_dossier.cdo_mma_id = map_map.mma_id
						LEFT OUTER JOIN map_maptype
							ON map_map.mma_mmt_id = map_maptype.mmt_id
			WHERE
					cdo_ccl_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.clientid#" />
			AND
					mma_extranet = 1
			AND
					mmt_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="C" />
			ORDER BY
					cdo_date_added DESC
		</cfquery>
		<cfscript>
			var queryConvertedToArray = [];
			for( var i=1; i LTE qrySelect.recordcount; i++ ) {
				queryConvertedToArray[i] = {};
				queryConvertedToArray[i]["dossierid"] = qrySelect.dossierid[i];
				queryConvertedToArray[i]["employeefirstname"] = qrySelect.employeefirstname[i];
				queryConvertedToArray[i]["employeeinfix"] = qrySelect.employeeinfix[i];
				queryConvertedToArray[i]["employeelastname"] = qrySelect.employeelastname[i];
				queryConvertedToArray[i]["userfirstname"] = qrySelect.userfirstname[i];
				queryConvertedToArray[i]["userinfix"] = qrySelect.userinfix[i];
				queryConvertedToArray[i]["userlastname"] = qrySelect.userlastname[i];
				queryConvertedToArray[i]["dossiermapid"] = qrySelect.dossiermapid[i];
				queryConvertedToArray[i]["dossiermap"] = qrySelect.dossiermap[i];
				queryConvertedToArray[i]["cdo_date"] = qrySelect.cdo_date[i];
				queryConvertedToArray[i]["cdo_subject"] = qrySelect.cdo_subject[i];
				queryConvertedToArray[i]["cdo_dossier"] = qrySelect.cdo_dossier[i];
				queryConvertedToArray[i]["cdo_intranet"] = qrySelect.cdo_intranet[i];
				queryConvertedToArray[i]["cdo_date_added"] = qrySelect.cdo_date_added[i];
			}
		</cfscript>
		<cfreturn serializejson(queryConvertedToArray) />
	</cffunction>

</cfcomponent>
