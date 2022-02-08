const path    = require("path")
const webpack = require("webpack")

module.exports = {
  mode: "production",
  devtool: "source-map",
  output: {
    filename: "[name].js",
    sourceMapFilename: "[name].js.map",
    path: path.resolve(__dirname, '..', '..', 'app/assets/builds'),
  },
  entry: {
    // add your css or sass entries
    application: [
      './app/javascript/application.js'
    ]
  },
  module: {
    rules: [
      {
        test: /\.(png|jpe?g|gif|eot|woff2|woff|ttf|svg)$/i,
        use: 'file-loader',
      },
      {
        test: /\.erb$/,
        enforce: 'pre',
        exclude: /node_modules/,
        use: [{
          loader: 'rails-erb-loader',
          options: {
            runner: (/^win/.test(process.platform) ? 'ruby ' : '') + 'bin/rails runner'
          }
        }]
      },
      {
        test: /\.coffee(\.erb)?$/,
        use: [{
          loader: 'coffee-loader'
        }]
      }

    ],
  },
  resolve: {
    // Add additional file types
    extensions: ['.js', '.jsx', '.coffee.erb', '.erb'],
  },
  plugins: [
    new webpack.optimize.LimitChunkCountPlugin({
      maxChunks: 1
    }),
  ]
};