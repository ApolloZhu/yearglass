# yearglass
Time is passing quickly, but we are not aware of it.
Inspired by [year_progress on twitter](https://twitter.com/year_progress)

Year Progress: 17% ▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

## Install
Open terminal, and enter the following commands:
```sh
git clone https://github.com/ApolloZhu/yearglass.git
echo "swift ~/yearglass/main.swift" >> .bash_profile 
```
Close teriminal, and you'll see the progress bar each time you open the terminal window.

**Tips**: if you want to quickly show it as command `yearglass`, etner the following line, and reopen terminal:

```sh
echo "alias yearglass='swift ~/yearglass/main.swift'" >> .bash_profile
```

## Update
Open terminal, and enter the following command:
```sh
cd yearglass;git pull;cd ..
```

## Uninstall
Open terminal, and type in following commands:
```sh
sed -i '' '/swift .*yearglass.main.swift/d' .bash_profile
rm -rf yearglass
```

## License
MIT, included in [main.swift](../master/main.swift#L1-#L24)
