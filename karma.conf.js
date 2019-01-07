// TODO: Get source maps for failures working.
module.exports = function (config) {
    config.set({
        frameworks: ['mocha', 'chai'],
        files: ['inst/www/react-tools/react-tools.js', 'js-tests/js-tests.jsx'],
        preprocessors: {
            'js-tests/*.js': ['webpack'],
            'js-tests/*.jsx': ['webpack', 'sourcemap']
        },
        webpack: {
            module: {
                rules: [
                    {
                        test: [/\.js$/, /\.jsx$/],
                        loader: 'babel-loader',
                        options: {
                            presets: ['@babel/preset-env', '@babel/preset-react']
                        }
                    }
                ]
            },
            devtool: 'source-map'
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