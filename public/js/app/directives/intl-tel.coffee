angular.module 'appDep'
  .directive 'intlTel',
    ->
      replace: true
      restrict: 'E'
      require: 'ngModel'
      template: '<input type="text" placeholder="e.g. +11231231234">'
      link: (scope, element, attrs, ngModel) ->
        read = ->
          inputValue = element.val()
          ngModel.$setViewValue inputValue
        element.intlTelInput
          defaultCountry: 'us'
          preferredCountries: ['us', 'ca', 'gb']
        element.on 'focus blur keyup change', ->
          scope.$apply read
        read()
