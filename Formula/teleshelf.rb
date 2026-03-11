class Teleshelf < Formula
  include Language::Python::Virtualenv

  desc "Export and archive Telegram channels into a static HTML reader"
  homepage "https://github.com/aprudkin/TeleShelf"
  url "https://github.com/aprudkin/TeleShelf/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "f26baab37e6bb007df34f746997ff124a969a242665a60a958bb9ebc7e805103"
  license "MIT"

  depends_on "go-task"
  depends_on "python@3"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/af/92/b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccff/jinja2-3.1.5.tar.gz"
    sha256 "f26baab37e6bb007df34f746997ff124a969a242665a60a958bb9ebc7e805103"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "f26baab37e6bb007df34f746997ff124a969a242665a60a958bb9ebc7e805103"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources

    # Install project files
    libexec.install "Taskfile.yml"
    libexec.install "scripts"
    libexec.install "requirements.txt"

    # Create wrapper script
    (bin/"teleshelf").write <<~BASH
      #!/bin/bash
      export TELESHELF_HOME="${TELESHELF_HOME:-$HOME/TeleShelf}"
      export TELESHELF_INSTALL_DIR="#{libexec}"
      export PATH="#{libexec}/bin:$PATH"
      mkdir -p "$TELESHELF_HOME/downloads" "$TELESHELF_HOME/reader"
      exec task --taskfile "#{libexec}/Taskfile.yml" --dir "$TELESHELF_HOME" "$@"
    BASH
  end

  def caveats
    <<~EOS
      TeleShelf stores channel data in ~/TeleShelf/ by default.
      Override with: export TELESHELF_HOME=/your/path

      You also need tdl for Telegram export:
        brew install iyear/tap/tdl
        tdl login

      Optional: install Claude Code for AI auto-tagging:
        npm install -g @anthropic-ai/claude-code
    EOS
  end

  test do
    assert_match "add-channel", shell_output("#{bin}/teleshelf --list")
  end
end
