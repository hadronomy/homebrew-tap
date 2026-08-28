class AgentProgress < Formula
  desc "Live progress for long-running agent tasks, in the macOS menu bar"
  homepage "https://github.com/hadronomy/skills"
  url "https://github.com/hadronomy/skills/archive/refs/tags/agent-progress-v0.1.0.tar.gz"
  sha256 "3cb28fa89192c57c01673face02feceaff771b26a8d2fffddfadc7125358ca05"
  license "MIT"
  head "https://github.com/hadronomy/skills.git", branch: "main"

  # The source repo holds several tools, so each carries its own tag prefix.
  # Without this, `brew bump` and the autobump workflow cannot tell which tags
  # belong to this formula.
  livecheck do
    url :stable
    strategy :git
    regex(/^agent-progress[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  # Built from source on the installing machine, which is what keeps this
  # free of code-signing: a locally compiled binary is never quarantined, so
  # Gatekeeper has nothing to block and notarization is not needed.
  depends_on xcode: :build
  depends_on macos: :ventura

  def install
    cd "skills/in-progress/agent-progress" do
      app = buildpath/"AgentProgress.app"
      (app/"Contents/MacOS").mkpath

      system "swiftc", "-O", "-o", app/"Contents/MacOS/AgentProgress",
             "menubar/Shaders.swift", "menubar/AgentProgress.swift", "menubar/Entry.swift",
             "-framework", "AppKit", "-framework", "MetalKit", "-framework", "SwiftUI"

      # NSStatusItem needs a real bundle. A bare executable runs but never
      # appears in the menu bar, so the Info.plist is load-bearing, not decoration.
      (app/"Contents/Info.plist").write <<~PLIST
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0"><dict>
          <key>CFBundleName</key><string>AgentProgress</string>
          <key>CFBundleIdentifier</key><string>dev.hadronomy.agent-progress</string>
          <key>CFBundleExecutable</key><string>AgentProgress</string>
          <key>CFBundlePackageType</key><string>APPL</string>
          <key>CFBundleShortVersionString</key><string>#{version}</string>
          <key>LSUIElement</key><true/>
          <key>LSMinimumSystemVersion</key><string>13.0</string>
        </dict></plist>
      PLIST

      prefix.install app
      bin.install "scripts/agent-progress"
    end
  end

  service do
    run opt_prefix/"AgentProgress.app/Contents/MacOS/AgentProgress"
    keep_alive crashed: true
    log_path var/"log/agent-progress.log"
    error_log_path var/"log/agent-progress.log"
  end

  test do
    assert_match "usage: agent-progress", shell_output("#{bin}/agent-progress --help")
    # `list` reads the state directory and exits, so it is safe here. `watch`
    # loops forever by design and must never appear in a test.
    system bin/"agent-progress", "list"
    assert_predicate prefix/"AgentProgress.app/Contents/MacOS/AgentProgress", :executable?
  end
end
