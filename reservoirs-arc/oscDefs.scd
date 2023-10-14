
(
/*PORTS:
to/from local host: 9998/9999
to pis: 10000 (on/off), 10001 (control messages: /freq, /gain, /distance)
*/

OSCdef.freeAll;

// set up local host
~localHost = ~localHost.free;
~localHost = ~makeHost.(port: 9998);

// ----------------------------------------------------------------------------
//OSCFunc.trace(false);
OSCdef.new(
	\recvFreqs,
	// function to be evaluated upon receiving qualifying OSC message
	{
		arg msg, time, addr, port; // these are the messages passed on
		var chan, data, numLists, cleaned, amps, freqs, rcvLists;
		//[msg, time, addr, port].postln; // action to be executed
		msg.removeAt(0); // get rid of tag beginning
		//["RCVD:", msg].postln;

		//msg.postln;

		chan = msg[0];

		msg.removeAt(0);

		//msg.postln;



		// clean list of strings
		cleaned = msg.select( { arg i; i.isNumber }); // makes one long list
		//"CLEANED".postln;
		//cleaned.postln;
		//cleaned.size.postln;

		amps = Array.new(~numSines);
		freqs = Array.new(~numSines);
		//format("NUM SINES: %", ~numSines).postln;
		cleaned.do( {
			// split out amps and freqs into separate lists
			arg val, i;
			if( i % 2 == 0, { amps.add(val) }, { freqs.add(val) });
		});
		amps = amps.normalizeSum();
		//["SUMMED", amps.sum].postln;

		//format("NUM SINES: %", ~numSines).postln;
		//format("NUM FREQS: %", freqs.size).postln;

		// add it to the master list
		//~currentData[i] = [amps, freqs];
		//["PARSED", i, amps, freqs].postln;

		~currentData[chan] = [amps, freqs];
		//format("UPDATED CHAN % : % %", chan, amps, freqs).postln;


	},
	'/freqs',
	recvPort: 9999
);

// NEW 4/6/23
/*

~delayState = ~numSources.collect( { arg i; 0; } ); // initialize list to 0

// right now this is manual for 2 peak responders (doesn't work for other numbers of inputs, which i would need to build an array structure for
~peakResponder1 = OSCFunc( {
	arg msg;
	var chan=0, peak, rms;

	peak = msg[3];
	rms = msg[4];

	//"RUNNING".postln;

	if( peak > ~peakThresh and: {~delayState[chan]==0}, {
		"1 PEAK PEAK PEAK PEAK PEAK".postln;
		"1 PEAK PEAK PEAK PEAK PEAK".postln;
		"PEAK: %".format(peak).postln;
		~delayState[chan] = 1; // turn delay on
		~delayState.postln;

		// fork this shiii
		f = {

			// 1. START RECORDING
			~recs[chan].record(~temps[chan], ~micBusses[chan], numChannels: 1);

			// record for ~sampleDur seconds
			1.do{~sampleDur.wait};

			// 2. STOP RECORDING
			~recs[chan].stopRecording;

			1.do{~recBufTime.wait};

			// 3. PING PYTHON PROGRAM FOR FREQS
			~localHost.sendMsg('/ping', chan);
			~pingBufTime.do{1.wait}; // is this necessary?

			// 4. UPDATE LOCAL SYNTHS

			// determine envelope based on ~fills value (determined at top), value 0.5 - 1.0
			~sines[chan].set(\amps, ~currentData[chan][0]);
			~sines[chan].set(\freqs, ~currentData[chan][1]);
			~sines[chan].set(\gate, 1);

			"RESET".postln;
			~delayState[chan] = 0; // reset to 0
		}.fork;
	});//, {"PEAK NOT LOUD ENOUGH".postln});

}, "/peakMonitor1");

~peakResponder2 = OSCFunc( {
	arg msg;
	var chan=1, peak, rms;

	peak = msg[3];
	rms = msg[4];

	if( peak > ~peakThresh and: {~delayState[chan]==0}, {
		"2 PEAK PEAK PEAK PEAK PEAK".postln;
		"2 PEAK PEAK PEAK PEAK PEAK".postln;
		"PEAK: %".format(peak).postln;
		~delayState[chan] = 1; // turn delay on

		// fork this shiii
		f = {

			// 1. START RECORDING
			~recs[chan].record(~temps[chan], ~micBusses[chan], numChannels: 1);

			// record for ~sampleDur seconds
			1.do{~sampleDur.wait};

			// 2. STOP RECORDING
			~recs[chan].stopRecording;

			1.do{~recBufTime.wait};

			// 3. PING PYTHON PROGRAM FOR FREQS
			~localHost.sendMsg('/ping', chan);
			~pingBufTime.do{1.wait}; // is this necessary?

			// 4. UPDATE LOCAL SYNTHS

			// determine envelope based on ~fills value (determined at top), value 0.5 - 1.0
			~sines[chan].set(\amps, ~currentData[chan][0]);
			~sines[chan].set(\freqs, ~currentData[chan][1]);
			~sines[chan].set(\gate, 1);

			"RESET".postln;
			~delayState[chan] = 0; // reset to 0
		}.fork;
	});

}, "/peakMonitor2");
*/



)