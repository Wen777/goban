goban
=====

use Goban to manage series of  hackfoldrs

# Example
For a simple example, see here: [https://bestian.github.io/frontend]


# Getting Started with Goban

##why Goban?

[http://hackfoldr.org] is an awesome tool to share and collaborate about 20~30 urls with friends by its grouping power and its ethercalc base.

if you have series of hackfolders and about 30~100 urls to share, you might wish to collect them and show in a single-page web app. This is what Goban does.

## Mindset

The Goban mindset it just like a real goban, using coordinates (i,j) to locate an object from a table-like data.

![Example] (http://upload.wikimedia.org/wikipedia/commons/6/63/Goban_19x19_vide.png)


##installation

install goban from bower:

```bash
$ bower install goban 
```

install goban in yourApp.js, use following code:


```bash
angular.module('yourApp', ['goban'])

```

config goban with three constants: $path, $title, $colMax,


```bash
angular.module('goban')
  .constant('$path', 'https://ethercalc.org/')
  .constant('$title', 'your_title')
  .constant('$colMax', 6)

```


use the example code above, Goban will automantically send http GET request to these url when needed: 
	
* https://ethercalc.org/your_title0.csv
* https://ethercalc.org/your_title1.csv
* https://ethercalc.org/your_title2.csv
* https://ethercalc.org/your_title3.csv
* https://ethercalc.org/your_title4.csv
* https://ethercalc.org/your_title5.csv
* https://ethercalc.org/your_title6.csv

you may change 'https://ethercalc.org/' to any other path, but your have to save your data use .csv file with same formet as ethercalc, and the path you link must allow http GET request


in your controller, use

```bash
function yourCtrl($goban) {
    $scope.goban = $goban;
    $scope.goban.load($goban.myI);
}

```
to start data binding.

# binding Goban

##simple binding

```bash
	{{goban.data[i][j]}}
```


##dynamic binding

```bash
	{{goban.data[goban.myI][goban.myJ]}}
```

##keyBorad Control(optional)


```bash
<body ng-keydown="goban.keyDown($event)">
	<!-- HTML -->
</body>

```

## use ng-repeat, goban.setI, goban.setJ
<li ng-repeat = "i in [0,1,2,3,4,5]">
	<a ng-class="{active: goban.myI == i}" ng-click="goban.setI(i)">
	<!-- HTML -->
	</a>
</li>

<li ng-repeat = "j in goban.data | toIndex">
	<a ng-class="{active: goban.myJ == j}" ng-click="goban.setJ(j)">
		<!-- HTML -->
	</a>
</li>

note that toIndex filter is well defined form Goban Module.


# Contributing

If you'd like to contribute to Goban, please contact with: bestian@gmail.com
