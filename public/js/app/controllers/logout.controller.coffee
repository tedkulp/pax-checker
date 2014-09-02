angular.module 'appDep'
  .controller 'LogoutCtrl', ($scope, $auth, $alert) ->
    $auth.logout()
      .then ->
        $alert
          content: 'You have been logged out'
          type: 'info'
          container: '#alerts-container'
          duration: 3
