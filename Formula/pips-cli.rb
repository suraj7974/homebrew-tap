class PipsCli < Formula
  desc "Ghost-text package suggestions for pip / npm / pnpm / yarn in your shell."
  homepage "https://github.com/suraj7974/cliTools"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/suraj7974/cliTools/releases/download/pips-cli-v0.2.0/pips-cli-aarch64-apple-darwin.tar.xz"
      sha256 "30e2bd63b6e2b837fc34bd1cd1a07cc7dacfe73c4c9a5402d0ea7404dd11a57a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/suraj7974/cliTools/releases/download/pips-cli-v0.2.0/pips-cli-x86_64-apple-darwin.tar.xz"
      sha256 "3af2e254319c832f0b4273482e9be7fc12932bda8b486e872e28003a0ffcd9c8"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/suraj7974/cliTools/releases/download/pips-cli-v0.2.0/pips-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "4201efeb892bb93ea763b79ed8ab7aa54fb6e104fd610393cbdf498a84a813cf"
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
