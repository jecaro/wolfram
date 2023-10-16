# Wolfram

[![CI][status-png]][status]

Simple implementation of [elementary cellular 
automaton][Elementary_cellular_automaton] in Haskell.

![demo][demo]

# Hacking

The project can be build with [nix][nix].

Install with:

```bash
$ nix profile install
```

Build with:

```bash
$ nix build
```

The binary is then created in `./result/bin/wolfram`

Hack with:

```bash
$ nix develop
```

You will be dropped in a shell with all the needed tools in scope: `cabal` to 
build the project and `haskell-language-server` for a better developer 
experience.

[Elementary_cellular_automaton]: https://en.wikipedia.org/wiki/Elementary_cellular_automaton
[demo]: ./demo.png
[nix]: https://nixos.org/
[status-png]: https://github.com/jecaro/wolfram/workflows/CI/badge.svg
[status]: https://github.com/jecaro/wolfram/actions
