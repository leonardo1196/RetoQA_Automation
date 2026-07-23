function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }

  if (env == 'dev') {
    urlhost = 'https://serverest.dev'
  } else if (env == 'qa') {
    urlhost = 'https://serverest.dev'
  }

  var config = {
    env: env,
    urlhost: urlhost
  }
  return config;
}