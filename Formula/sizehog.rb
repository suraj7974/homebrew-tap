class Sizehog < Formula
  desc "Find the biggest files under a path."
  homepage "https://github.com/suraj7974/cliTools"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/suraj7974/cliTools/releases/download/sizehog-v0.1.2/sizehog-aarch64-apple-darwin.tar.xz"
      sha256 "f1bb300f427895803aaf0cea7cf944be02f15c2070d8532c3087afe14bd10665"
    end
    if Hardware::CPU.intel?
      url "https://github.com/suraj7974/cliTools/releases/download/sizehog-v0.1.2/sizehog-x86_64-apple-darwin.tar.xz"
      sha256 "3c662b400587eedf9db8f6785634c55c16dd1544aacded5621564f03e2ea5eb7"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/suraj7974/cliTools/releases/download/sizehog-v0.1.2/sizehog-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "bbaf9441d5f505d754d8a02cd89b935a565def257934d3e830f96f595894cc82"
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
    bin.install "sizehog" if OS.mac? && Hardware::CPU.arm?
    bin.install "sizehog" if OS.mac? && Hardware::CPU.intel?
    bin.install "sizehog" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
