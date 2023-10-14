/*
a template for live intonation pieces.
runs with python server analyzeSample.py with Allen Downey's thinkdsp modules.
it's essentially just a pitch tracker for now without further spectral processing.
--john eagle, august 2022

TO RUN: add code blocks 1-4, then run analyzeSample.py from terminal (5), serverMaster.ck from terminal on each pi (6), then run code block 7
*/

// 1. run setup.scd

// 2. run functions.scd

// 3. run soundServer.scd ( builds arrays for ~micBusses, ~micSynths, and ~sines )

// 4. run oscDefs.scd (builds ~localHost )

// 5. START PYTHON SERVER IN TERMINAL reservoirs_analyzeSample.py

// 8. START PROGRAM

(
// MAIN
var r3, record3state, cycleRemainder, totalFreqs=~numSines;

// ----------------------------------------------------------------------------
record3state = False; // set to "True" to record performance



// DOCUMENTATION
r3 = Recorder(s);
r3.recHeaderFormat_('wav');
r3.recSampleFormat_("int16");


// for display
t = TempoClock.new();

// MAIN LOOP, DETERMINED BY totalCycles
x = Task{

	// START DOCUMENTATION RECORDER
	if( record3state == True, r3.record(~cwd ++ Date.getDate.stamp ++ "performance.wav", s, 2), "RECORDER 3 NOT RECORDING".postln);

	~sections.do{
		arg dur, i;

		"TOP".postln;
		[dur, i].postln;

		2.do ( // alternate going between the 2 channels
			{
				arg chan; // 0 or 1
				var nextSection, freqs, fillPct, attack, sus, release, cycleDur, minutes, seconds;

				cycleDur = dur * 60;
				nextSection = t.beats + cycleDur;

				format("LENGTH OF SECTION: % seconds", cycleDur).postln;



				if( ~delayState[chan] == 0, { // ~delayState is set in oscDefs.scd; only execute if recording not being run from there
					// 1. START RECORDING
					~recs[chan].record(~temps[chan], ~micBusses[chan], numChannels: 1);

					// record for ~sampleDur seconds
					1.do{
						format("RECORDING, TIME:\t\t\t\t % minutes, % seconds", (t.beats/60).asInteger, (t.beats%60).asInteger).postln;
						~sampleDur.wait;
					};

					// 2. STOP RECORDING
					~recs[chan].stopRecording;

					1.do{
						format("STOPPED RECORDING, TIME:\t\t % minutes, % seconds", (t.beats/60).asInteger, (t.beats%60).asInteger).postln;
						~recBufTime.wait;
					};

					// 3. PING PYTHON PROGRAM FOR FREQS
					~localHost.sendMsg('/ping', chan);
					~pingBufTime.do{
						//format("GETTING SAMPLE FREQS, TIME:\t\t % minutes, % seconds", (t.beats/60).asInteger, (t.beats%60).asInteger).postln;
						1.wait;
					}; // is this necessary?

					// 4. UPDATE LOCAL SYNTHS

					// calculate remaining time left in cycle
					cycleRemainder = cycleDur - ~sampleDur - ~recBufTime - ~pingBufTime;

					// determine envelope based on ~fills value (determined at top), value 0.5 - 1.0
					fillPct = ~fills[i];

					//format( "sus %, release %, cycleDur %", sus, release, cycleDur).postln;

					~sines[chan].set(\amps, ~currentData[chan][0]);
					~sines[chan].set(\freqs, ~currentData[chan][1]);
					~sines[chan].set(\gate, 1);
				},
				{
					"BYPASSING BECAUSE IT'S BEING RUN ELSEWHERE".postln;
					~sampleDur.wait;
					~recBufTime.wait;
					~pingBufTime.wait;
				}
				);

				// at this point, ~sampleDur (2) + ~recBufTime (1) + ~pingBufTime (1) seconds have passed








				cycleRemainder.do{ format("TUNING TIME, TIME:\t %:% , NEXT CHANGE: %:%", (t.beats/60).asInteger, (t.beats%60).asInteger, (nextSection/60).asInteger, (nextSection%60).asInteger).postln; 1.wait};
		});

	};

	// shutdown python server when finished
	~localHost.sendMsg('/shutdown');

	// kill synth with fade out
	~sines.do( {
		arg synth;
		synth.set(\release, 30);
		synth.set(\gate, 0);
	});

	// stop recording
	// but wait 60 seconds first
	60.do({ arg i; format("COUNT DOWN: %", (60-i)).postln; 1.wait;});
	if( record3state == True, r3.stopRecording, "RECORDER 3 WAS NOT RECORDING".postln);


}.start;
)




(
// USE THIS FOR STOPPING
x.stop;
~sines.do{
	arg synth;
	synth.set(\gate,  0);
}
)



~localHost.sendMsg('/shutdown');
~localHost.sendMsg('/ping', 1);





~currentData[0][0];
~currentData[0][1];
~currentData[1][1];
~currentData[0][0].size;

s.quit;


s.scope;

s.freqscope;

~localHost;