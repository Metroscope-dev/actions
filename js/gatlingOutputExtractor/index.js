const core = require('@actions/core');
const fs = require('fs');

try {
    let filename = '/home/runner/work/mts-gatling/mts-gatling/build/target_project.json';
    fs.readFile(filename, 'utf8', function(err, data) {
        if (data) {
            console.log("target_project.json has been read successfully!");
            core.setOutput("message", data);
            console.log('Message = ', data);
        } else {
            console.log(err);
        }
    });
} catch (error) {
    core.setFailed(error.message);
}
