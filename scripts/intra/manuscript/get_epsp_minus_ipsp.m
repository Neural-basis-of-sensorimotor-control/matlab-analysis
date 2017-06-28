function [val, neg_normalization] = get_epsp_minus_ipsp(amplitude)

[nbr_of_epsps, neg_normalization] = get_nbr_of_epsps(amplitude);

val = nbr_of_epsps - get_nbr_of_ipsps(amplitude);

end