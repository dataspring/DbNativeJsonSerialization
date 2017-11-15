//
  // proc-functions.js
  //

  var cumulativeBytes = 0;


  module.exports = {
    setJSONBody: setJSONBody,
    logResponse: logResponse
  }

  function setJSONBody(requestParams, context, ee, next) {
    return next(); // MUST be called for the scenario to continue
  }

  function logResponse(requestParams, response, context, ee, next) {

    //console.log(requestParams);  
    //console.log(response.request.body, response.request.href, response.statusCode, response.body);

    var responseBytes = Number(response.headers['content-length']);
    cumulativeBytes = cumulativeBytes + responseBytes;

    //log to console
    console.log('byte rcvd : ' + response.headers['content-length'] + '  byte preamble : ' + response.body.substr(0,70) );

    //emit stats
    ee.emit('customStat', { stat: 'response_bytes', value: cumulativeBytes });

    return next(); // MUST be called for the scenario to continue
  }

