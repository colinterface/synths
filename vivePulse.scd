s.quit
s.boot

(
SynthDef.new(\pulseTest, {
	arg ampHz=4, fund=40, maxPartial=4, width=0.5;
	var amp1, amp2, freq1, freq2, sig1, sig2;
	amp1 = LFPulse.kr(ampHz, 0, 0.12) * 0.75;
	amp1 = LFPulse.kr(ampHz, 0.5, 0.12) * 0.75;
	freq1 = LFNoise0.kr(4).exprange(fund, fund*maxPartial).round(fund);
	freq2 = LFNoise0.kr(4).exprange(fund, fund*maxPartial).round(fund);
	freq1 = freq1 * LFPulse.kr(8, add:1);
	freq2 = freq2 * LFPulse.kr(6, add:1);
	sig1 = Pulse.ar(freq1, width, amp1);
	// sig2 = Pulse.ar(freq2, width, amp2);
	// sig1 = FreeVerb.ar(sig1, 0.5, 0.5, 0.2);
	// sig2 = FreeVerb.ar(sig2, 0.7, 0.8, 0.25);
	Out.ar(0, sig1);
	// Out.ar(1, sig2);
}).add;
)

p = Synth.new(\pulseTest);
p.set(\maxPartial, 10);
p.set(\fund, 60);
p.set(\width, 0.5);
p.set(\ampHz, 4);

(
OSCdef.new(
	\x,
	{
		arg msg, time, addr, port;
		'x position:'.postln;
		msg[1].postln;
		// p.set(\ampHz, msg[1] * 10);
	},
	'/tx'
);
)


(
OSCdef.new(
	\z,
	{
		arg msg, time, addr, port;
		'z position:'.postln;
		msg[1].postln;
		p.set(\z, msg[1]);
	},
	'/tz'
);
)

(
OSCdef.new(
	\rot,
	{
		arg msg, time, addr, port;
		'y rotation:'.postln;
		msg[1].postln;
		p.set(\rot, msg[1]);
	},
	'/ry'
);
)