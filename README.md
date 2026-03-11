# homebrew-custom

Custom Homebrew formulae.

## Formulae

### Alloy Analyzer

[Alloy](https://alloytools.org) language and analyzer for software modeling, built from source using Gradle. The homebrew-core formula downloads a pre-built JAR; this formula compiles from the GitHub source.

```
brew install vincentlu/custom/alloy-analyzer
```

### Emacs

GNU Emacs built with the native macOS Cocoa GUI (`--with-ns`).

```
brew install vincentlu/custom/emacs
```

To update:

```
brew update
brew upgrade vincentlu/custom/emacs
```

#### Differences from upstream

| Aspect | Upstream | Custom |
|--------|----------|--------|
| `--with-ns` / `--without-ns` | `--without-ns` (terminal-only) | `--with-ns` (builds macOS Cocoa GUI) |
| Emacs.app install | no | `prefix.install "nextstep/Emacs.app"` |
| `bin/emacs` | standard binary from `make install` | shell wrapper that execs `Emacs.app/Contents/MacOS/Emacs` |
| ctags cleanup | unlinks `bin/ctags` and `man1/ctags.1.gz` | skipped (not needed with `--with-ns`) |

## License

Formulae are derived from [Homebrew/homebrew-core](https://github.com/Homebrew/homebrew-core) and licensed under the [BSD-2-Clause](LICENSE) license.
