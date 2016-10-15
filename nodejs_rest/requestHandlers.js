var exec = require("child_process").exec;

// function start(response) {
//   console.log("Request handler 'start' was called.");

//   exec("ls -lah", function (error, stdout, stderr) {
//     response.writeHead(200, {"Content-Type": "text/plain"});
//     response.write(stdout);
//     response.end();
//   });
// }

// function upload(response) {
//   console.log("Request handler 'upload' was called.");
//   response.writeHead(200, {"Content-Type": "text/plain"});
//   response.write("Hello Upload");
//   response.end();
// }

// exports.start = start;
// exports.upload = upload;

var processResult = function(stdout) {  
    var lines = stdout.toString().split('\n');
    var results = [];
    lines.forEach(function(line, index) {
        if (!line) {
        	return results;
        }
        results[index] = line;
    });
    // console.log('first : '+results);
    return results;
};

function getResource(response, user) {
	// response.writeHead(200, {"Content-Type": "text/plain"});
	response.writeHead(200, {"Content-Type": "application/json"});
	// response.write("USER : " + user + '\n\n');
	var resourceArray = [];

	var cmd = "/Applications/ejabberd-16.09/bin/ejabberdctl user_resources "+user+" xmpp";
	exec(cmd, function (error, stdout, stderr) {
		// response.write(stdout);
		// response.end();
		resourceArray = processResult(stdout);
		var json = JSON.stringify({ 
		user: user, 
		resource: resourceArray
		});
		response.end(json);
	});

	// console.log(resourceArray);
	// var resourceArray = ["item1", "item2"];
	// var otherObject = { item1: "item1val", item2: "item2val" };
}

exports.getResource = getResource;

