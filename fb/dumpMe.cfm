<form action="dumpMe.cfm" method="post">
	Value A: <input name="valA" id="valA" type="number" min="0" value=""> <br>
	Value B: <input name="valB" id="valB" type="number" min="0" value=""> <br>
	Iterations: <input name="iter" id="iter" type="number" min="0" value=""> <br>
	<input name="sub" id="sub" type="submit">
</form>

<cfif structKeyExists(form, "sub")>
	<!--- VALIDATION --->
	<cfset a = form.valA>
	<cfset b = form.valB>
	<cfset rangeNum = form.iter>
	OUTPUT: <cfoutput>(a=#a#,b=#b#,iterations=#rangeNum#)</cfoutput><br><br>
	<cfset FB = new fb()>
	<cfset outval = FB.genString(a,b,rangeNum)>

	<cfloop from="1" to="#rangeNum#" index="i">
		<cfoutput><cfif i neq outval["k#i#"]>#i# = </cfif> #outval["k#i#"]#</cfoutput> <br>
	</cfloop>
</cfif>

<!---
<cfscript>
FB = new fb() ;

a = 2 ;
b = 3 ;
rangeNum = 1000 ;

outval = FB.genString(a,b,rangeNum);

for (i = 1; i LTE rangeNum; i++) {
	WriteOutput(i & " : " & outval["k#i#"] & "<br>") ;
}

</cfscript>
--->