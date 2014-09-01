angular.module 'appDep'
  .controller 'ProfileCtrl', ($scope, $http, $auth, $alert) ->
    $http.get '/api/v1/profile'
      .success (data) ->
        $scope.user = data
      .error ->
        $alert
          content: 'Unable to get user information'
          animation: 'fadeZoomFadeDown'
          type: 'material'
          duration: 3
