angular.module 'appDep'
  .factory 'ProfileService', ($resource, $http) ->
    $resource '/api/v1/profile', null,
      'update':
        method: 'PUT'
