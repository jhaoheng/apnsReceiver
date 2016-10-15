function route(handle, path, response, authkey) {

	console.log("PATH : " + path);
	console.log("authkey : " + authkey);

	// var path = "local.com:1111/{user}/resource";
	// console.log(path.split('/')[2]);
	
	var parsedJSON = require('./config.json');
	var key = parsedJSON.authkey;
	if (path.split('/')[2] == 'resource' && authkey == key) {
		handle(response, path.split('/')[1]);
	}
	// if (typeof handle[path] === 'function') {
	//   handle[path](response);
	// } 
	else {
		response.writeHead(404, {"Content-Type": "text/plain"});
		response.write("404 Not found");
		response.end();
	}
}

exports.route = route;