(
// define ~numSources and get durations from form_functions.py

var p, l, cwd, pyFile, numSections=200, duration=10, power=1.0;  // ADJUST VARS HERE FOR FORM
//var p, l, cwd, pyFile, numSections=10, duration=1, power=0.6; // for testing

cwd = PathName.new(thisProcess.nowExecutingPath).parentPath;
pyFile = cwd ++ "form_functions.py";
p = Pipe.argv(["python3", pyFile, numSections.asString, duration.asString, power.asString], "r");
~sections = p.getLine;
p.close;

~sections = ~sections.interpret;

// manually run form_functions.py for numSections values greater than 170 (pipe issue?)
/*
~sections = [0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.04, 0.04];
*/
//  python3 form_function.py 50 2.5 1.5
//  python3 form_functions.py 50 2.5 0.9

//~sections = [0.01, 0.01, 0.02, 0.02, 0.02, 0.02, 0.03, 0.03, 0.03, 0.03, 0.04, 0.03, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.05, 0.04, 0.05, 0.05, 0.05, 0.05, 0.05, 0.06, 0.05, 0.06, 0.05, 0.06, 0.06, 0.06, 0.06, 0.06, 0.06, 0.07, 0.06, 0.07, 0.06, 0.07, 0.07, 0.06, 0.07, 0.07, 0.07, 0.08, 0.07, 0.07, 0.08, 0.07, 0.07, 0.07, 0.06, 0.06, 0.05, 0.06, 0.06, 0.05, 0.05, 0.06, 0.05, 0.05, 0.05, 0.06, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.04, 0.05, 0.05, 0.05, 0.05, 0.05, 0.04, 0.05, 0.05, 0.05, 0.04, 0.05, 0.05, 0.04, 0.05, 0.05, 0.04, 0.05, 0.05, 0.04, 0.05, 0.04, 0.05, 0.04, 0.05, 0.04, 0.05, 0.04, 0.05];


// duration needs to be 1/2 of whatever duration you want (loop runs twice for each section), so 1/4 if combining two outputs
// python3 form_functions.py 3.75 1.5
// python3 form_functions.py 3.75 0.9

~sections = [0.01, 0.01, 0.01, 0.02, 0.01, 0.02, 0.03, 0.02, 0.03, 0.02, 0.03, 0.03, 0.03, 0.03, 0.04, 0.03, 0.03, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.05, 0.04, 0.05, 0.04, 0.05, 0.05, 0.05, 0.04, 0.05, 0.06, 0.05, 0.05, 0.05, 0.06, 0.05, 0.06, 0.05, 0.06, 0.06, 0.05, 0.06, 0.06, 0.06, 0.06, 0.06, 0.06, 0.06, 0.07, 0.06, 0.06, 0.07, 0.06, 0.07, 0.07, 0.06, 0.07, 0.07, 0.07, 0.07, 0.07, 0.07, 0.07, 0.07, 0.07, 0.07, 0.07, 0.08, 0.07, 0.08, 0.07, 0.08, 0.06, 0.07, 0.06, 0.06, 0.06, 0.05, 0.06, 0.06, 0.05, 0.06, 0.05, 0.05, 0.06, 0.05, 0.05, 0.06, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.06, 0.05, 0.05, 0.04, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.04, 0.05, 0.05, 0.05, 0.05, 0.04, 0.05, 0.05, 0.05, 0.04, 0.05, 0.05, 0.04, 0.05, 0.05, 0.04, 0.05, 0.05, 0.04, 0.05, 0.05, 0.04, 0.05, 0.04, 0.05, 0.05, 0.04, 0.05, 0.04, 0.05, 0.04, 0.05, 0.04, 0.05, 0.04, 0.05, 0.04, 0.05];


//~sections = [0.01, 0.02, 0.03, 0.03, 0.04, 0.04, 0.04, 0.05, 0.05, 0.06, 0.05, 0.06, 0.06, 0.06, 0.07, 0.07, 0.07, 0.07, 0.08, 0.07, 0.08, 0.08, 0.08, 0.09, 0.08, 0.09, 0.09, 0.09, 0.09, 0.1, 0.09, 0.1, 0.1, 0.1, 0.1, 0.1, 0.11, 0.1, 0.11, 0.11, 0.11, 0.11, 0.12, 0.11, 0.12, 0.11, 0.12, 0.12, 0.12, 0.12, 0.13, 0.12, 0.13, 0.12, 0.13, 0.13, 0.13, 0.13, 0.13, 0.14, 0.13, 0.14, 0.13, 0.14, 0.14, 0.14, 0.14, 0.14, 0.15, 0.14, 0.15, 0.14, 0.15, 0.15, 0.15, 0.15, 0.14, 0.12, 0.13, 0.12, 0.11, 0.12, 0.11, 0.11, 0.11, 0.11, 0.11, 0.11, 0.11, 0.1, 0.11, 0.1, 0.11, 0.1, 0.1, 0.11, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.09, 0.1, 0.1, 0.1, 0.09, 0.1, 0.1, 0.09, 0.1, 0.1, 0.09, 0.1, 0.09, 0.1, 0.09, 0.09, 0.1, 0.09, 0.1, 0.09, 0.09, 0.1, 0.09, 0.09, 0.1, 0.09, 0.09, 0.09, 0.1, 0.09, 0.09, 0.09, 0.09, 0.09, 0.09, 0.1, 0.09, 0.09, 0.09, 0.09, 0.09, 0.09, 0.09, 0.09];


//~sections.size;

/*
johneagle@eagle2018 reservoirs % python3 form_functions.py 25 2.5 1.9
[0.01, 0.01, 0.02, 0.04, 0.04, 0.05, 0.05, 0.07, 0.07, 0.08, 0.09, 0.09, 0.1, 0.11, 0.12, 0.12, 0.13, 0.14, 0.14, 0.16, 0.16, 0.16, 0.17, 0.18, 0.19]
johneagle@eagle2018 reservoirs % python3 form_functions.py 25 2.5 0.8
[0.19, 0.14, 0.13, 0.12, 0.11, 0.11, 0.1, 0.1, 0.1, 0.1, 0.1, 0.09, 0.09, 0.09, 0.09, 0.09, 0.09, 0.08, 0.09, 0.08, 0.08, 0.09, 0.08, 0.08, 0.08]
*/
/*
~sections = [0.01, 0.01, 0.02, 0.04, 0.04, 0.05, 0.05, 0.07, 0.07, 0.08, 0.09, 0.09, 0.1, 0.11, 0.12, 0.12, 0.13, 0.14, 0.14, 0.16, 0.16, 0.16, 0.17, 0.18, 0.19, 0.19, 0.14, 0.13, 0.12, 0.11, 0.11, 0.1, 0.1, 0.1, 0.1, 0.1, 0.09, 0.09, 0.09, 0.09, 0.09, 0.09, 0.08, 0.09, 0.08, 0.08, 0.09, 0.08, 0.08, 0.08];
*/

~fills = Array.fill(~sections.size, { arg i; (i+1)/~sections.size});
~fills = ~fills.normalize(0.999, 1.0);

~numSources = 2; // 3 or 6 (2 each?)
~numSines = 4;
~currentData = Array.fill(~numSources, {
	[
		Array.fill(~numSines, { 1.0/~numSines }),
		Array.fill(~numSines, { rrand(100.0, 200.0)})
	]
});


["SECTIONS:", ~sections].postln;
["FILLS:", ~fills].postln;
["NUM MIC SOURCES:", ~numSources].postln;


)

(
l = 0;
~sections.do( {
	arg dur, i;
	var sec;
	sec = dur * 60;
	l = l + (sec*2);
});
~seconds = l;
~minutes = ~seconds/60;
)

~seconds;
~minutes;