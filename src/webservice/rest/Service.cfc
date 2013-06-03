component rest="true" restpath="/zappservice" {

	variables.zapp = new zapp();
	variables.username = "averschuur";
	variables.password = "huurcave-4711";

	remote Array function getCredentials(required String username restargsource="query", required String password restargsource="query")
		httpmethod="get" restpath="/credentials" produces="application/json" {

		var credentials = variables.zapp.getCredentials(arguments.username, arguments.password);

		return queryRecords(credentials);
	}

	remote Array function getClients()
		httpmethod="get" restpath="/clients" produces="application/json" {

		var accountid = "2";
		var clients = variables.zapp.getClients(accountid);

		return queryRecords(clients);
	}

	remote Array function getDailyReports()
		httpmethod="get" restpath="/dailyreports" produces="application/json" {

		var clientid = "7";
		var report = variables.zapp.getDailyReports(clientid);

		return queryRecords(report);
	}

	private Array function queryRecords(required Query query) {
		var result = [];
		while (arguments.query.next()) {
			var record = {};
			for (var column in arguments.query.columnArray()) {
				record[LCase(column)] = arguments.query.getObject(column);
			}
			result.append(record);
		}

		return result;
	}

}