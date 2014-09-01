angular.module 'appDep'
  .directive 'ngConfirmClick',
    ->
      priority: -1
      restrict: 'A'
      link: (scope, element, attrs) ->
        element.bind 'click', (e) ->
          message = attrs.ngConfirmClick;
          if message and !confirm(message)
            e.stopImmediatePropegation()
            e.preventDefault()
