s.quit
s.boot

NetAddr.localAddr

b = Buffer.read(s, Platform.resourceDir +/+ "sounds/grainSong.wav");
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/WilhelmScream.L.wav");
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/test.wav");

(
SynthDef.new(\granular, {
	arg x=0.5, z=0.5, rot=0.5;
    var trate, dur, rate, sig;
	trate = (rot * 30).round;
	'trate:'.postln;
	trate.postln;
    dur = z * 4 / trate;
	'dur:'.postln;
	dur.postln;
    rate = Dseq([1, 1, 1, 0.5, 0.5, 0.25], inf);
	sig = TGrains.ar(2, Impulse.ar(trate), b, rate, (x * 200).round, dur, Dseq([-1, 1], inf), 0.1, 3);
	Out.ar(0, sig);
}).add;
)

g = Synth.new(\granular);

g.set(\rot, 1);
g.set(\rot, 0.5);
g.set(\rot, 0.03);

g.set(\x, 103);
g.set(\x, 0.3);
g.set(\x, 0.03);

g.set(\z, 3);
g.set(\z, 0.3);
g.set(\z, 0.03);


(
OSCdef.new(
	\wek,
	{
		arg msg, time, addr, port;
		'a:'.postln;
		msg[1].postln;
		g.set(\rot, msg[1] * 2);
		'b:'.postln;
		msg[2].postln;
		g.set(\x, msg[2] * 10);
		'c:'.postln;
		msg[3].postln;
		g.set(\z, msg[3] * 3);
	},
	'/wek/outputs',
);
)



(
OSCdef.new(
	\x,
	{
		arg msg, time, addr, port;
		'x position:'.postln;
		msg[1].postln;
		g.set(\x, msg[1] * 200 + 200);
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
		g.set(\z, msg[1]);
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
		g.set(\rot, msg[1]);
	},
	'/ry'
);
)