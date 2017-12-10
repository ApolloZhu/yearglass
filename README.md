> Time goes by, or maybe it stays?

<div id="yearglass-web"></div>

# [yearglass/年轮项目](https://github.com/ApolloZhu/yearglass)

[![Swift 3 & 4](https://img.shields.io/badge/Swift-3%20%26%204-ffac45.svg)](https://developer.apple.com/swift/)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![MIT License](https://img.shields.io/github/license/ApolloZhu/yearglass.svg)](https://github.com/ApolloZhu/yearglass/blob/master/LICENSE)

A command line util to visualize percentage passed of this year, inspired by [year_progress on twitter](https://twitter.com/year_progress). 中文版文档请点击这里：[年轮项目](https://apollozhu.github.io/2017/03/06/yearglass-project/)

## Install

Open terminal, and install [yearglass](https://github.com/ApolloZhu/yearglass) by:

```sh
eval "$(curl -sL https://raw.githubusercontent.com/ApolloZhu/yearglass/master/install)"
```

----

<details>

<summary>First published when 17% of 2017 has passed.</summary>

<script>

    /* The following code is used to generate dynamic yearglass progress bar for the website version of this doc -- https://apollozhu.github.io/yearglass/ */

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

</details>
