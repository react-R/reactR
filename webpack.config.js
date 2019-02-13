var path = require('path');

module.exports = {
    mode: 'development',
    entry: path.join(__dirname, 'srcjs', 'react-tools.js'),
    output: {
        path: path.join(__dirname, 'inst', 'www', 'react-tools'),
        filename: 'react-tools.js'
    },
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
    externals: {
        'react': 'window.React',
        'react-dom': 'window.ReactDOM',
        'jquery': 'window.jQuery',
        'shiny': 'window.Shiny'
    },
    stats: {
        colors: true
    },
    devtool: 'source-map'
};
