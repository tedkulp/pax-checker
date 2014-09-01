angular.module 'appDep'
  .controller 'ProfileCtrl', ($scope, $http, $auth, $alert, $modal, ProfileService) ->
    modal = undefined

    $http.get '/api/v1/profile'
      .success (data) ->
        $scope.user = data
      .error ->
        $alert
          content: 'Unable to get user information'
          animation: 'fadeZoomFadeDown'
          type: 'material'
          duration: 3

    $scope.addNotification = ->
      $scope.notification =
        type: 'sms'
        address: ''

      modal = $modal
        scope: $scope
        template: '/js/app/views/add-notification.html'
        show: true

    $scope.saveNotification = (notification) ->
      $scope.user.notifications.push(notification)
      modal.hide()

    $scope.deleteNotification = (notification) ->
      $scope.user.notifications = _.reject $scope.user.notifications, (thisNot) ->
        thisNot.address == notification.address and thisNot.type == notification.type

    $scope.save = ->
      ProfileService.update {}, $scope.user
