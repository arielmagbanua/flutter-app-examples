module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
  },
  extends: [
    'eslint:recommended',
    'google',
  ],
  rules: {
    'quotes': ['error', 'single'],
    'import/no-unresolved': 0,
    'object-curly-spacing': [1, 'always'],
    'indent': ['error', 2],
  },
};
