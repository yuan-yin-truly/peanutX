
inference_wrapper = function(data, initial_condition){

  m = rstan::stan_model('shrinkage.stan')
  out = rstan::vb(object = m,
                  init = initial_condition,
                  data = data,
                  seed = 12345,
                  iter = 50000)

  return(out)
}
