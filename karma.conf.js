const webpackConfig = require('./webpack.config.js');

module.exports = function (config) {
    config.set({
        frameworks: ['mocha', 'chai', 'source-map-support'],
        files: ['srcjs/react-tools.js', 'js-tests/js-tests.jsx'],
        preprocessors: {
            'js-tests/*.js': ['webpack'],
            'js-tests/*.jsx': ['webpack'],
            'srcjs/*.js': ['webpack']
        },
        webpack: {
          module: webpackConfig.module,
          externals: {
            /**
             * In tests, react and react-dom are provided internally.
             * The following libraries are not part of the testing environment,
             * but are provided here as external so that webpack builds.
             **/
            'jquery': 'window.jQuery',
            'shiny': 'window.Shiny',
            'htmlwidgets': 'window.HTMLWidgets'
          }
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
