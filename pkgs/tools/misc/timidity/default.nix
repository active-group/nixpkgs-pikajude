{ stdenv, fetchurl, alsaLib, libjack2, ncurses, pkgconfig }:

stdenv.mkDerivation {
  name = "timidity-2.15.0";

  src = fetchurl {
    url = mirror://sourceforge/timidity/TiMidity++-2.15.0.tar.bz2;
    sha256 = "1xf8n6dqzvi6nr2asags12ijbj1lwk1hgl3s27vm2szib8ww07qn";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ alsaLib libjack2 ncurses ];

  configureFlags = [ "--enable-audio=oss,alsa,jack" "--enable-alsaseq" "--with-default-output=alsa" "--enable-ncurses" ];

  NIX_LDFLAGS = "-ljack -L${libjack2}/lib";

  instruments = fetchurl {
    url = http://www.csee.umbc.edu/pub/midia/instruments.tar.gz;
    sha256 = "0lsh9l8l5h46z0y8ybsjd4pf6c22n33jsjvapfv3rjlfnasnqw67";
  };

  # the instruments could be compressed (?)
  postInstall = ''
    mkdir -p $out/share/timidity/;
    cp ${./timidity.cfg} $out/share/timidity/timidity.cfg
    tar --strip-components=1 -xf $instruments -C $out/share/timidity/
  '';

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/projects/timidity/;
    license = licenses.gpl2;
    description = "A software MIDI renderer";
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.linux;
  };
}
