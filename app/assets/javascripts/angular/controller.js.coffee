@angular.module("manager.controllers", []).controller("ManagerController", ['$scope', ($scope) ->
  $scope.manager = new Manager()
  $scope.displays = []

  $scope.manager.on 'displayConnected', (display) ->
    $scope.displays.push(display)
    $scope.$apply()

  $scope.manager.on 'displayDisconnected', (display) ->
    $scope.displays.splice($scope.displays.indexOf(display), 1)
    $scope.$apply()

  $scope.identifyDisplay = (display) ->
    display.identify($scope.displays.indexOf(display))

  $scope.identifyAll = () ->
    display.identify($scope.displays.indexOf(display)) for display in $scope.displays

  $scope.reloadAll = () ->
    $scope.manager.broadcast(action: 'reload')

  $scope.showText = (text) ->
    return if $scope.displays.length < 1

    displayIndex = 0
    charactersPerScreen = Math.floor(text.length / $scope.displays.length)
    overhang = text.length - (Math.floor(text.length / $scope.displays.length) * $scope.displays.length)
    noOverhangCliff = $scope.displays.length - overhang

    texts = []
    display = 0
    for character in text.split('') when display?
      texts[display] ||= ''
      texts[display] += character

      if texts[display].length >= (charactersPerScreen + (if display < noOverhangCliff then 0 else 1))
        display += 1

    display = 0
    for text in texts
      $scope.displays[display].showText(text)
      display += 1

  $scope.countdown = ->
    $scope.countDownRunning = true

    $scope.manager.broadcast(action: 'prepareCountdown')

    counts = [3,2,1]
    lastWord = "GO"
    lastWord += "!" while lastWord.length < $scope.displays.length

    shortTimeout = 800
    longTimeout = 1500

    chainCountdown = (displayIndex) ->
      display = $scope.displays[displayIndex]
      lastDisplay = displayIndex is $scope.displays.length - 1
      display.countdown(if lastDisplay then counts.shift() else '.')
      if counts.length < 1
        $scope.countDownRunning = false
        setTimeout(->
          $scope.showText(lastWord)
        , longTimeout * 2)
        return

      timeout = shortTimeout
      if lastDisplay
        displayIndex = -1
        timeout = longTimeout

      displayIndex += 1
      setTimeout((-> chainCountdown(displayIndex)), timeout)

    chainCountdown(0)
])