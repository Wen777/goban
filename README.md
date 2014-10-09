goban
=====

use Goban to manage series of  hackfoldrs


## Example
[![Example](http://upload.wikimedia.org/wikipedia/commons/6/63/Goban_19x19_vide.png)](https://bestian.github.io/frontend)


#install

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
	*https://ethercalc.org/your_title0.csv,
	*https://ethercalc.org/your_title1.csv,
	*https://ethercalc.org/your_title2.csv,
	*https://ethercalc.org/your_title3.csv,
	*https://ethercalc.org/your_title4.csv,
	*https://ethercalc.org/your_title5.csv,
	*https://ethercalc.org/your_title6.csv

you may change 'https://ethercalc.org/' to any other path, but your have to save your data use .csv file with same formet as ethercalc, and the path you link must allow http GET request


in your controller, use

```bash
    $scope.goban = $goban;
    $scope.goban.load($goban.myI);
```

to start data binding and load the first data from ethercalsc or other path




## Getting Started with Goban


## Documentation


## Contributing

If you'd like to contribute to Goban