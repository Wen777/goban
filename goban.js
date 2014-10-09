// Generated by LiveScript 1.3.0
(function(){
  var toIndex, myHash, myGoban;
  toIndex = function(){
    return function(list){
      var i$, to$, results$ = [];
      for (i$ = 0, to$ = list.length - 1; i$ <= to$; ++i$) {
        results$.push(i$);
      }
      return results$;
    };
  };
  myHash = function(){
    return {
      data: location.hash,
      asArray: function(){
        return this.data.replace('#', '').split('&');
      },
      upDateFromArray: function(list){
        location.hash = '#' + list.join('&');
      }
    };
  };
  myGoban = function($http, $sce, $path, $title, $hash, $timeout){
    var goban, parseFromCSV, goLeft, goRight;
    goban = new Object;
    parseFromCSV = function(csv){
      var allTextLines, bodyLines, goodList, lastFolder, bestList;
      allTextLines = csv.split(/\r\n|\n/);
      bodyLines = allTextLines.slice(2);
      goodList = bodyLines.map(function(text){
        return text.split(',');
      }).filter(function(list){
        return list[1];
      });
      lastFolder = {
        id: 0,
        set: function(n){
          this.id = n;
        }
      };
      bestList = goodList.map(function(list, index){
        var isClosed, obj;
        isClosed = false;
        if (!list[0]) {
          lastFolder.set(index);
          if (list[2] && list[2].search(/expand(.+)true/ > -1)) {
            isClosed = true;
          }
        }
        obj = (list[0] && {
          url: list[0].replace(/["\s]/g, ''),
          name: list[1].replace(/["\s]/g, ''),
          isFolder: false,
          pIndex: lastFolder.id
        }) || {
          name: list[1],
          isFolder: true,
          isClosed: isClosed
        };
        return obj;
      });
      return bestList;
    };
    goban.path = $path || '';
    goban.title = $hash.asArray()[0] || $title;
    goban.myI = $hash.asArray()[1] || 0;
    goban.myJ = $hash.asArray()[2] || 0;
    goban.pageLoading = false;
    goban.animate = new Object;
    goban.setI = function(n){
      if (goban.myI !== n) {
        goban.loadPage();
        $timeout(function(){
          goban.myI = n;
          goban.updateHash();
          goban.load(goban.myI);
        }, 1000);
      }
    };
    goban.setJ = function(n){
      if (goban.myJ !== n) {
        goban.loadPage();
        $timeout(function(){
          goban.myJ = n;
          goban.updateHash();
        }, 1000);
      }
    };
    goban.loadPage = function(){
      goban.pageLoading = true;
      $timeout(function(){
        goban.pageLoading = false;
      }, 2300);
    };
    goban.updateHash = function(){
      $hash.upDateFromArray([goban.title, goban.myI, goban.myJ]);
    };
    goban.load = function(num){
      $http({
        method: "GET",
        url: $path + $title + num + '.csv',
        dataType: "text"
      }).success(function(data){
        return goban.data = parseFromCSV(data);
      });
    };
    goban.keyDown = function($event){
      var code;
      console.log($event);
      $event.preventDefault();
      code = $event.keyCode;
      if (code === 40) {
        goban.up(1);
      }
      if (code === 38) {
        goban.up(-1);
      }
      if (code === 37) {
        goban.left(-1);
      }
      if (code === 39) {
        goban.left(1);
      }
      if (code === 32) {
        goban.data[goban.myJ].isClosed = !goban.data[goban.myJ].isClosed;
      }
    };
    goLeft = function(){
      goban.myI = parseInt(goban.myI);
      goban.myI += n;
      if (goban.myI === -1) {
        goban.myI = $colMax;
      }
      if (goban.myI === $colMax + 1) {
        goban.myI = 0;
      }
      goban.updateHash();
    };
    goRight = function(){
      goban.myJ = parseInt(goban.myJ);
      goban.myJ += n;
      if (goban.myJ === -1) {
        goban.myJ = goban.data.length - 1;
      }
      if (goban.myJ === goban.data.length) {
        goban.myJ = 0;
      }
      goban.updateHash();
    };
    goban.left = function(n){
      goban.loadPage();
      goban.load(parseInt(goban.myI) + n);
      if (goban.animate.delay) {
        $timeout(goLeft, goban.animate.delay);
      } else {
        goLeft();
      }
    };
    goban.up = function(n){
      goban.loadPage();
      if (goban.animate.delay) {
        $timeout(goRight, goban.animate.delay);
      } else {
        goRight();
      }
    };
    goban.trust = function(url){
      return $sce.trustAsResourceUrl(url);
    };
    goban.getCurrentURL = function(){
      return goban.trust(goban.data[goban.myJ].url || goban.data[goban.myJ + 1].url);
    };
    return goban;
  };
  angular.module('goban', []).factory('$hash', myHash).factory('$goban', ['$http', '$sce', '$path', '$title', '$hash', '$timeout', myGoban]).filter('toIndex', toIndex);
}).call(this);
