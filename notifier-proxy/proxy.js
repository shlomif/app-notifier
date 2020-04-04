"use strict";

// See:
// https://github.com/http-party/node-http-proxy
//
// Forward requests from localhost to "nuc" box
const http = require("http"),
    httpProxy = require("http-proxy");
//
// Create your proxy server and set the target in the options.
//
httpProxy
    .createProxyServer({ target: "http://192.168.1.192:6300/" })
    .listen(6300);
