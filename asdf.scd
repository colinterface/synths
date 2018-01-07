s.boot;
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");

(
OSCdef.new(
	\x,
	{
		arg msg, time, addr, port;
		Ndef('x', msg[1]);
	},
	'/tx'
);
)


(
OSCdef.new(
	\z,
	{
		arg msg, time, addr, port;
		// msg[1].postln
		Ndef('z', msg[1]);
	},
	'/tz'
)
)

(
OSCdef.new(
	\rot,
	{
		arg msg, time, addr, port;
		// msg[1].postln
	},
	'/ry'
)
)


(
SynthDef.new(\granular, {
	arg x=0, z=0, rot=0;
	 var trate, dur, rate;
	trate = MouseY.kr(2,200,1);
    dur = 4 / trate;
    rate = Dseq([10, 1, 1, 0.5, 0.5, 0.2, 0.1], inf);
    TGrains.ar(2, Impulse.ar(trate), b, rate, MouseX.kr(0,BufDur.kr(b)), dur, Dseq([-1, 1], inf), 0.1, 2);
}.scope(zoom: 4)).add
)

b.free;
