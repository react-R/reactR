const webpackConfig = require('./webpack.config.js');

module.exports = function (config) {
    config.set({
        frameworks: ['mocha', 'chai', 'source-map-support'],
        files: ['inst/www/react-tools/react-tools.js', 'js-tests/js-tests.jsx'],
        preprocessors: {
            'js-tests/*.js': ['webpack'],
            'js-tests/*.jsx': ['webpack']
        },
        webpack: {
          module: webpackConfig.module
        },
        webpackMiddleware: {
            stats: 'errors-only'
        },
        reporters: ['progress'],
        port: 9876,  // karma web server port
        colors: true,
        logLevel: config.LOG_INFO,
        browsers: ['ChromeHeadless'],
        autoWatch: false,
        // singleRun: false, // Karma captures browsers, runs the tests and exits
        concurrency: Infinity
    })
} 
