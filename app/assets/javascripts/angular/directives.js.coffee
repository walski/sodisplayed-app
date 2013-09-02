@angular.module("manager.directives", []).directive("appVersion", ["version", (version) ->
  (scope, elm, attrs) ->
    elm.text version
]).directive("confirmWith", [->
  restrict: 'A'
  priority: 1
  terminal: true
  link: (scope, element, attrs) ->
    element.bind 'click', (e) ->
      e.preventDefault()

      if confirm(attrs.confirmWith)
        scope.$eval(attrs.ngClick)

]).directive("disableLink", [->
  restrict: 'A'
  link: (scope, element, attrs) ->
    element.bind 'click', (e) ->
      e.preventDefault()
])