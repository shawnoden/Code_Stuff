component output=false {
	public Any function genString(required int a, required int b, required int rangeNumber) output = false {

		local.retval = {"k1":""} ;

		for (var n = 1; n LTE arguments.rangeNumber; n++) {

			if (  n%arguments.a == 0 && n%arguments.b == 0 ) { local.outval = "DivByAB" ; } /// What if b is divisible by a?
			else if ( n%arguments.a == 0 ) { local.outval = "DivByA" ; }
			else if ( n%arguments.b == 0 ) { local.outval = "DivByB" ; }
			else { local.outval = "#n#" ; }

			local.retval["k#n#"] = local.outval;
		}

		return local.retval;
	}

}