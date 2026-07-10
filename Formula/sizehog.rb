class Sizehog < Formula
  desc "Find the biggest files under a path."
  homepage "https://github.com/suraj7974/cliTools"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/suraj7974/cliTools/releases/download/sizehog-v0.1.1/sizehog-aarch64-apple-darwin.tar.xz"
      sha256 "5fe574d87a2a94cc442a49c1465c0ec03002134390e9fbc728aa063ceb355a0f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/suraj7974/cliTools/releases/download/sizehog-v0.1.1/sizehog-x86_64-apple-darwin.tar.xz"
      sha256 "b4c80faa33ca52ca22041c8c8590736154daa2d51b8192cc416b3b597d786cd2"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/suraj7974/cliTools/releases/download/sizehog-v0.1.1/sizehog-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "d21d3249a76040fa3b5578f43e097118765889f1179cda6622f53e5ad56c8ad8"
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
