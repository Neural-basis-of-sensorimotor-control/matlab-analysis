function test_sc_vpd()

spiketimes_1 = [];
spiketimes_2 = [];
cost         = 1;

assert(assert_test(sc_vpd(spiketimes_1, spiketimes_2, cost), 0));

spiketimes_1  = rand(3,1);
spiketimes_2  = [];
cost          = 1;

assert(assert_test(sc_vpd(spiketimes_1, spiketimes_2, cost), 3));

spiketimes_1 = rand(1, 3);
spiketimes_2 = [];
cost         = 1;

assert(assert_test(sc_vpd(spiketimes_1, spiketimes_2, cost), 3));

spiketimes_1 = rand(3,1);
spiketimes_2 = [];
cost         = 1;

assert(assert_test(sc_vpd(spiketimes_1, spiketimes_2, cost), 3));

spiketimes_1 = [1 2 3];
spiketimes_2 = 1;
cost         = 2.2;

assert(assert_test(sc_vpd(spiketimes_1, spiketimes_2, cost), 2));

spiketimes_1 = [1.1 2 3.1];
spiketimes_2 = [3 2.2];
cost         = 2.2;

correct_value        = (.2 + .1)*cost + 1;

assert(assert_test(sc_vpd(spiketimes_1, spiketimes_2, cost), correct_value));

spiketimes_1 = [1.1 2 3.1];
spiketimes_2 = [3.1 2.2 1];
cost         = 2.2;

correct_value        = (.2 + .1 + 0) * cost;

assert(assert_test(sc_vpd(spiketimes_1, spiketimes_2, cost), correct_value));

end

function pass = assert_test(retval, correctval)

tol  = 10*eps;
pass = abs(retval - correctval) < tol;

end