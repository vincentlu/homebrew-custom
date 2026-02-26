class Emacs < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  url "https://ftpmirror.gnu.org/gnu/emacs/emacs-30.2.tar.xz"
  mirror "https://ftp.gnu.org/gnu/emacs/emacs-30.2.tar.xz"
  sha256 "b3f36f18a6dd2715713370166257de2fae01f9d38cfe878ced9b1e6ded5befd9"
  license "GPL-3.0-or-later"

  head do
    url "https://github.com/emacs-mirror/emacs.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "gnu-sed" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "texinfo" => :build
  depends_on "gmp"
  depends_on "gnutls"
  depends_on "tree-sitter@0.25"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "jpeg-turbo"
    depends_on "zlib-ng-compat"
  end

  conflicts_with cask: "emacs-app"
  conflicts_with cask: "emacs-app@nightly"
  conflicts_with cask: "emacs-app@pretest"

  def install
    args = %W[
      --disable-acl
      --disable-silent-rules
      --enable-locallisppath=#{HOMEBREW_PREFIX}/share/emacs/site-lisp
      --infodir=#{info}/emacs
      --prefix=#{prefix}
      --with-gnutls
      --without-x
      --with-xml2
      --without-dbus
      --with-modules
      --with-ns
      --without-imagemagick
      --without-selinux
      --with-tree-sitter
    ]

    if build.head?
      ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"
      system "./autogen.sh"
    end

    File.write "lisp/site-load.el", <<~EOS
      (setq exec-path (delete nil
        (mapcar
          (lambda (elt)
            (unless (string-match-p "Homebrew/shims" elt) elt))
          exec-path)))
    EOS

    system "./configure", *args
    system "make"
    system "make", "install"

    prefix.install "nextstep/Emacs.app"

    # A symlink won't work: Emacs uses argv[0] to resolve relative paths
    # like ../Resources/lisp and ../Resources/etc. A symlink from /opt/homebrew/bin
    # makes Emacs look for Resources there instead of inside the .app bundle.
    (bin/"emacs").write <<~EOS
      #!/opt/homebrew/bin/bash
      exec "#{prefix}/Emacs.app/Contents/MacOS/Emacs" "$@"
    EOS

    # ctags unlinking not needed with --with-ns as ctags is not installed to bin/
  end

  service do
    run [opt_bin/"emacs", "--fg-daemon"]
    keep_alive true
  end

  test do
    assert_equal "4", shell_output("#{bin}/emacs --batch --eval=\"(print (+ 2 2))\"").strip
  end
end
