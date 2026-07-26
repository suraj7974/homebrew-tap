class UnusedCli < Formula
  desc "Find dependencies your code never imports — with evidence, not just names."
  homepage "https://github.com/suraj7974/cliTools"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/suraj7974/cliTools/releases/download/unused-cli-v0.1.1/unused-cli-aarch64-apple-darwin.tar.xz"
      sha256 "c8b2d47f03e4a044a8b84e5d770d54698f82d2f94d34a8d4b22d02095ddbc522"
    end
    if Hardware::CPU.intel?
      url "https://github.com/suraj7974/cliTools/releases/download/unused-cli-v0.1.1/unused-cli-x86_64-apple-darwin.tar.xz"
      sha256 "998c5024e3577e198986c21c3c1581923990008c967f0d43fe872f184ab1a216"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/suraj7974/cliTools/releases/download/unused-cli-v0.1.1/unused-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "ce354be21a237b2530ceeb1cbe14eceaec50a29b9d9e0e12ceecdb1c2804b46e"
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
    bin.install "unused" if OS.mac? && Hardware::CPU.arm?
    bin.install "unused" if OS.mac? && Hardware::CPU.intel?
    bin.install "unused" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
