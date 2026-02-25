function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'cert';
  }

  var apiPetStore;

  if (env == 'cert') {
    apiPetStore = 'https://petstore.swagger.io/v2'
  }

  var config = {
    env: env,
    apiPetStore: apiPetStore
  }
  return config;
}
