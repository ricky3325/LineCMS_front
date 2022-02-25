module.exports = {
    outputDir: '../public'
    //, devServer: { proxy: { '/api': { target: 'https://10.9.200.16:442', changeOrigin: true, ws: true, pathRewrite: { '^/api':  '/api', } } }
    , devServer: { proxy: { '/api': { target: 'https://train.firdi.org.tw:442', changeOrigin: true, ws: true, pathRewrite: { '^/api':  '/api', } } }
    }
  }