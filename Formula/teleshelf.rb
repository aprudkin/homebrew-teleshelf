class Teleshelf < Formula
  desc "Telegram channel archive & reader — Go server with Svelte SPA"
  homepage "https://github.com/aprudkin/TeleShelf"
  url "https://github.com/aprudkin/TeleShelf/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "e15cf44b6a6ddd162b945560a0fe906b034bad195cf1d4882bad24bb16c1d3c2"
  license "MIT"

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "ci", "--prefix", "frontend"
    system "npm", "run", "build", "--prefix", "frontend"
    system "go", "build", "-o", bin/"teleshelf", "./cmd/teleshelf"
  end

  def caveats
    <<~EOS
      TeleShelf stores channel data in ~/TeleShelf/ by default.
      Override with: export TELESHELF_HOME=/your/path

      Start the server:
        teleshelf serve

      You also need tdl for Telegram export:
        brew install iyear/tap/tdl
        tdl login

      Optional: install Claude Code for AI auto-tagging:
        npm install -g @anthropic-ai/claude-code
    EOS
  end

  test do
    assert_match "teleshelf", shell_output("#{bin}/teleshelf --help")
  end
end
