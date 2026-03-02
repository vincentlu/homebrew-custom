class AlloyAnalyzer < Formula
  desc "Open-source language and analyzer for software modeling"
  homepage "https://alloytools.org"
  url "https://github.com/AlloyTools/org.alloytools.alloy/archive/refs/tags/v6.2.0.tar.gz"
  sha256 "59ef434a54a0f8ab82fdc18ad2287f2ffbce2a7c29b84208a5e73be40e926246"
  license "Apache-2.0"

  depends_on "openjdk@17" => :build
  depends_on "openjdk"

  conflicts_with "grafana-alloy", because: "both install `alloy` binaries"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("17")
    chmod 0755, "gradlew"
    system "./gradlew", "build", "-x", "test", "--no-daemon"
    libexec.install "org.alloytools.alloy.dist/target/org.alloytools.alloy.dist.jar"
    bin.write_jar_script libexec/"org.alloytools.alloy.dist.jar", "alloy"
  end

  test do
    output = shell_output("#{bin}/alloy version 2>&1")
    filtered_output = output.lines.reject { |line| line.start_with?("Picked up") }.join
    assert_match version.to_s, filtered_output
  end
end
