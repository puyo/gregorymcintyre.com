const path = require('path');
const webpack = require('webpack');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

var definePlugin = new webpack.DefinePlugin({
  __DEVELOPMENT__: JSON.stringify(JSON.parse(process.env.BUILD_DEVELOPMENT || false)),
  __PRODUCTION__: JSON.stringify(JSON.parse(process.env.BUILD_PRODUCTION || false))
});

module.exports = {
  mode: process.env.BUILD_DEVELOPMENT ? 'development' : 'production',

  entry: {
    gallery: './source/javascripts/gallery.js',
    styles: './source/stylesheets/gallery.css.sass',
  },

  resolve: {
    modules: [
      path.join(__dirname, "source/javascripts"),
      "node_modules"
    ],
    alias: {
      jquery: "jquery/src/jquery",
      "lightgallery-sass": path.resolve(__dirname, "./node_modules/lightgallery/src/sass/lightgallery.scss"),
      "gallery-sass": path.resolve(__dirname, "./source/stylesheets/gallery.css.sass"),
    },
  },

  output: {
    path: __dirname + '/.tmp/dist',
    filename: 'javascripts/[name].js',
  },

  plugins: [
    // ...
    new webpack.ProvidePlugin({
      $: "jquery",
      jQuery: "jquery",
      "window.jQuery": "jquery",
    }),
  ],

  plugins: [new MiniCssExtractPlugin(), definePlugin],

  module: {
    rules: [
      {
        test: /\.(png|jpe?g|gif|svg)$/i,
        use: [
          {
            loader: 'file-loader',
          },
        ],
      },
      {
        test: /\.(ttf|eot|woff|woff2)$/,
        loader: 'file-loader',
        options: {
          limit: 50000,
          name: 'fonts/[name].[ext]',
        },
      },
      {
        test: /\.(sa|sc|c)ss$/,
        use: [
          {
            loader: MiniCssExtractPlugin.loader,
            options: {
              hmr: process.env.NODE_ENV === 'development',
            },
          },
          'css-loader',
          'postcss-loader',
          'sass-loader',
        ],
      },
      // Load plain-ol' vanilla CSS
      { test: /\.css$/, loader: "style!css" },
    ],
  }
};
