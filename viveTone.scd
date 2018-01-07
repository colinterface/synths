s.quit
s.boot

(
SynthDef.new(\tone, {
	arg freq=40, nharm=12, detune=0.2, gate=0,	 pan=0, amp=1, out=0;
	var sig, env;
	env = EnvGen.kr(Env.adsr(0.05, 0.1, 0.5, 3), gate);
	sig = Blip.ar(freq * LFNoise1.kr(0.2!16).bipolar(detune.neg, detune).midiratio, nharm);
	sig = sig * LFNoise1.kr(0.1!16).exprange(0.1, 1);
	sig = Splay.ar(sig);
	sig = Balance2.ar(sig[0], sig[1], pan);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

p = Synth.new(\tone);
p.set(\freq, 40);
p.set(\nharm, 20);
p.set(\detune, 1);
=p.set(\gate, 1);

(
OSCdef.new(
	\x,
	{
		arg msg, time, addr, port;
		'x position:'.postln;
		msg[1].postln;
		p.set(\freq, msg[1] * 80 + 30);
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
		p.set(\detune, msg[1]);
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
		p.set(\nharm, (msg[1] * 30).round);
	},
	'/ry'
);
)