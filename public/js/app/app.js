angular.module('appDep', ['ui.bootstrap']);

angular.module('app', ['ngRoute', 'ngResource', 'ui.router', 'appDep'])
    .config(function($stateProvider, $urlRouterProvider) {
});
