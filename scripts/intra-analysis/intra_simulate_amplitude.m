function amplitude_height = ...
  intra_simulate_amplitude(n_excitatory, v_excitatory, p_recruitment)

amplitude_height = sum(rand(n_excitatory, 1) < p_recruitment) * v_excitatory;

amplitude_height = amplitude_height + .4*(rand-.5)*v_excitatory;

end