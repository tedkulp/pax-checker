angular.module 'appDep'
  .controller 'SignupCtrl', ($scope, $auth) ->
    $scope.signup = ->
      $auth.signup
        firstName: $scope.firstName
        lastName: $scope.lastName
        email: $scope.email
        password: $scope.password
