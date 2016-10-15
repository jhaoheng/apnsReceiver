
var parsedJSON = require('./config.json');
// console.log(parsedJSON.port);
var port = parsedJSON.port;

var http = require("http");
var url = require("url");

function start(route, handle) {
  function onRequest(request, response) {
  	// console.log('here : ' + JSON.stringify(request.headers.host));
  	var authkey = request.headers.auth;
    var path = url.parse(request.url).path;

    route(handle, path, response, authkey);
  }

  http.createServer(onRequest).listen(port);
  console.log("Server has started.");
}

exports.start = start;


