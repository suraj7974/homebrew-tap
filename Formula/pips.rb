class Pips < Formula
  desc "Ghost-text package suggestions for `pip install` in your shell."
  homepage "https://github.com/suraj7974/cliTools"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/suraj7974/cliTools/releases/download/pips-v0.1.0/pips-aarch64-apple-darwin.tar.xz"
      sha256 "8f90fb0d1a216edd3330cd463b6e573f937dbdfe2fc7d7e7a8e1b24d0225cc6c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/suraj7974/cliTools/releases/download/pips-v0.1.0/pips-x86_64-apple-darwin.tar.xz"
      sha256 "c38a074f8ff144f7379b21755519eabe9e0c300b5574cbdc3b5ee8cd2f2eb910"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/suraj7974/cliTools/releases/download/pips-v0.1.0/pips-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "ddae023e44197387ccd386a1702a2e53374e483f18098148e2a98be33d51f91e"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "pips" if OS.mac? && Hardware::CPU.arm?
    bin.install "pips" if OS.mac? && Hardware::CPU.intel?
    bin.install "pips" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
