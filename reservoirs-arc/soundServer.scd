ServerOptions.devices;
s.meter;
s.plotTree;
(
// sets and starts server and builds arrays for ~micBusses, ~micSynths, and ~sines
var numInputs=~numSources, numOutputs=~numSources;

s.quit;
o = Server.default.options;
//o.numOutputBusChannels = 3;
o.numOutputBusChannels;
o.numWireBufs_(1024);
o.sampleRate_(48000);
o.numOutputBusChannels = 4;
o.numInputBusChannels = 12;

o.inDevice_("Scarlett 18i20 USB");
o.outDevice_("Scarlett 18i20 USB");

//o.inDevice_("BlackHole 64ch");

//o.inDevice_("Scarlett 2i2 USB");
//o.inDevice_("Soundflower (2ch)");
//o.outDevice_("External Headphones");

//o.inDevice_("Fireface 802 (23668699)");
//o.outDevice_("Fireface 802 (23668699)");

//o.outDevice_("Soundflower (2ch)");
//o.outDevice_("Scarlett 2i2 USB");
//o.outDevice_("MacBook Pro Speakers");

//ServerOptions.devices;
//Server.default.options.inDevice_("H5"); // stereo input
//Server.default.options.inDevice_("Scarlett 18i20 USB");
//Server.default.options.inDevice_(1);
//Server.default.options.inDevice_("MacBook Pro Microphone"); // mono input
//Server.default.options.outDevice_("External Headphones");
//Server.default.options.outDevice_("USB Audio CODEC");
//Server.default.options.outDevice_(0);
//Server.default.options.outDevice_("Soundflower (2ch)");
//Server.default.options.outDevice_("Scarlett 2i2 USB");


s.waitForBoot( { // boot server
	// ADD SYNTHS TO SERVER
	s.freeAll;
	// Mic Synth for input only
	SynthDef.new( \micIn, {
		arg in=0, inputGain=1.0, out=0;
		var sig;
		sig = SoundIn.ar(in, inputGain);
		out = Out.ar(out, sig);
	}).add;

	// sine bank synth
	SynthDef.new(\sinBank, {
		arg out=0, gate;
		var size=~numSines, env, sig, freqs, amps, phases;
		// accepts any size of freq bank, set by ~numSines

		freqs = Array.fill(size, { 440 } );
		amps = Array.fill(size, { 1/size } );
		phases = Array.fill(size, { arg i; i.mod(2pi) } );
		// amp env
		env = EnvGen.kr(Env.asr( 0.01, 1.0, \release.kr(1.0) ), gate );

		// signal
		sig = DynKlang.ar( `[ \freqs.kr(freqs).lag(0.01), \amps.kr(amps), \phases.kr(phases) ] );
		sig = sig * env;
		Out.ar(out, sig);
	}).add;

	// just for following; not setup to handle arrays (only works for 2 chan right now)
	SynthDef.new(\micFollower1, {
	arg in=0, out=0, amp=1;
	var sig;
	sig = SoundIn.ar(in, amp);
	SendPeakRMS.ar(sig, 20, 3, "/peakMonitor1");
	}).add;

	SynthDef.new(\micFollower2, {
	arg in=1, out=0, amp=1;
	var sig;
	sig = SoundIn.ar(in, amp);
	SendPeakRMS.ar(sig, 20, 3, "/peakMonitor2");
	}).add;

	s.sync;
	// allocate bus and instance of mic synth and sine synth
	~micBusses = Array.fill(numInputs, {Bus.audio(s, 1)});
	~chanOffset = 0; // if not using 0, 1, ...
	~micSynths = Array.fill(numInputs, { arg i; Synth.new(\micIn, [\in, (i + ~chanOffset), \out, ~micBusses[(i+~chanOffset)]])}); // after testing change 0 to i for diff input channels

	/*
	~followers = [
		Synth.new(\micFollower1),
		Synth.new(\micFollower2)
	];
	*/

	~sines = Array.fill(numOutputs, { arg i; Synth.new(\sinBank, [\out, i])});
	~micBusses.do( { arg bus; bus.scope});


	~cwd = PathName.new(thisProcess.nowExecutingPath).parentPath;
	// build arrays for filenames and recorders
	~temps = Array.fill( ~numSources, { arg i; ~cwd ++ "temp" ++ i.asString ++ ".wav"});
	~recs = Array.fill( ~numSources, {

		arg recorder;
		recorder = Recorder(s);
		recorder.recHeaderFormat_('wav');
		recorder.recSampleFormat_("int16");
		recorder;
	});
});
)


s.quit;

s.meter;
s.plotTree;