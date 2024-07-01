# Variables
APP_NAME = claude-engineer
VERSION = 0.1
DIST_DIR = dist
MACOS_EXEC = $(APP_NAME)_macos
LINUX_EXEC = $(APP_NAME)_linux
MACOS_TARBALL = $(APP_NAME)_macos-$(VERSION).tar.gz
LINUX_TARBALL = $(APP_NAME)_linux-$(VERSION).tar.gz
GITHUB_USER = DisantHoridnt
REPO_NAME = cli-engineer
FORMULA_PATH = Formula/$(APP_NAME).rb
CONFIG_FILE = ~/.claude_config.json

# Targets
.PHONY: all build package release formula clean setup

all: build package release formula

# Build the standalone executables
build: build-macos build-linux

build-macos:
	@echo "Building the macOS executable..."
	pyinstaller --onefile --name $(MACOS_EXEC) main.py

build-linux:
	@echo "Building the Linux executable..."
	pyinstaller --onefile --name $(LINUX_EXEC) main.py

# Package the executables into tarballs
package: build
	@echo "Packaging the macOS executable..."
	tar -czvf $(MACOS_TARBALL) -C $(DIST_DIR) $(MACOS_EXEC)
	@echo "Packaging the Linux executable..."
	tar -czvf $(LINUX_TARBALL) -C $(DIST_DIR) $(LINUX_EXEC)

# Upload the releases to GitHub
release: package
	@echo "Creating a new GitHub release for macOS..."
	gh release create v$(VERSION) $(MACOS_TARBALL) --title "v$(VERSION) macOS" --notes "Release version $(VERSION) for macOS"
	@echo "Creating a new GitHub release for Linux..."
	gh release create v$(VERSION) $(LINUX_TARBALL) --title "v$(VERSION) Linux" --notes "Release version $(VERSION) for Linux"

# Update the Homebrew formula
formula: release
	@echo "Updating the Homebrew formula..."
	MACOS_SHA256=$$(shasum -a 256 $(MACOS_TARBALL) | awk '{ print $$1 }'); \
	cat <<- EOF > $(FORMULA_PATH); \
	class $(APP_NAME) < Formula; \
	  desc "Claude Engineer CLI Tool"; \
	  homepage "https://github.com/$(GITHUB_USER)/$(REPO_NAME)"; \
	  url "https://github.com/$(GITHUB_USER)/$(REPO_NAME)/releases/download/v$(VERSION)/$(MACOS_TARBALL)"; \
	  sha256 "$$MACOS_SHA256"; \
	  def install; \
	    bin.install "$(APP_NAME)"; \
	    ohai "Please enter your Anthropic and Tavily API keys"; \
	    system "$(APP_NAME)", "setup"; \
	  end; \
	  test do; \
	    system "$$bin/$(APP_NAME)", "--version"; \
	  end; \
	end; \
	EOF

# Clean the build and dist directories
clean:
	@echo "Cleaning up..."
	rm -rf build $(DIST_DIR) $(MACOS_TARBALL) $(LINUX_TARBALL) $(CONFIG_FILE)

# Setup API keys
setup:
	@echo "Setting up API keys..."
	python -c 'import os; anthropic_key = input("Enter Anthropic API Key: "); tavily_key = input("Enter Tavily API Key: "); with open("$(CONFIG_FILE)", "w") as f: f.write("{\"anthropic_key\": \"" + anthropic_key + "\", \"tavily_key\": \"" + tavily_key + "\"}")'