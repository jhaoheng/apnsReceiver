console.log("Hello World");


function say(word) {
  console.log(word);
}

function execute(someFunction, value) {
  someFunction(value);
}

execute(say, "Hello");

var url = "local.com:1111/{user}/resource";
console.log(url.split('/')[1]);


if (url.split('/')[2] == 'resource') {
	console.log("yes");
}


var parsedJSON = require('./config.json');
console.log(parsedJSON.age);
// console.log('json : ' + JSON.parse(parsedJSON));