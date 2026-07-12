class Upwait < Formula
  desc "Block until a port or URL is up — the missing glue for startup scripts."
  homepage "https://github.com/suraj7974/cliTools"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/suraj7974/cliTools/releases/download/upwait-v0.1.0/upwait-aarch64-apple-darwin.tar.xz"
      sha256 "0fb8ddead70c356be2cff850eb5b685f18d622d8883bebdbab0af2f15534f1eb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/suraj7974/cliTools/releases/download/upwait-v0.1.0/upwait-x86_64-apple-darwin.tar.xz"
      sha256 "60e5c7c1cbab80284659fb7953a4d3f99679e182f7732ac3e38fb471b4d72fa5"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/suraj7974/cliTools/releases/download/upwait-v0.1.0/upwait-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "680be676b04732bfe09dfdb2ed2ad01a002093f7ba6cb3068f92a91482095cc4"
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
    bin.install "upwait" if OS.mac? && Hardware::CPU.arm?
    bin.install "upwait" if OS.mac? && Hardware::CPU.intel?
    bin.install "upwait" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
