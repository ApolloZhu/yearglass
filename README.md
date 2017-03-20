中文版文档请点击这里：[yearglass/年轮项目](https://apollozhu.github.io/2017/03/06/yearglass-project/)

[yearglass](https://github.com/ApolloZhu/yearglass), a command line util, written in Swift 3, to help you be aware of the elapsed time.

Inspired by [year_progress on twitter](https://twitter.com/year_progress), published when 17% of 2017 has passed.

<div id="yearglass-web"></div>

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

----

<script>

	/* The following code is used to generate dynamic yearglass progress bar for the website version of this doc -- [https://apollozhu.github.io/yearglass/](https://apollozhu.github.io/yearglass/). */

	const today = new Date();
	const year = today.getFullYear();
	const thisYear = new Date(year, 0, 1);
	const nextYear = new Date(year + 1, 0, 1);
	const oneDay = today.getMilliseconds();
	const passed = Math.floor((today - thisYear) / oneDay);
	const total = Math.floor((nextYear - thisYear) / oneDay);
	const percentage = passed / total;
	const space = 15;

	function repeat(s, n) {
		return new Array(Math.floor(n + 1)).join(s);
	}

	document.getElementById("yearglass-web").innerHTML = "Year Progress: " + Math.floor(percentage * 100) + "% [" + repeat("▓", space * percentage) + repeat("░", space * (1 - percentage)) + "]";
</script>
