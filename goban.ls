

chainCtrl = ($scope, $colMax,
				$dummy, $goban , $timeout) !->

	$scope.myColumnIndex = [to $colMax]
	$scope.myFolderIndex = [to 10]

	$scope.backup = !->
		for i in $scope.myFolderIndex
			window.open $path+$title+i+'.csv'  \_blank "width=0, height=0, titlebar=no, toolbar=no"

	$scope.goban = $goban;
	$scope.goban.data = $dummy;
	$scope.goban.load $goban.myI;

	window.uploadDone= !->
		alert('ha')
		# have access to $scope here

toIndex = ->
	(list)->
		[to list.length-1]

myHash = ->
	data: location.hash
	asArray: ->
		@.data.replace \# '' .split \&
	upDateFromArray: (list) !->
		location.hash = \# + list.join \&


myDummy = 
		*name: '赤皮仔'
			isFolder: false
			url:'https://autolearn.hackpad.com/33EfKKhNtF8'


myGoban = ($http, $sce, $path, $title, $hash, $timeout)->
	goban = new Object;

	parseFromCSV = (csv) ->
		allTextLines = csv.split(/\r\n|\n/)
		bodyLines = allTextLines.slice(2)
		goodList = bodyLines
					.map (text) -> text.split \,
					.filter (list) -> list[1]

		lastFolder = {id:0 , set: (n)!-> this.id = n}
		
		bestList = goodList.map (list,index) ->
						isClosed = false
						if not list[0]
							lastFolder.set(index)
							if list[2] and list[2].search /expand(.+)true/ > -1
								isClosed = true

						obj = (list[0]
						and {url: list[0].replace(/["\s]/g, ''), name: list[1].replace(/["\s]/g, ''), isFolder: false, pIndex: lastFolder.id})
							or { name: list[1], isFolder: true, isClosed: isClosed}

						obj
		bestList

	goban.path = $path or ''
	goban.title = $hash.asArray![0] or $title
	goban.myI = $hash.asArray![1] or 0
	goban.myJ = $hash.asArray![2] or 0
	goban.pageLoading = false

	goban.setI = (n) !->
		if goban.myI != n
			goban.loadPage!
			$timeout (!-> 
				goban.myI = n
				goban.updateHash!
				goban.load goban.myI),1000

	goban.setJ = (n) !->	
		if goban.myJ != n
			goban.loadPage!
			$timeout (!-> 
				goban.myJ = n
				goban.updateHash!),1000

	goban.loadPage = !->
		goban.pageLoading = true	
		$timeout (!-> goban.pageLoading = false),2300

	goban.updateHash =!->
		$hash.upDateFromArray [goban.title, goban.myI,goban.myJ]


	goban.load = (num) !->
		$http {method: "GET",url: $path + $title + num + '.csv',dataType: "text"}
				.success (data) ->
					goban.data = parseFromCSV data

	goban.keyDown = ($event) !->
		console.log $event
		$event.preventDefault()
		code = $event.keyCode
		if code == 40
			goban.up 1
		if code == 38
			goban.up -1
		if code == 37
			goban.left -1
		if code == 39
			goban.left 1
		if code == 32
			goban.data[goban.myJ].isClosed = !goban.data[goban.myJ].isClosed;
	
	goban.left = (n) !->
		goban.loadPage!
		goban.load parseInt(goban.myI) + n
		$timeout (!-> 
			goban.myI = parseInt(goban.myI)
			goban.myI += n
			if goban.myI == -1
				goban.myI = $colMax
			if goban.myI == $colMax + 1
				goban.myI = 0
			goban.updateHash!
			),1000

	goban.up = (n) !->
		goban.loadPage!
		$timeout (!-> 
			goban.myJ = parseInt(goban.myJ)
			goban.myJ += n
			if goban.myJ == -1
				goban.myJ = goban.data.length-1
			if goban.myJ == goban.data.length
				goban.myJ = 0
			goban.updateHash!),1000

	goban.trust = (url)->
		$sce.trustAsResourceUrl(url)

	goban.getCurrentURL = ->
		goban.trust(goban.data[goban.myJ].url or goban.data[goban.myJ+1].url)

	goban

angular.module 'goban' []
	.factory '$hash' myHash
	.factory '$goban' [\$http, \$sce, \$path, \$title, \$hash, \$timeout, myGoban]
	.filter 'toIndex' toIndex
