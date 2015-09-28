var app = angular.module("app", ["ui.router"])

.config(['$stateProvider', '$urlRouterProvider',
  function($stateProvider, $urlRouterProvider){
    $urlRouterProvider.otherwise('/')

    $stateProvider
      .state('base', {
        url: "/",
        template: '<base></base>'
      })
      .state('map', {
        url: "/map",
        template: '<map></map>'
      })
  }
])
