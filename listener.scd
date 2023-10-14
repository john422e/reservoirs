// amp gate for reservoirs analysis engine, with timer to prevent repeat triggers in analysis window

s.boot;
s.reboot;
(

SynthDef.new(\micIn, {
	arg in=0, out=0, amp=1;
	var sig;
	sig = SoundIn.ar(in, amp);
	SendPeakRMS.ar(sig, 20, 3, "/peakMonitor");
	//Out.ar(out, sig);
}).add;
)

~delayState = 0;

(
~mic = Synth.new(\micIn);


~peakResponder = OSCFunc( {
	arg msg;
	var peak, rms, peakThresh, rmsThresh;
	peakThresh = 1.0;
	rmsThresh = 0.003;
	peak = msg[3];
	rms = msg[4];
	if( peak > peakThresh and: {~delayState==0}, {
		"PEAK: %".format(peak).postln;
		~delayState = 1;
		t = Task( {
			2.wait;
			"RESET".postln;
			~delayState = 0;
		});
		t.start;
	});
	//if( rms > rmsThresh, { "RMS: %".format(rms).postln});
	//"peak: %, rms: %".format(msg[3], msg[4]).postln;
}, "/peakMonitor");

)
OSCdef("/peakMonitor").clear;
~peakResponder.remove;
~mic.free;

s.freeAll;