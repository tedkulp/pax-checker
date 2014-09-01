angular.module 'appDep'
  .controller 'LoginCtrl', ($scope, $alert, $auth) ->
    $scope.login = ->
      $auth.login
        email: $scope.email
        password: $scope.password
      .then ->
        $alert
          content: 'You have successfully logged in'
          animation: 'am-fade-and-scale'
          type: 'info'
          container: '#alerts-container'
          duration: 3
      .catch (response) ->
        $alert
          content: response.data.message
          animation: 'am-fade-and-slide-top'
          type: 'danger'
          container: '#alerts-container'
          duration: 3
