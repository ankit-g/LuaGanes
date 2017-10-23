local deftable = {}
deftable.var = 0
deftable.get_var = function () return deftable.var end
deftable.set_var = function (var) deftable.var = var end
return deftable
