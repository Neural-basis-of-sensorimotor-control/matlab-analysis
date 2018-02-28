function amplitude_height = ...
  intra_simulate_amplitude(n_excitatory, v_excitatory, p_recruitment)

nbr_of_evoked_epsps = sum(rand(n_excitatory, 1) < p_recruitment);

amplitude_height = (nbr_of_evoked_epsps + ...
  sum(.5*randn(nbr_of_evoked_epsps, 1))) * v_excitatory;

end