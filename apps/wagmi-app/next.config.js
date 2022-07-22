/* eslint-disable import/no-extraneous-dependencies */
const withBundleAnalyzer = require('@next/bundle-analyzer')({
  enabled: process.env.ANALYZE === 'true',
});

module.exports = withBundleAnalyzer({
  eslint: {
    dirs: ['.'],
  },
  ignoreBuildErrors: true,
  poweredByHeader: false,
  trailingSlash: true,
  // basePath: '',
  basePath: '/svg-render-evm',
  assetPrefix: '/svg-render-evm/',
  reactStrictMode: true,
});
