class ZshAlias < Formula
  desc "Modular zsh alias bundles for git, npm, macOS, SSH, and more"
  homepage "https://github.com/phanvohieunghia/zsh-alias"
  url "https://github.com/phanvohieunghia/zsh-alias/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "f0cab8712c5a1b646b45b55b0a1696f6df06e5773d692fd6aa64bd467dbe8b9d"
  license "MIT"

  def install
    # Install the alias bundles
    (prefix/"zsh-alias").install Dir["zsh-alias/*"]

    # Install the installer script into libexec
    libexec.install "install.zsh"

    # Create a wrapper script in bin
    (bin/"zsh-alias").write <<~EOS
      #!/usr/bin/env zsh
      export ZSH_ALIAS_BUNDLE_DIR="#{opt_prefix}/zsh-alias"
      exec zsh "#{opt_libexec}/install.zsh" "$@"
    EOS
  end

  def caveats
    <<~EOS
      To load zsh-alias bundles, add this to your ~/.zshrc:

        # Load all installed zsh-alias bundles
        if [ -d "$HOME/.config/zsh-alias" ]; then
          for f in "$HOME/.config/zsh-alias"/*.zsh(N); do
            source "$f"
          done
        fi

      Then install bundles interactively:
        zsh-alias

      Or install specific bundles:
        zsh-alias git npm macos

      Or install all bundles:
        zsh-alias --all
    EOS
  end

  test do
    system "#{bin}/zsh-alias", "--list"
  end
end
