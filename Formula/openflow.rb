class Openflow < Formula
  desc "Open-source Wispr Flow clone — fast, private, voice-to-text for macOS"
  homepage "https://github.com/vishnuhari17/OpenFlow"
  version "0.1.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/vishnuhari17/OpenFlow/releases/download/v0.1.2/openflow-aarch64-apple-darwin.tar.xz"
    sha256 "fa560acf48daec9776f11d68f400f2aa5e95400b76fcc3df6346d6d7f00853c0"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "openflow" if OS.mac? && Hardware::CPU.arm?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
