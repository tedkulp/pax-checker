angular.module 'appDep', ['mgcrea.ngStrap']

angular.module 'app', ['ngRoute', 'ngResource', 'ui.router', 'appDep', 'satellizer']
  .config ($stateProvider, $urlRouterProvider, $authProvider) ->
    $urlRouterProvider.otherwise '/'

    $stateProvider
      .state 'login',
        url: '/login'
        templateUrl: '/js/app/views/login.html'
        controller: 'LoginCtrl'
      .state 'signup',
        url: '/signup'
        templateUrl: '/js/app/views/signup.html'
        controller: 'SignupCtrl'
      .state 'logout',
        url: '/logout'
        template: null
        controller: 'LogoutCtrl'
      .state 'profile',
        url: '/profile'
        templateUrl: '/js/app/views/profile.html'
        controller: 'ProfileCtrl'
        protected: true
