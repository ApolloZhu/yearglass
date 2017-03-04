[yearglass](https://github.com/ApolloZhu/yearglass), a command line util, written in Swift 3, to help you be aware of the elapsed time.

Inspired by [year_progress on twitter](https://twitter.com/year_progress)

Year progress by the time of publish: 17% ▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

## Install

Open terminal, and download yearglass by:

```sh
git clone https://github.com/ApolloZhu/yearglass.git
```

If you want to show yearglass when you open console:

```sh
# For Terminal
echo "swift ~/yearglass/main.swift" >> .bash_profile

# For zsh
echo "swift ~/yearglass/main.swift" >> .zshrc
```

If you want to make `yearglass` a command, enter the following line:

```sh
# For Terminal
echo "alias yearglass='swift ~/yearglass/main.swift'" >> .bash_profile

# For zsh
echo "alias yearglass='swift ~/yearglass/main.swift'" >> .zshrc
```

Reopen terminal. Enjoy.

## Update

Open terminal, and enter the following command:

```sh
cd yearglass;git pull;cd ..
```

## Uninstall

Open terminal, and enter the following command to unregister yearglass from preference:

```sh
# For Terminal
sed -i '' '/swift .*yearglass.main.swift/d' .bash_profile

# For zsh
sed -i '' '/swift .*yearglass.main.swift/d' .zshrc
```

Delete program from file system:

```sh
rm -rf yearglass
```

## License

MIT, included in [main.swift](../master/main.swift#L1-#L24)
