angular.module 'appDep'
  .controller 'NavbarCtrl', ($scope, $auth) ->
    $scope.isAuthenticated = ->
      $auth.isAuthenticated()
