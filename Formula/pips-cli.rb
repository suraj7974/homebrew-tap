class PipsCli < Formula
  desc "Ghost-text package suggestions for `pip install` in your shell."
  homepage "https://github.com/suraj7974/cliTools"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/suraj7974/cliTools/releases/download/pips-cli-v0.1.0/pips-cli-aarch64-apple-darwin.tar.xz"
      sha256 "058c899d42207cdf035f2a64053d5f17e9d603ae02fb3895145ab1b87e7fa63f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/suraj7974/cliTools/releases/download/pips-cli-v0.1.0/pips-cli-x86_64-apple-darwin.tar.xz"
      sha256 "0ae26ac61e004268c4d81b6dbbc4439512b15371f3cd1a640cee023cb60cf563"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/suraj7974/cliTools/releases/download/pips-cli-v0.1.0/pips-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "550583dfb1eb0776e728dbdf9be4a2dba56c6b75d7465a0b4387cf6c0e9c5733"
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
