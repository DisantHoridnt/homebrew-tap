class claude-engineer < Formula
  desc "Claude Engineer CLI Tool"
  homepage "https://github.com/DisantHoridnt/cli-engineer"
  url "https://github.com/DisantHoridnt/cli-engineer/releases/download/v0.7/claude-engineer_macos-0.7.tar.gz"
  sha256 "2143b310f1a7eab4770779a1d6b3e78cb46a32fb6ebda605de096ef4babb1dd0"
  def install
    bin.install "claude-engineer"
    ohai "Please enter your Anthropic and Tavily API keys"
    system "claude-engineer", "setup"
  end
  test do
    system "/claude-engineer", "--version"
  end
end
