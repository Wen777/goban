toIndex = ->
	(list)->
		[to list.length-1]

myHash = ->
	data: location.hash
	asArray: ->
		@.data.replace \# '' .split \&
	upDateFromArray: (list) !->
		location.hash = \# + list.join \&

myGoban = ($http, $sce, $path, $title, $hash, $colMax, $timeout)->
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
	goban.animate = new Object
	goban.colMax = $colMax or 3

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
		if goban.animate.delay	
			$timeout (!-> goban.pageLoading = false),goban.animate.delay
		else 
			goban.pageLoading = false

	goban.updateHash =!->
		$hash.upDateFromArray [goban.title, goban.myI,goban.myJ]


	goban.load = (num) !->

		folderName = $title + num
		if typeof goban.folderNames == \array
			folderName = goban.folderNames[num]

		$http {method: "GET",url: $path + folderName + '.csv',dataType: "text"}
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
	
	goX = (n)-> 
				goban.myI = parseInt(goban.myI)
				goban.myI += n
				if goban.myI == -1
					goban.myI = goban.colMax
				if goban.myI == goban.colMax + 1
					goban.myI = 0
				goban.updateHash!

	goY = (n)-> 
			goban.myJ = parseInt(goban.myJ)
			goban.myJ += n
			if goban.myJ == -1
				goban.myJ = goban.data.length-1
			if goban.myJ == goban.data.length
				goban.myJ = 0
			goban.updateHash!

	goban.dx = (n) !->
		goban.loadPage!
		goban.load parseInt(goban.myI) + n
		if goban.animate.delay
			$timeout (goX n),goban.animate.delay
		else
			goX n


	goban.dy = (n) !->
		goban.loadPage!
		if goban.animate.delay
			$timeout (goY n),goban.animate.delay
		else 
			goY n

	goban.trust = (url)->
		$sce.trustAsResourceUrl(url)

	goban.getCurrentURL = ->
		goban.trust((goban.data[goban.myJ] && goban.data[goban.myJ].url) or (goban.data[goban.myJ+1] && goban.data[goban.myJ+1].url))

	goban

angular.module 'goban' []
	.factory '$hash' myHash
	.factory '$goban' [\$http, \$sce, \$path, \$title, \$hash, \$colMax, \$timeout, myGoban]
	.filter 'toIndex' toIndex
